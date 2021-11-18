package com.virtualvoid.backend.model

import com.virtualvoid.backend.isZero
import java.util.*

data class State(val id: UUID, val name: String) {
    init {
        require(name.length in 1..200)
        require(!id.isZero)
    }
}
