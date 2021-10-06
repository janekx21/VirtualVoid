package com.virtualvoid.backend.model

import com.expediagroup.graphql.generator.execution.OptionalInput
import java.util.*

data class Issue(
    val id: UUID,
    val backlog: Backlog,
    val number: Int,
    val name: String,
    val description: String,
    val epic: Epic?,
    val importance: Importance,

    val detail: Detail
) {
    init {
        require(number > 0)
        require(name.length in 1..200)
    }
}

interface Detail

data class Improvement(val state: State, val points: Int) : Detail
data class Bug(val state: State, val points: Int) : Detail
data class Dept(val state: State, val points: Int) : Detail
data class Story(val points: Int) : Detail
data class Task(val state: State, val points: Int, val parent: Issue) : Detail

data class IssueCreate(
    val name: String = "",
    val description: String = "",
    val epic: UUID? = null,
    val importance: Importance = Importance.medium,
)

/**
 * Updates an [Issue]
 */
data class IssueUpdate(
    val name: OptionalInput<String>,
    val description: OptionalInput<String>,
    val epic: OptionalInput<UUID?>,
    val importance: OptionalInput<Importance>,
)
