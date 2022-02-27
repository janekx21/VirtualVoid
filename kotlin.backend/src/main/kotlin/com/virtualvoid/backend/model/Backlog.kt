package com.virtualvoid.backend.model

import com.expediagroup.graphql.server.extensions.getValueFromDataLoader
import com.virtualvoid.backend.BacklogToIssues
import com.virtualvoid.backend.Entity
import com.virtualvoid.backend.isZero
import graphql.schema.DataFetchingEnvironment
import java.util.*
import java.util.concurrent.CompletableFuture

data class Backlog(override val id: UUID, val name: String, val description: String, val project: Project) : Entity {
    init {
        require(!id.isZero)
        require(name.length in 1..200)
        require(description.length in 0..2000)
    }

    @Suppress("unused")
    fun issues(environment: DataFetchingEnvironment): CompletableFuture<List<Issue>> {
        return environment.getValueFromDataLoader(BacklogToIssues::class.simpleName!!, this)
    }
}
