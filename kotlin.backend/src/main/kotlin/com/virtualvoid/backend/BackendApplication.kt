package com.virtualvoid.backend

import com.expediagroup.graphql.generator.SchemaGeneratorConfig
import com.expediagroup.graphql.generator.TopLevelObject
import com.expediagroup.graphql.generator.annotations.GraphQLDescription
import com.expediagroup.graphql.generator.extensions.print
import com.expediagroup.graphql.generator.toSchema
import com.expediagroup.graphql.server.operations.Mutation
import com.expediagroup.graphql.server.operations.Query
import com.expediagroup.graphql.server.operations.Subscription
import com.virtualvoid.backend.AppRepository.Companion.createID
import com.virtualvoid.backend.model.*
import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.http.HttpMethod
import org.springframework.http.HttpStatus
import org.springframework.stereotype.Component
import org.springframework.web.reactive.config.CorsRegistry
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
}

@Component
class CorsFilter : WebFilter {
    override fun filter(ctx: ServerWebExchange, chain: WebFilterChain): Mono<Void> {
        ctx.response.headers.add("Access-Control-Allow-Origin", "http://localhost:3000")
        ctx.response.headers.add("Access-Control-Allow-Methods", "GET, PUT, POST, DELETE, OPTIONS")
        ctx.response.headers.add("Access-Control-Allow-Credentials", "true")
        ctx.response.headers.add("Access-Control-Allow-Headers", "DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Content-Range,Range")
        return when {
            ctx.request.method == HttpMethod.OPTIONS -> {
                ctx.response.headers.add("Access-Control-Max-Age", "1728000")
                ctx.response.statusCode = HttpStatus.NO_CONTENT
                Mono.empty()
            }
            else -> {
                ctx.response.headers.add("Access-Control-Expose-Headers", "DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Content-Range,Range")
                chain.filter(ctx)
            }
        }
    }
}

@Component
@Suppress("unused")
class AppQuery(val repo: AppRepository) : Query {
    @GraphQLDescription("Returns all issues")
    fun issues(): List<Issue> = repo.issues

    @GraphQLDescription("Returns all backlogs")
    fun backlogs(): List<Backlog> = repo.backlogs

    @GraphQLDescription("Returns all states")
    fun states(): List<State> = repo.states

    @GraphQLDescription("Returns all epics")
    fun epics(): List<Epic> = repo.epics

    @GraphQLDescription("Returns all projects")
    fun projects(): List<Project> = repo.projects
}

@Suppress("unused")
@Component
class AppMutation(val repo: AppRepository) : Mutation {
    fun createProject(name: String, short: String) {
        repo.projects.add(Project(createID(), name, short))
    }

    fun removeProject(id: UUID) {
        val index = repo.projects.indexOfFirst { it.id == id }
        val project = repo.projects[index]
        repo.backlogs.removeAll { it.project == project }
        repo.issues.removeAll { it.backlog.project == project }
        repo.projects.removeAt(index)
    }

    fun createBacklog(title: String, project: UUID) {
        repo.backlogs.add(Backlog(createID(), title, repo.findProject(project)))
    }

    fun removeBacklog(id: UUID) {
        val index = repo.backlogs.indexOfFirst { it.id == id }
        val backlog = repo.backlogs[index]
        repo.issues.removeAll { it.backlog == backlog } // TODO bad idea?
        repo.backlogs.removeAt(index)
    }

    fun createIssue(create: IssueCreate): Issue {
        val issue = Issue(
            createID(),
            repo.findBacklog(create.backlog),
            create.type,
            repo.issues.maxOfOrNull { it.number } ?: 1,
            create.name,
            create.description,
            repo.resolveEpic(create.epic),
            repo.findState(create.state),
            create.importance,
            create.points
        )
        repo.issues.add(issue)
        return issue
    }

    fun updateIssue(update: IssueUpdate): Issue {
        var issue = repo.findIssue(update.id)
        update.name.ifDefined { issue = issue.copy(name = it) }
        update.description.ifDefined { issue = issue.copy(description = it) }
        update.importance.ifDefined { issue = issue.copy(importance = it) }
        update.epic.ifDefinedOrNull { issue = issue.copy(epic = repo.resolveEpic(it)) }
        update.state.ifDefined { issue = issue.copy(state = repo.findState(it)) }
        repo.replaceIssue(issue)
        return issue
    }

    fun removeIssue(id: UUID): Issue {
        val index = repo.findIssueIndex(id)
        val issue = repo.issues[index]
        repo.issues.removeAt(index)
        return issue
    }
}

@Component
@Suppress("unused")
class AppSubscription(val repo: AppRepository) : Subscription {
    @GraphQLDescription("Returns subscribed issue when it changes")
    fun changedIssue(id: UUID): Flux<Issue> {
        return repo.issuesChange.asFlux().filter { it.id == id }
    }

    @GraphQLDescription("Returns a random number every second")
    fun counter(limit: Int? = null): Flux<Int> {
        val flux = Flux.interval(Duration.ofSeconds(1)).map {
            val value = Random.nextInt()
            println("Returning $value from counter")
            value
        }

        return if (limit != null) {
            flux.take(limit.toLong())
        } else {
            flux
        }
    }
}
