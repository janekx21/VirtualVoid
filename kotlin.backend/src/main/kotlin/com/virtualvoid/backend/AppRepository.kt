package com.virtualvoid.backend

import com.virtualvoid.backend.model.*
import org.springframework.stereotype.Repository
import reactor.core.publisher.Sinks
import java.util.*
import kotlin.random.Random
import kotlin.random.nextInt

@Repository
class AppRepository {
    val epics = mutableListOf(
        Epic(createID(), "Frontend", "FE"),
        Epic(createID(), "Backend", "BE"),
        Epic(createID(), "Security", "SY"),
        Epic(createID(), "API", "AP"),
    )
    val states = mutableListOf(
        State(createID(), "Todo"),
        State(createID(), "Progress"),
        State(createID(), "Review"),
        State(createID(), "Done"),
    )

    val projects = mutableMapOf<UUID, Project>()
    fun addProject(value: Project): Project = value.also { projects[it.id] = it }
    fun replaceProject(value: Project): Project =
        projects.replace(value.id, value) ?: throw EntityNotFoundException(value.id, "project")

    fun removeProject(id: UUID): Project = projects.remove(id) ?: throw EntityNotFoundException(id, "project")
    fun findProject(id: UUID): Project = projects[id] ?: throw EntityNotFoundException(id, "project")

    val backlogs = mutableListOf<Backlog>()
    val issues = mutableListOf<Issue>()
    val issuesChange = Sinks.many().multicast().directBestEffort<Issue>()

    fun findIssueIndex(id: UUID): Int {
        val index = issues.indexOfFirst { it.id == id }
        if (index == -1) throw EntityNotFoundException(id, "issue")
        return index
    }

    fun findIssue(id: UUID): Issue = issues.find { it.id == id } ?: throw EntityNotFoundException(id, "issue")
    fun findEpic(id: UUID): Epic = epics.find { it.id == id } ?: throw EntityNotFoundException(id, "epic")
    fun findState(id: UUID): State = states.find { it.id == id } ?: throw EntityNotFoundException(id, "state")
    fun findBacklog(id: UUID): Backlog = backlogs.find { it.id == id } ?: throw EntityNotFoundException(id, "backlog")
    // fun findProject(id: UUID): Project = projects.find { it.id == id } ?: throw EntityNotFoundException(id, "project")

    fun resolveEpic(id: UUID): Epic? = if (id.isZero) null else findEpic(id)

    fun replaceIssue(issue: Issue) {
        val index = findIssueIndex(issue.id)
        issues[index] = issue
        issuesChange.tryEmitNext(issue)
    }

    init {
        val demoProject = addProject(Project(createID(), "Demo", "DMO"))
        backlogs.addAll(
            listOf(
                Backlog(createID(), "Product Backlog", demoProject),
                Backlog(createID(), "Sprint 1", demoProject),
                Backlog(createID(), "Sprint 2", demoProject),
            )
        )

        issues.addAll(List<Issue>(10) {
            Issue(
                createID(),
                backlogs.random(),
                IssueType.values().random(),
                Random.nextInt(100..1000),
                "Name ${randomSentence(2)}",
                "Description ${randomSentence(20)}",
                epics.random(),
                states.random(),
                Importance.values().random(),
                Random.nextInt(0..13)
            )
        })
    }

    companion object {
        fun randomSentence(len: Int): String = List(len) { randomWord() }.joinToString(" ")
        private fun randomWord(): String = listOf("Foo", "Bar", "Fizz", "Buzz").random()
        fun createID(): UUID = UUID.randomUUID()
    }
}
