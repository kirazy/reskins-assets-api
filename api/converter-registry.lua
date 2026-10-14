---@using data
---@using Reskins.Assets.Applicators

---@namespace Reskins.Assets

local V = require("__reskins-sprite-utils__.validation")
local AssetsCommon = require("api.validation")

---Provides methods for creating converter registries, which convert sprite sets between `SpriteSetType`s.
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
---#### Examples
---```lua
----- Create a registry with one conversion.
---local ConverterRegistry = require("__reskins-assets-api__.api.converter-registry")
---
---local registry = ConverterRegistry.new()
---registry.register(from_sprite_set, to_sprite_set, transformer)
---```
---@return ConverterRegistry
---@nodiscard
function _factory.new()
	---Represents a registry of conversions between `SpriteSetType`s.
	---
	---A conversion between two types is found as the shortest chain of registered conversions. Registering `A -> B`,
	---`B -> C`, and `C -> A` also provides `B -> A`.
	---
	---`api.converters` returns the shared registry, which has every conversion of this mod registered.
	---
	---#### Examples
	---```lua
	---local converters = require("__reskins-assets-api__.api.converters")
	---```
	---@class ConverterRegistry
	local registry = {}

	---The adjacency list, as `edges[from_sprite_set][to_sprite_set] = transformer`.
	---@type table<SpriteSetType, table<SpriteSetType, AnySpriteSetTransformer>>
	local edges = {}

	---The cached paths, as `paths[from_sprite_set][to_sprite_set]`, where `false` records that no path exists.
	---@type table<SpriteSetType, table<SpriteSetType, AnySpriteSetTransformer[]|false>>
	local paths = {}

	---Registers a transformer converting a sprite set from `from_sprite_set` to `to_sprite_set`.
	---
	---The transformer must not modify the sprite set it is given.
	---
	---#### Parameters
	---@param from_sprite_set SpriteSetType The sprite set type from which the transformer converts.
	---@param to_sprite_set SpriteSetType The sprite set type to which the transformer converts.
	---@param transformer AnySpriteSetTransformer A function that takes a sprite set of type `from_sprite_set` and returns a new sprite set of type `to_sprite_set`.
	---@throws When `from_sprite_set` or `to_sprite_set` is not a `SpriteSetType`.
	---@throws When `transformer` is not a function.
	function registry.register(from_sprite_set, to_sprite_set, transformer)
		check_register(from_sprite_set, to_sprite_set, transformer)

		edges[from_sprite_set] = edges[from_sprite_set] or {}
		edges[from_sprite_set][to_sprite_set] = transformer

		paths = {}
	end

	---Finds the shortest chain of registered transformers from `from_sprite_set` to `to_sprite_set` by breadth-first
	---search.
	---@param from_sprite_set SpriteSetType
	---@param to_sprite_set SpriteSetType
	---@return AnySpriteSetTransformer[]? # The chain, or `nil` if no path is registered.
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

	---Gets the shortest chain of registered conversions from `from_sprite_set` to `to_sprite_set`, from the cache when
	---present.
	---@param from_sprite_set SpriteSetType
	---@param to_sprite_set SpriteSetType
	---@return AnySpriteSetTransformer[]? # The shared chain, or `nil` if no path is registered.
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

	---Indicates whether the given `definition` can be converted to `to_sprite_set`, by a conversion it defines or by a
	---chain of registered transformers.
	---@param definition AnySpriteSetDefinition The sprite set to resolve.
	---@param to_sprite_set SpriteSetType The sprite set type to which `definition` is resolved.
	---@return boolean # `true` when `definition` can be converted to `to_sprite_set`; otherwise, `false`.
	---@return string? # A description of the fault, when `definition` cannot be converted.
	local function resolves_to(definition, to_sprite_set)
		if definition.converters and definition.converters[to_sprite_set] then
			return true
		end

		if find_path(definition.set_type, to_sprite_set) then
			return true
		end

		return false,
			string.format("no conversion available from sprite set type '%s' to '%s'", definition.set_type, to_sprite_set)
	end

	---Converts the given `sprite_set` from `from_sprite_set` to `to_sprite_set` by applying the registered transformers
	---along the path between them. `sprite_set` is not modified. A path between the two types must exist.
	---@param from_sprite_set SpriteSetType The sprite set type of `sprite_set`.
	---@param to_sprite_set SpriteSetType The sprite set type to which `sprite_set` is converted.
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

	-- Create the signature for each registry, because `resolves_to` reads the transformers of the registry.
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
	---@param to_sprite_set SpriteSetType The sprite set type to which `set_definition` is resolved.
	---@return SpriteSetBase # `set_definition.set`, converted to `to_sprite_set`.
	---@throws When `set_definition` is not a `SpriteSetDefinition`.
	---@throws When `to_sprite_set` is not a `SpriteSetType`.
	---@throws When neither `set_definition.converters` nor a registered conversion connects `set_definition.set_type` to `to_sprite_set`.
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
