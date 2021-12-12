package com.virtualvoid.backend

import com.expediagroup.graphql.generator.SchemaGeneratorConfig
import com.expediagroup.graphql.generator.TopLevelObject
import com.expediagroup.graphql.generator.annotations.GraphQLDescription
import com.expediagroup.graphql.generator.extensions.print
import com.expediagroup.graphql.generator.toSchema
import com.expediagroup.graphql.server.operations.Mutation
import com.expediagroup.graphql.server.operations.Query
import com.expediagroup.graphql.server.operations.Subscription
import com.virtualvoid.backend.model.*
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication
import org.springframework.context.annotation.Bean
import org.springframework.http.HttpMethod
import org.springframework.http.HttpStatus
import org.springframework.stereotype.Component
import org.springframework.web.server.ServerWebExchange
import org.springframework.web.server.WebFilter
import org.springframework.web.server.WebFilterChain
import reactor.core.publisher.Flux
import reactor.core.publisher.Mono
import java.io.File
import java.time.Duration
import java.util.*
import kotlin.random.Random

fun main(args: Array<String>) {
    val config = SchemaGeneratorConfig(listOf("com.virtualvoid.backend"), hooks = CustomSchemaGeneratorHooks())
    val schema = toSchema(
        config,
        listOf(TopLevelObject(AppQuery::class)),
        listOf(TopLevelObject(AppMutation::class)),
        listOf(TopLevelObject(AppSubscription::class)),
    )
    File("../common/src/schema.graphql").writeText(schema.print())
    runApplication<BackendApplication>(*args)
}

@SpringBootApplication
class BackendApplication {
    @Bean
    fun hooks() = CustomSchemaGeneratorHooks()

    private val logger: Logger = LoggerFactory.getLogger(BackendApplication::class.java)

    init {
        logger.info("Hosting playground at http://localhost:8080/playground")
    }
}

@Component
class CorsFilter : WebFilter {
    override fun filter(ctx: ServerWebExchange, chain: WebFilterChain): Mono<Void> {
        ctx.response.headers.add("Access-Control-Allow-Origin", "http://localhost:3000")
        ctx.response.headers.add("Access-Control-Allow-Methods", "GET, PUT, POST, DELETE, OPTIONS")
        ctx.response.headers.add("Access-Control-Allow-Credentials", "true")
        ctx.response.headers.add(
            "Access-Control-Allow-Headers",
            "DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Content-Range,Range"
        )
        return when (ctx.request.method) {
            HttpMethod.OPTIONS -> {
                ctx.response.headers.add("Access-Control-Max-Age", "1728000")
                ctx.response.statusCode = HttpStatus.NO_CONTENT
                Mono.empty()
            }
            else -> {
                ctx.response.headers.add(
                    "Access-Control-Expose-Headers",
                    "DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Content-Range,Range"
                )
                chain.filter(ctx)
            }
        }
    }
}

// todo cool idea
/*
data class Model(val issues: List<String>)
data class Request(val parameter: Optional<String>)
data class Result(val data: String)

fun addIssues(currentModel: Model, request: Request): Pair<Model, Result> =
    Pair(currentModel.copy(issues = currentModel.issues + "new issue"), Result(data = "succeed"))

fun foo(r: Request): String = r.parameter.map { "Foo" }.orElseGet { "nothing" }
 */

@Component
@Suppress("unused")
class AppQuery(val repo: AppRepository) : Query {
    @GraphQLDescription("Returns all projects")
    fun projects(): List<Project> = repo.projects.values.toList()

    @GraphQLDescription("Returns a project")
    fun project(id: UUID): Project = repo.projects.find(id)

    @GraphQLDescription("Returns all backlogs")
    fun backlogs(): List<Backlog> = repo.backlogs.values

    @GraphQLDescription("Finds a backlog")
    fun backlog(id: UUID): Backlog = repo.backlogs.find(id)

    @GraphQLDescription("Returns all issues")
    fun issues(): List<Issue> = repo.issues.values

    @GraphQLDescription("Finds an issue")
    fun issue(id: UUID): Issue = repo.issues.find(id)

    @GraphQLDescription("Returns all epics")
    fun epics(): List<Epic> = repo.epics

    @GraphQLDescription("Returns all states")
    fun states(): List<State> = repo.states
}

@Suppress("unused")
@Component
class AppMutation(val repo: AppRepository) : Mutation {
    @GraphQLDescription("Creates a new Project")
    fun createProject(name: String, short: String): Project =
        Project(createID(), name, short).also { repo.projects.add(it) }

    @GraphQLDescription("Updates a Project. Returns the previous value.")
    fun updateProject(id: UUID, name: String): Project {
        val new = repo.projects.find(id).copy(name = name)
        return repo.projects.replace(new)
    }

    @GraphQLDescription("Removes a Project")
    fun removeProject(id: UUID): Project = repo.projects.remove(id).also { project ->
        repo.backlogs.removeAll { it.project == project }
        repo.issues.removeAll { it.backlog.project == project }
    }

    @GraphQLDescription("Creates a new Backlog")
    fun createBacklog(title: String, project: UUID): Backlog =
        Backlog(createID(), title, repo.projects.find(project)).also { repo.backlogs.add(it) }

    @GraphQLDescription("Removes a Backlog")
    fun removeBacklog(id: UUID): Backlog =
        repo.backlogs.remove(id).also { backlog -> repo.issues.removeAll { it.backlog == backlog } }

    @GraphQLDescription("Creates an Issue")
    fun createIssue(create: IssueCreate): Issue = repo.issues.add(createToIssue(create))

    @GraphQLDescription("Updates an Issue")
    fun updateIssue(update: IssueUpdate): Issue =
        combineUpdateAndIssue(update, repo.issues.find(update.id)).also { repo.issues.replace(it) }

    @GraphQLDescription("Remove an Issue")
    fun removeIssue(id: UUID): Issue = repo.issues.remove(id)

    private fun createToIssue(create: IssueCreate): Issue = Issue(
        createID(),
        repo.backlogs.find(create.backlog),
        create.type,
        repo.issues.values.maxOfOrNull { it.number } ?: 1,
        create.name,
        create.description,
        repo.findEpic(Optional.ofNullable(create.epic).orElse(zeroID)),
        repo.findState(create.state),
        create.importance,
        create.points
    )

    private fun combineUpdateAndIssue(update: IssueUpdate, issue: Issue): Issue = issue.copy(
        name = update.name.toOptional().orElse(issue.name),
        description = update.description.toOptional().orElse(issue.description),
        importance = update.importance.toOptional().orElse(issue.importance),
        epic = update.epic.toOptionalOrZero().map { repo.resolveEpic(it) }.orElse(issue.epic),
        state = update.state.toOptional().map { repo.findState(it) }.orElse(issue.state),
    )
}

@Component
@Suppress("unused")
class AppSubscription(val repo: AppRepository) : Subscription {
    @GraphQLDescription("Returns subscribed issue when it changes")
    fun changedIssue(id: UUID): Flux<Issue> = repo.issuesChange.asFlux().filter { it.id == id }

    @GraphQLDescription("Returns a random number every second")
    fun counter(limit: Int? = null): Flux<Int> = Flux.interval(Duration.ofSeconds(1)).map {
        val value = Random.nextInt()
        println("Returning $value from counter")
        value
    }
}
