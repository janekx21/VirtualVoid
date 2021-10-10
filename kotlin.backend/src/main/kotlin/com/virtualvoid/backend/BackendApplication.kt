package com.virtualvoid.backend

import com.expediagroup.graphql.generator.annotations.GraphQLDescription
import com.expediagroup.graphql.server.operations.Mutation
import com.expediagroup.graphql.server.operations.Query
import com.expediagroup.graphql.server.operations.Subscription
import com.virtualvoid.backend.AppRepository.Companion.createID
import com.virtualvoid.backend.model.*
import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication
import org.springframework.context.annotation.Bean
import org.springframework.stereotype.Component
import reactor.core.publisher.Flux
import java.time.Duration
import java.util.*
import kotlin.random.Random

fun main(args: Array<String>) {
    runApplication<BackendApplication>(*args)
}

@SpringBootApplication
class BackendApplication {
    @Bean
    fun hooks() = CustomSchemaGeneratorHooks()
}

@Component
@Suppress("unused")
class IssueQuery(val repo: AppRepository) : Query {
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
class IssueMutation(val repo: AppRepository) : Mutation {
    fun createIssue(create: IssueCreate): Issue {
        val issue = Issue(
            createID(),
            repo.backlogs.random(),
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

    fun updateIssue(id: UUID, update: IssueUpdate): Issue {
        var issue = repo.findIssue(id)
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
class IssueSubscription(val repo: AppRepository) : Subscription {
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
