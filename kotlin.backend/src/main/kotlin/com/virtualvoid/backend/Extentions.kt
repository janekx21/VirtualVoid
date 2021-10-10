package com.virtualvoid.backend

import com.expediagroup.graphql.generator.execution.OptionalInput
import com.virtualvoid.backend.model.OptionalInputUndefinedException

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

/**
 * @throws OptionalInputUndefinedException when the value is undefined
 */
fun <T> OptionalInput<T>.getOrNull(): T? {
    if (this is OptionalInput.Defined && this.value != null) {
        return this.value
    } else {
        throw OptionalInputUndefinedException()
    }
}
/**
 * @throws OptionalInputUndefinedException when the value is undefined
 */
fun <T> OptionalInput<T>.get(): T {
    if (this is OptionalInput.Defined && this.value != null) {
        return this.value!!
    } else {
        throw OptionalInputUndefinedException()
    }
}
