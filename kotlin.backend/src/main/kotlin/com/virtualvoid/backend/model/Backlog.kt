package com.virtualvoid.backend.model

import com.expediagroup.graphql.server.extensions.getValueFromDataLoader
import com.virtualvoid.backend.BacklogToIssues
import com.virtualvoid.backend.Data
import com.virtualvoid.backend.isZero
import graphql.schema.DataFetchingEnvironment
import java.util.*
import java.util.concurrent.CompletableFuture

data class Backlog(override val id: UUID, val name: String, val project: Project) : Data {
    init {
        require(name.length in 1..200)
        require(!id.isZero)
    }

    @Suppress("unused")
    fun issues(environment: DataFetchingEnvironment): CompletableFuture<List<Issue>> {
        return environment.getValueFromDataLoader(BacklogToIssues::class.simpleName!!, this)
    }
}
