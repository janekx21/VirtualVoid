package com.virtualvoid.backend.model

import com.expediagroup.graphql.generator.execution.OptionalInput
import java.util.*

// TODO
data class Story(
    val id: UUID,
    val backlog: Backlog,
    val name: String,
    val description: String,
    val tasks: List<Issue>
)

data class Issue(
    val id: UUID,
    val backlog: Backlog,
    val type: IssueType,
    val number: Int,
    val name: String,
    val description: String,
    val epic: Epic?,
    val state: State,
    val importance: Importance,
    val points: Int
) {
    init {
        require(number > 0)
        require(name.length in 1..200)
        require(points in 0..99)
    }
}

/**
 * Creates an [Issue]
 */
data class IssueCreate(
    val backlog: UUID,
    val name: String = "",
    val description: String = "",
    val epic: UUID? = null,
    val importance: Importance = Importance.MEDIUM,
    val type: IssueType,
    val state: UUID,
    val points: Int,
)

/**
 * Updates an [Issue]
 */
data class IssueUpdate(
    val id: UUID,
    val name: OptionalInput<String>,
    val description: OptionalInput<String>,
    val epic: OptionalInput<UUID?>,
    val importance: OptionalInput<Importance>,
    val state: OptionalInput<UUID>,
    val points: OptionalInput<Int>,
)

enum class IssueType {
    IMPROVEMENT,
    BUG,
    DEPT,
    TASK
}