package com.virtualvoid.backend

import com.expediagroup.graphql.generator.execution.OptionalInput

fun <T> OptionalInput<T>.ifDefinedOrNull(callback: (it: T?) -> Unit) {
    if (this is OptionalInput.Defined) {
        callback(this.value)
    }
}

fun <T> OptionalInput<T>.ifDefined(callback: (it: T) -> Unit) {
    if (this is OptionalInput.Defined && this.value != null) {
        callback(this.value!!)
    }
}
