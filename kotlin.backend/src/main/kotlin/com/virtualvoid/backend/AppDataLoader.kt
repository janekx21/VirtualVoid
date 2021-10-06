package com.virtualvoid.backend

import com.expediagroup.graphql.server.execution.KotlinDataLoader
import com.virtualvoid.backend.model.Backlog
import com.virtualvoid.backend.model.Issue
import com.virtualvoid.backend.model.Project
import org.dataloader.DataLoader
import org.dataloader.DataLoaderOptions
import org.springframework.stereotype.Component
import java.util.concurrent.CompletableFuture

@Component
class BacklogToIssues(val repo: AppRepository) : KotlinDataLoader<Backlog, List<Issue>> {
    companion object {
        const val name = "BacklogToIssues"
    }

    override val dataLoaderName = name
    override fun getDataLoader() = DataLoader<Backlog, List<Issue>>({ ids ->
        CompletableFuture.supplyAsync {
            ids.map { backlog ->
                repo.issues.filter { it.backlog == backlog }
            }
        }
    }, DataLoaderOptions.newOptions().setCachingEnabled(true))
}
@Component
class ProjectToBacklogs(val repo: AppRepository) : KotlinDataLoader<Project, List<Backlog>> {
    companion object {
        const val name = "BacklogToBacklogs"
    }

    override val dataLoaderName = name
    override fun getDataLoader() = DataLoader<Project, List<Backlog>>({ ids ->
        CompletableFuture.supplyAsync {
            ids.map { project ->
                repo.backlogs.filter { it.project == project }
            }
        }
    }, DataLoaderOptions.newOptions().setCachingEnabled(true))
}
