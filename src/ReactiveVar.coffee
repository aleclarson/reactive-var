
Tracker = require "tracker"
Type = require "Type"
Any = require "Any"

type = Type "ReactiveVar"

type.argumentTypes =
  value: Any
  compare: Function

type.argumentDefaults =
  compare: (oldValue, newValue) ->
    return oldValue is newValue

type.defineValues

  _dep: -> Tracker.Dependency()

  _value: (value) -> value

  _compare: (value, compare) -> compare

type.defineMethods

  get: ->
    @_dep.depend() if Tracker.isActive
    return @_value

  set: (newValue) ->
    return if @_compare @_value, newValue
    @_value = newValue
    @_dep.changed()
    return

  _numListeners: ->
    count = 0
    count += 1 for id in Object.keys @_dep._dependentsById
    return count

type.didBuild (type) ->
  inject = require "Property/inject"
  inject "ReactiveVar", type

module.exports = type.build()
