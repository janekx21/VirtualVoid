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
        Epic(createID(), "Frontend", "FE", randomColor()),
        Epic(createID(), "Backend", "BE", randomColor()),
        Epic(createID(), "Security", "SY", randomColor()),
        Epic(createID(), "API", "AP", randomColor()),
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
        val demoProject = projects.add(Project(createID(), "Demo", "DMO", "/assets/pexels-mikhael-mayim-8826427.jpg"))
        backlogs.addAll(
            listOf(
                Backlog(createID(), "Product Backlog", demoProject),
                Backlog(createID(), "Sprint 1", demoProject),
                Backlog(createID(), "Sprint 2", demoProject),
            )
        )
        val special = backlogs.add(Backlog(createID(), "Special", demoProject))

        projects.add(
            Project(
                createID(),
                "Workshop",
                "WS",
                "https://images.pexels.com/photos/245535/pexels-photo-245535.jpeg?auto=compress&cs=tinysrgb&dpr=3&h=750&w=1260"
            )
        )

        projects.add(
            Project(
                createID(),
                "Skyscraper Glas Front",
                "SCGF",
                "https://images.pexels.com/photos/3735677/pexels-photo-3735677.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260"
            )
        )

        projects.add(
            Project(
                createID(),
                "pergamon",
                "PG",
                "https://images.pexels.com/photos/8427830/pexels-photo-8427830.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260"
            )
        )
        projects.add(
            Project(
                createID(),
                "LUCILIUD",
                "L",
                "https://images.pexels.com/photos/6998682/pexels-photo-6998682.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260"
            )
        )

        issues.addAll(List(20) {
            Issue(
                createID(),
                backlogs.values.random(),
                IssueType.values().random(),
                Random.nextInt(100..1000),
                "Name ${randomSentence(Random.nextInt(2..5))}",
                "Description ${randomSentence(Random.nextInt(20..50))}",
                epics.random(),
                states.random(),
                Importance.values().random(),
                Random.nextInt(0..13)
            )
        })

        issues.add(
            Issue(
                createID(), special, IssueType.BUG, 42, "Markdown Bug", """
            # Heading
            ## Heading 2
            ### Heading 3
            - list
            - list2
            - list 3
            ---
            1. foo
            2. bar
            3. fobar
            
            Das ist ein Paragraph zB
        """.trimIndent(), null, states.random(), Importance.HIGH, 8
            )
        )

        issues.add(
            Issue(
                createID(), special, IssueType.TASK, 1, "Readme", """
## About The Project

<!-- TODO write something about the project -->


## Build With
- Backend
  - Kotlin
  - GraphQL
- Frontend
  - Elm
  - elm-ui
  - Material Icons
  - elm-graphql


## Getting Started

### Prerequisites
Install Elm-Live for the frontend development server.
```shell
npm install -g elm-live
```

### Starting
Start a live reload dev server for the frontend.
```shell
elm.frontend/develop.sh
```

## Usage
### Entities

- Project
- Backlog
- Issue
- Epic
- State

### Features

#### Project

- [x] show all Projects
- [x] show a Project by id
- [x] add Project
- [x] remove Project
- [x] change Project name

#### Backlog

- [x] show all Backlogs
- [x] show a Backlog by id
- [x] add Backlog
- [x] remove Backlog
- [ ] change Backlog name

#### Issue

- [x] show all Issues
- [x] show an Issue
- [x] add Issue
- [x] remove Issue
- [x] change Issue

#### Epic

- [x] show all Epics
- [ ] add Epic
- [ ] remove Epic
- [ ] change Epic name

#### State

- [x] show all States
- [ ] add State
- [ ] remove State
- [ ] change State name

### Routing

#### `/`
dash

#### `/projects`
all projects

#### `/projects/{project}`
a project

#### `/projects/{project}/backlogs`
all backlogs of a project

#### `/projects/{project}/issues`
all issues of a project

#### `/issues/{issue}`
an issue

#### `/boards/{board}`
a board


## Roadmap
1. [ ] Building a vertical slice

## Contributing
## License
## Contact
        """.trimIndent(), null, states.last(), Importance.LOW, 0
            )
        )
    }

    companion object {
        fun randomColor() = Color(Random.nextFloat(), Random.nextFloat(), Random.nextFloat())
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
            "amet"
        )
    }
}
