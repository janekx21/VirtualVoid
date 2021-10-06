package com.virtualvoid.backend.model

import com.expediagroup.graphql.server.extensions.getValueFromDataLoader
import com.virtualvoid.backend.ProjectToBacklogs
import graphql.schema.DataFetchingEnvironment
import java.util.*
import java.util.concurrent.CompletableFuture

data class Project(val id: UUID, val name: String, val short: String) {
    init {
        require(name.length in 1..200)
        require(short.length in 1..4)
    }
    fun backlogs(environment: DataFetchingEnvironment): CompletableFuture<List<Backlog>> {
        return environment.getValueFromDataLoader(ProjectToBacklogs.name, this)
    }
}
