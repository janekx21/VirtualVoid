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

    val projects = createRepository<Project>()
    val backlogs = createRepository<Backlog>()
    val issues = createRepository<Issue>()

    val issuesChange = Sinks.many().multicast().directBestEffort<Issue>()

    fun findEpic(id: UUID): Epic = epics.find { it.id == id } ?: throw EntityNotFoundException(id, "epic")
    fun findState(id: UUID): State = states.find { it.id == id } ?: throw EntityNotFoundException(id, "state")

    fun resolveEpic(id: UUID): Epic? = if (id.isZero) null else findEpic(id)

    init {
        val demoProject = projects.add(Project(createID(), "Demo", "DMO"))
        backlogs.addAll(
            listOf(
                Backlog(createID(), "Product Backlog", demoProject),
                Backlog(createID(), "Sprint 1", demoProject),
                Backlog(createID(), "Sprint 2", demoProject),
            )
        )

        issues.addAll(List(10) {
            Issue(
                createID(),
                backlogs.values.random(),
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
        private fun randomWord(): String = words.random()
        private val words = listOf(
        "Lorem",
        "ipsum",
        "dolor",
        "sit",
        "amet",
        "consetetur",
        "sadipscing",
        "elitr",
        "sed",
        "diam",
        "nonumy",
        "eirmod",
        "tempor",
        "invidunt",
        "ut",
        "labore",
        "et",
        "dolore",
        "magna",
        "aliquyam",
        "erat",
        "sed",
        "diam",
        "voluptua",
        "At",
        "vero",
        "eos",
        "et",
        "accusam",
        "et",
        "justo",
        "duo",
        "dolores",
        "et",
        "ea",
        "rebum",
        "Stet",
        "clita",
        "kasd",
        "gubergren",
        "no",
        "sea",
        "takimata",
        "sanctus",
        "est",
        "Lorem",
        "ipsum",
        "dolor",
        "sit",
        "amet",
        "Lorem",
        "ipsum",
        "dolor",
        "sit",
        "amet",
        "consetetur",
        "sadipscing",
        "elitr",
        "sed",
        "diam",
        "nonumy",
        "eirmod",
        "tempor",
        "invidunt",
        "ut",
        "labore",
        "et",
        "dolore",
        "magna",
        "aliquyam",
        "erat",
        "sed",
        "diam",
        "voluptua",
        "At",
        "vero",
        "eos",
        "et",
        "accusam",
        "et",
        "justo",
        "duo",
        "dolores",
        "et",
        "ea",
        "rebum",
        "Stet",
        "clita",
        "kasd",
        "gubergren",
        "no",
        "sea",
        "takimata",
        "sanctus",
        "est",
        "Lorem",
        "ipsum",
        "dolor",
        "sit",
        "amet")
    }
}
