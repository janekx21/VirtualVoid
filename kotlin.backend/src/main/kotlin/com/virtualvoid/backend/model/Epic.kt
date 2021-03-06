package com.virtualvoid.backend.model

import com.virtualvoid.backend.isZero
import java.util.*

data class Epic(val id: UUID, val name: String, val short: String, val color: Color) {
    init {
        require(short.length in 1..2)
        require(name.length in 1..200)
        require(!id.isZero)
    }
}
