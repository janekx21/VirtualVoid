package com.virtualvoid.backend.model

data class Color(val red: Float, val green: Float, val blue: Float) {
    init {
        require(red in 0f..1f)
        require(green in 0f..1f)
        require(blue in 0f..1f)
    }
}
