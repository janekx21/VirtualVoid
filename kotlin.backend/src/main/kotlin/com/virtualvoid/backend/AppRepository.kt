package com.virtualvoid.backend

import com.virtualvoid.backend.model.*
import org.springframework.stereotype.Repository
import reactor.core.publisher.Sinks
import java.util.*
import kotlin.random.Random
import kotlin.random.nextInt

interface CrudeRepository<ID, T> {
    val size: Int
    val all: List<T>
    fun isEmpty(): Boolean
    fun contains(id: ID): Boolean
    fun add(key: ID, value: T)
    fun remove(key: ID)
    fun get(key: ID): T
    fun resolve(key: ID?): T?
    fun replace(key: ID, value: T)
}

interface Item {
    val id: UUID
}

abstract class GenericRepository<T> : CrudeRepository<UUID, T> {
    private val map = mutableMapOf<UUID, T>()
    override val size: Int
        get() = map.size
    override val all: List<T>
        get() = map.values.toList()

    override fun isEmpty(): Boolean = map.isEmpty()

    override fun contains(id: UUID): Boolean = map.contains(id)

    override fun add(key: UUID, value: T) {
        map[key] = value
    }

    override fun remove(key: UUID) {
        map.remove(key) ?: throw ItemNotFoundException(key)
    }

    override fun get(key: UUID): T = map[key] ?: throw ItemNotFoundException(key)

    override fun replace(key: UUID, value: T) {
        if (!map.contains(key)) throw ItemNotFoundException(key)
        map[key] = value
    }

    override fun resolve(key: UUID?): T? = map.get(key)
}

class IssueRepository : GenericRepository<Issue>()

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
    val projects = mutableListOf(Project(createID(), "Demo", "DMO"))
    val backlogs = mutableListOf(
        Backlog(createID(), "Product Backlog", projects[0]),
        Backlog(createID(), "Sprint 1", projects[0]),
        Backlog(createID(), "Sprint 2", projects[0]),
    )
    val issues = MutableList(10) {
        Issue(
            createID(),
            backlogs.random(),
            Random.nextInt(100..1000),
            "Name ${randomSentence(2)}",
            "Description ${randomSentence(20)}",
            epics.random(),
            Importance.values().random(),
            Improvement(states.random(), 42),
        )
    }

    val issuesChange = Sinks.many().multicast().directBestEffort<Issue>()

    fun findIssueIndex(id: UUID): Int {
        val index = issues.indexOfFirst { it.id == id }
        if (index == -1) throw IssueNotFoundException(id)
        return index
    }

    fun findIssue(id: UUID): Issue = issues.find { it.id == id } ?: throw IssueNotFoundException(id)
    fun findEpic(id: UUID): Epic = epics.find { it.id == id } ?: throw EpicNotFoundException(id)
    fun findState(id: UUID): State = states.find { it.id == id } ?: throw StateNotFoundException(id)

    fun resolveEpic(id: UUID?): Epic? = if (id == null) null else findEpic(id)
    fun resolveState(id: UUID?): State? = if (id == null) null else findState(id)

    fun replaceIssue(issue: Issue) {
        val index = findIssueIndex(issue.id)
        issues[index] = issue
        issuesChange.tryEmitNext(issue)
    }
}
