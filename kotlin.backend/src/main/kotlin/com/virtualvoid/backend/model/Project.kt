package com.virtualvoid.backend.model

import com.expediagroup.graphql.server.extensions.getValueFromDataLoader
import com.virtualvoid.backend.Data
import com.virtualvoid.backend.ProjectToBacklogs
import com.virtualvoid.backend.isZero
import graphql.schema.DataFetchingEnvironment
import java.util.*
import java.util.concurrent.CompletableFuture

data class Project(override val id: UUID, val name: String, val short: String) : Data {
    init {
        require(name.length in 1..200)
        require(short.length in 1..4) { "shorts length must be between 1 and 4" }
        require(!id.isZero)
    }

    @Suppress("unused")
    fun backlogs(environment: DataFetchingEnvironment): CompletableFuture<List<Backlog>> {
        return environment.getValueFromDataLoader(ProjectToBacklogs::class.simpleName!!, this)
    }
}
