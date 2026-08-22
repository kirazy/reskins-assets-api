---@using data
---@using Reskins.Defines
---@using Reskins.Assets
---@using Reskins.Assets.Applicators

---@namespace Reskins.Assets

---A registry of conversions between `SpriteSetType`s, with path-finding over them, so converting a
---sprite set from an arbitrary shape to whatever shape a target applicator expects doesn't require
---a direct, hand-written conversion for every (source, target) pair. Registering `A -> B`,
---`B -> C`, and `C -> A` also makes `B -> A` available, composed automatically.
---
---### Examples
---```lua
---local converters = require("__reskins-assets-api__.api.register-converters")
---```
---@class ConverterRegistry
local _converters = {}

---@alias SpriteSetTransformer<TIn : SpriteSetBase, TOut : SpriteSetBase> fun(sprite_set: TIn): TOut
---@alias AnySpriteSetTransformer SpriteSetTransformer<any, any>

---Adjacency list: `edges[from_sprite_set][to_sprite_set] = transformer`.
---@type table<SpriteSetType, table<SpriteSetType, AnySpriteSetTransformer>>
local edges = {}

---Registers a transformer converting a sprite set from `from_sprite_set` to `to_sprite_set`.
---
---### Parameters
---@param from_sprite_set SpriteSetType # The sprite set type to convert from.
---@param to_sprite_set SpriteSetType # The sprite set type to convert to.
---@param transformer AnySpriteSetTransformer # Takes a `from_sprite_set`-shaped value and returns a new `to_sprite_set`-shaped value. Does not mutate its input.
function _converters.register(from_sprite_set, to_sprite_set, transformer)
	edges[from_sprite_set] = edges[from_sprite_set] or {}
	edges[from_sprite_set][to_sprite_set] = transformer
end

---Finds a path of registered transforms from `from_sprite_set` to `to_sprite_set` via breadth-first search
---over the registered edges — the shortest chain of registered conversions, if more than one
---exists.
---@param from_sprite_set SpriteSetType
---@param to_sprite_set SpriteSetType
---@return AnySpriteSetTransformer[]? # `nil` if no path is registered.
---@nodiscard
local function find_path(from_sprite_set, to_sprite_set)
	if from_sprite_set == to_sprite_set then
		return {}
	end

	---@type table<SpriteSetType, boolean>
	local visited = { [from_sprite_set] = true }

	---@type { set_type: SpriteSetType, path: AnySpriteSetTransformer[] }[]
	local queue = { { set_type = from_sprite_set, path = {} } }
	local head = 1

	while head <= #queue do
		local current = queue[head]
		assert(current)
		head = head + 1

		for next_set_type, transformer in pairs(edges[current.set_type] or {}) do
			local path = { table.unpack(current.path) }
			path[#path + 1] = transformer

			if next_set_type == to_sprite_set then
				return path
			end

			if not visited[next_set_type] then
				visited[next_set_type] = true
				queue[#queue + 1] = { set_type = next_set_type, path = path }
			end
		end
	end

	return nil
end

---Converts `sprite_set` from `from_sprite_set` to `to_sprite_set`, composing registered
---transformers along a found path. `sprite_set` is not mutated (assuming every transformer along
---the path honors that contract).
---
---### Parameters
---@param from_sprite_set SpriteSetType # The sprite set type `sprite_set` is in.
---@param to_sprite_set SpriteSetType # The sprite set type to convert `sprite_set` to.
---@param sprite_set SpriteSetBase # The sprite set to convert.
---
---### Returns
---@return SpriteSetBase # `sprite_set` converted to `to_sprite_set`.
---
---### Exceptions
---*@throws* `string` — Thrown when no registered path of transformers connects `from_sprite_set` to `to_sprite_set`.
---@nodiscard
function _converters.convert(from_sprite_set, to_sprite_set, sprite_set)
	local path = find_path(from_sprite_set, to_sprite_set)
	assert(path, string.format("No registered conversion path from '%s' to '%s'.", from_sprite_set, to_sprite_set))

	local transformed_sprite_set = sprite_set
	for _, transformer in pairs(path) do
		transformed_sprite_set = transformer(transformed_sprite_set)
	end

	return transformed_sprite_set
end

---Resolves `set_definition` to a sprite set in the target `to_sprite_set`, in priority order:
---1. `set_definition.set_type == to_sprite_set` — already there; `set_definition.set` is returned as-is.
---2. `set_definition.converters[to_sprite_set]`, if present — a conversion specific to this sprite set.
---3. The general registry, via `convert`.
---
---### Parameters
---@generic T
---@param set_definition SpriteSetDefinition<T> # The sprite set to resolve.
---@param to_sprite_set SpriteSetType # The sprite set type to resolve `set_definition` to.
---
---### Returns
---@return SpriteSetBase # `set_definition.set`, converted to `to_sprite_set`.
---
---### Exceptions
---*@throws* `string` — Thrown when neither a sprite-set-specific conversion nor a registered path connects `set_definition.set_type` to `to_sprite_set`.
---@nodiscard
function _converters.resolve(set_definition, to_sprite_set)
	if set_definition.set_type == to_sprite_set then
		return set_definition.set
	end

	local specific = set_definition.converters and set_definition.converters[to_sprite_set]
	if specific then
		return specific(set_definition.set)
	end

	return _converters.convert(set_definition.set_type, to_sprite_set, set_definition.set)
end

return _converters
