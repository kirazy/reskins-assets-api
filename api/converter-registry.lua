---@using data
---@using Reskins.Assets.Applicators

---@namespace Reskins.Assets

local V = require("__reskins-sprite-utils__.validation")
local AssetsCommon = require("api.validation")

---Provides converter registries, which hold conversions between `SpriteSetType`s and find chains of
---conversions between them.
---
---#### Examples
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
---Registries are independent; conversions registered in one are not visible to another.
---@return ConverterRegistry # A registry with no conversions registered in it.
---
---#### Examples
---```lua
---local ConverterRegistry = require("__reskins-assets-api__.api.converter-registry")
---
---local registry = ConverterRegistry.new()
---registry.register(from_sprite_set, to_sprite_set, transformer)
---```
---@nodiscard
function _factory.new()
	---A registry of conversions between `SpriteSetType`s. A conversion between two types is found as
	---the shortest chain of registered conversions; registering `A -> B`, `B -> C`, and `C -> A` also
	---provides `B -> A`.
	---
	---The shared registry is `api.converters`, populated with the conversions provided by this mod. A
	---registry created by `new` is empty and independent.
	---
	---#### Examples
	---```lua
	---local converters = require("__reskins-assets-api__.api.converters")
	---```
	---@class ConverterRegistry
	local registry = {}

	---Adjacency list: `edges[from_sprite_set][to_sprite_set] = transformer`.
	---@type table<SpriteSetType, table<SpriteSetType, AnySpriteSetTransformer>>
	local edges = {}

	---Cached paths, as `paths[from_sprite_set][to_sprite_set]`. `false` records that no path exists.
	---Cleared by `register`. A cached path is shared and must not be modified.
	---@type table<SpriteSetType, table<SpriteSetType, AnySpriteSetTransformer[]|false>>
	local paths = {}

	---Registers a transformer converting a sprite set from `from_sprite_set` to `to_sprite_set`.
	---
	---#### Parameters
	---@param from_sprite_set SpriteSetType The sprite set type to convert from.
	---@param to_sprite_set SpriteSetType The sprite set type to convert to.
	---@param transformer AnySpriteSetTransformer Takes a `from_sprite_set`-shaped value and returns a new `to_sprite_set`-shaped value. Does not mutate its input.
	---@throws Thrown when `from_sprite_set` or `to_sprite_set` is not a `SpriteSetType`.
	---@throws Thrown when `transformer` is not a function.
	function registry.register(from_sprite_set, to_sprite_set, transformer)
		check_register(from_sprite_set, to_sprite_set, transformer)

		edges[from_sprite_set] = edges[from_sprite_set] or {}
		edges[from_sprite_set][to_sprite_set] = transformer

		paths = {}
	end

	---Finds the shortest chain of registered transformers from `from_sprite_set` to `to_sprite_set`
	---by breadth-first search. Called by `find_path`, which caches the result.
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

	---Gets the shortest chain of registered conversions from `from_sprite_set` to `to_sprite_set`.
	---The result is cached.
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

	---Indicates whether the given `definition` can be converted to `to_sprite_set`, by a conversion it
	---defines or by a chain of registered transformers.
	---@param definition AnySpriteSetDefinition The sprite set to resolve.
	---@param to_sprite_set SpriteSetType The sprite set type to resolve it to.
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

	---Converts the given `sprite_set` from `from_sprite_set` to `to_sprite_set` by applying the
	---registered transformers along the path between them. `sprite_set` is not modified. Called by
	---`resolve`, which checks that a path exists.
	---@param from_sprite_set SpriteSetType The sprite set type `sprite_set` is in.
	---@param to_sprite_set SpriteSetType The sprite set type to convert `sprite_set` to.
	---@param sprite_set SpriteSetBase The sprite set to convert.
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

	---Converts the given `set_definition` to a sprite set of type `to_sprite_set`, in priority order:
	---1. If `set_definition.set_type` is `to_sprite_set`, `set_definition.set` is returned.
	---2. If `set_definition.converters[to_sprite_set]` is defined, it is applied.
	---3. Otherwise, the registered conversions along the shortest path are applied.
	---@generic T
	---@param set_definition SpriteSetDefinition<T> The sprite set to resolve.
	---@param to_sprite_set SpriteSetType The sprite set type to resolve `set_definition` to.
	---@return SpriteSetBase # `set_definition.set`, converted to `to_sprite_set`.
	---@throws Thrown when `set_definition` is not a `SpriteSetDefinition`.
	---@throws Thrown when `to_sprite_set` is not a `SpriteSetType`.
	---@throws Thrown when neither a sprite-set-specific conversion nor a conversion registered here connects `set_definition.set_type` to `to_sprite_set`.
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
