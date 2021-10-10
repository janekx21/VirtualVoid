package com.virtualvoid.backend.model

import java.util.*

class ItemNotFoundException(id: UUID) : Exception("The item with id $id could not be found")
class IssueNotFoundException(id: UUID) : Exception("The issue with id $id could not be found")
class EpicNotFoundException(id: UUID) : Exception("The epic with id $id could not be found")
class StateNotFoundException(id: UUID) : Exception("The state with id $id could not be found")

class OptionalInputUndefinedException : Exception("The optional input should be defined but was undefined")
