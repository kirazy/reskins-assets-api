---@using data
---@using Reskins.Assets.Applicators

---@namespace Reskins.Assets

local V = require("__reskins-sprite-utils__.validation")
local AssetsCommon = require("api.validation")

---Creates converter registries: registries of conversions between `SpriteSetType`s, with
---path-finding over them.
---
---### Examples
---```lua
---local ConverterRegistry = require("__reskins-assets-api__.api.converter-registry")
---```
---@class ConverterRegistryFactory
local _factory = {}

local check_register = V.signature("register", {
	{ "from_sprite_set", AssetsCommon.sprite_set_type },
	{ "to_sprite_set", AssetsCommon.sprite_set_type },
	{ "transformer", AssetsCommon.sprite_set_transformer },
})

---Creates an empty converter registry.
---
---Registries share nothing, so one made here is a place to register conversions without disturbing
---the conversions anything else relies on.
---
---### Examples
---```lua
---local ConverterRegistry = require("__reskins-assets-api__.api.converter-registry")
---
---local registry = ConverterRegistry.new()
---registry.register(from_sprite_set, to_sprite_set, transformer)
---```
---
---### Returns
---@return ConverterRegistry # A registry with no conversions registered in it.
---@nodiscard
function _factory.new()
	---A registry of conversions between `SpriteSetType`s, with path-finding over them, so converting
	---a sprite set from an arbitrary shape to whatever shape a target applicator expects doesn't
	---require a direct, hand-written conversion for every (source, target) pair. Registering
	---`A -> B`, `B -> C`, and `C -> A` also makes `B -> A` available, composed automatically.
	---
	---Each registry owns its conversions. The one every caller shares is `api.converters`,
	---populated with the conversions the mod ships; a registry made by `new` starts empty, and nothing
	---registered in it is visible to any other.
	---
	---### Examples
	---```lua
	---local converters = require("__reskins-assets-api__.api.converters")
	---```
	---@class ConverterRegistry
	local registry = {}

	---Adjacency list: `edges[from_sprite_set][to_sprite_set] = transformer`.
	---@type table<SpriteSetType, table<SpriteSetType, AnySpriteSetTransformer>>
	local edges = {}

	---Paths already searched for, as `paths[from_sprite_set][to_sprite_set]`. `false` records that no
	---path connects the two, so a known-absent path is not searched for again. Cleared by `register`,
	---since a new edge can both connect pairs nothing reached before and shorten paths already found.
	---
	---A cached path is shared by every caller that asks for it, so it is read and never mutated.
	---@type table<SpriteSetType, table<SpriteSetType, AnySpriteSetTransformer[]|false>>
	local paths = {}

	---Registers a transformer converting a sprite set from `from_sprite_set` to `to_sprite_set`.
	---
	---### Parameters
	---@param from_sprite_set SpriteSetType # The sprite set type to convert from.
	---@param to_sprite_set SpriteSetType # The sprite set type to convert to.
	---@param transformer AnySpriteSetTransformer # Takes a `from_sprite_set`-shaped value and returns a new `to_sprite_set`-shaped value. Does not mutate its input.
	---
	---### Exceptions
	---*@throws* `string` — Thrown when `from_sprite_set` or `to_sprite_set` is not a `SpriteSetType`.\
	---*@throws* `string` — Thrown when `transformer` is not a function.
	function registry.register(from_sprite_set, to_sprite_set, transformer)
		check_register(from_sprite_set, to_sprite_set, transformer)

		edges[from_sprite_set] = edges[from_sprite_set] or {}
		edges[from_sprite_set][to_sprite_set] = transformer

		paths = {}
	end

	---Searches for a path of registered transforms from `from_sprite_set` to `to_sprite_set` by
	---breadth-first search over the registered edges — the shortest chain of registered conversions,
	---if more than one exists.
	---
	---Reached through `find_path`, which caches what this returns.
	---@param from_sprite_set SpriteSetType
	---@param to_sprite_set SpriteSetType
	---@return AnySpriteSetTransformer[]? # `nil` if no path is registered.
	---@nodiscard
	local function search_for_path(from_sprite_set, to_sprite_set)
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
			---@cast current -?
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

	---Finds the shortest chain of registered conversions from `from_sprite_set` to `to_sprite_set`,
	---searching only the first time a pair is asked for.
	---@param from_sprite_set SpriteSetType
	---@param to_sprite_set SpriteSetType
	---@return AnySpriteSetTransformer[]? # `nil` if no path is registered. Shared, so never mutated.
	---@nodiscard
	local function find_path(from_sprite_set, to_sprite_set)
		local from_paths = paths[from_sprite_set]
		if not from_paths then
			from_paths = {}
			paths[from_sprite_set] = from_paths
		end

		local cached = from_paths[to_sprite_set]
		if cached ~= nil then
			return cached or nil
		end

		local path = search_for_path(from_sprite_set, to_sprite_set)
		from_paths[to_sprite_set] = path or false

		return path
	end

	---Indicates whether `definition` can be resolved to `to_sprite_set`, by a conversion it
	---carries itself or by a chain of registered transformers leading from its own type.
	---@param definition AnySpriteSetDefinition # The sprite set to resolve.
	---@param to_sprite_set SpriteSetType # The sprite set type to resolve it to.
	---@return boolean # Whether it can be resolved.
	---@return string? # What was wanted, when it cannot.
	local function resolves_to(definition, to_sprite_set)
		if definition.converters and definition.converters[to_sprite_set] then
			return true
		end

		if find_path(definition.set_type, to_sprite_set) then
			return true
		end

		return false,
			string.format(
				"must be a sprite set carrying a conversion to '%s', or whose type a registered conversion path connects to it, got '%s'",
				to_sprite_set,
				definition.set_type
			)
	end

	---Converts `sprite_set` from `from_sprite_set` to `to_sprite_set`, composing the registered
	---transformers along the path connecting them. `sprite_set` is not mutated (assuming every
	---transformer along the path honors that contract).
	---
	---Callers reach this through `resolve`, which validates that a path exists.
	---@param from_sprite_set SpriteSetType # The sprite set type `sprite_set` is in.
	---@param to_sprite_set SpriteSetType # The sprite set type to convert `sprite_set` to.
	---@param sprite_set SpriteSetBase # The sprite set to convert.
	---@return SpriteSetBase # `sprite_set` converted to `to_sprite_set`.
	---@nodiscard
	local function convert(from_sprite_set, to_sprite_set, sprite_set)
		local path = find_path(from_sprite_set, to_sprite_set)
		---@cast path -?

		local transformed_sprite_set = sprite_set
		for _, transformer in pairs(path) do
			transformed_sprite_set = transformer(transformed_sprite_set)
		end

		return transformed_sprite_set
	end

	-- Built per registry, since the rule reaching `resolves_to` reads this registry's own edges.
	local check_resolve = V.signature("resolve", {
		{ "set_definition", AssetsCommon.sprite_set_definition },
		{ "to_sprite_set", AssetsCommon.sprite_set_type },
	}, {
		{ parameter = "set_definition", arguments = { "set_definition", "to_sprite_set" }, check = resolves_to },
	})

	---Resolves `set_definition` to a sprite set in the target `to_sprite_set`, in priority order:
	---1. `set_definition.set_type == to_sprite_set` — already there; `set_definition.set` is returned as-is.
	---2. `set_definition.converters[to_sprite_set]`, if present — a conversion specific to this sprite set.
	---3. This registry's conversions, composed along the shortest path connecting the two.
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
	---*@throws* `string` — Thrown when `set_definition` is not a `SpriteSetDefinition`.\
	---*@throws* `string` — Thrown when `to_sprite_set` is not a `SpriteSetType`.\
	---*@throws* `string` — Thrown when neither a sprite-set-specific conversion nor a conversion registered here connects `set_definition.set_type` to `to_sprite_set`.
	---@nodiscard
	function registry.resolve(set_definition, to_sprite_set)
		check_resolve(set_definition, to_sprite_set)

		if set_definition.set_type == to_sprite_set then
			return set_definition.set
		end

		local specific = set_definition.converters and set_definition.converters[to_sprite_set]
		if specific then
			return specific(set_definition.set)
		end

		return convert(set_definition.set_type, to_sprite_set, set_definition.set)
	end

	return registry
end

return _factory
