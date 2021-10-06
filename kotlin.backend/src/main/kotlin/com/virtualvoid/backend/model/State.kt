package com.virtualvoid.backend.model

import java.util.*

data class State(val id: UUID, val name: String) {
    init {
        require(name.length in 1..200)
    }
}
