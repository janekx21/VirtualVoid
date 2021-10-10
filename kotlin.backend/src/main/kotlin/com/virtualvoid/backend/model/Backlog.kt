package com.virtualvoid.backend.model

import com.expediagroup.graphql.server.extensions.getValueFromDataLoader
import com.virtualvoid.backend.BacklogToIssues
import graphql.schema.DataFetchingEnvironment
import java.util.*
import java.util.concurrent.CompletableFuture

data class Backlog(val id: UUID, val title: String, val project: Project) {
    init {
        require(title.length in 1..200)
    }

    @Suppress("unused")
    fun issues(environment: DataFetchingEnvironment): CompletableFuture<List<Issue>> {
        return environment.getValueFromDataLoader(BacklogToIssues.name, this)
    }
}
