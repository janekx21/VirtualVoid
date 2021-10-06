package com.virtualvoid.backend.model

import java.util.*

data class Epic(val id: UUID, val name: String, val short: String) {
    init {
        require(short.length in 1..2)
        require(name.length in 1..200)
    }
}
