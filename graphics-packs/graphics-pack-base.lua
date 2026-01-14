---The abstract base class for prototype graphics packs. Classes that extend from `GraphicsPackBase` must provide the
---necessary method implementations to apply the graphics pack to their specific entity type.
---@class GraphicsPackBase
---@field tint data.Color?
---@field remnants data.RotatedAnimationVariations?
---@field required_assets Reskins.Defines.Assets[]
local GraphicsPackBase = {}
GraphicsPackBase.__index = GraphicsPackBase

---@class GraphicsPackParams
---@field tint data.Color?
---@field remnants data.RotatedAnimationVariations?
---@field required_assets Reskins.Defines.Assets[]

---Creates a new `GraphicsPackBase` instance.
---
---The parameters are not copied for performance reasons; if they are not properly isolated changes made elsewhere will
---apply to the graphics pack. The recommended pattern is to create the parameters alongside the graphics pack instance.
---@param params GraphicsPackParams
---@return GraphicsPackBase
---@nodiscard
function GraphicsPackBase:new(params)
	local instance = {
		tint = params.tint,
		remnants = params.remnants,
		required_assets = params.required_assets,
	} --[[@as GraphicsPackBase]]

	setmetatable(instance, self)
	return instance
end

---Indicates if the required asset mods are available.
---@return boolean `true` if all of the required asset mods are enabled; otherwise, `false`.
---@nodiscard
function GraphicsPackBase:has_required_asset_mods()
	if not self.required_assets then
		return true
	end

	for _, mod_name in pairs(self.required_assets) do
		if not mods[mod_name] then
			return false
		end
	end

	return true
end

---Applies a copy of the graphics pack to the specified `prototype`.
---
---#### Exceptions
---*@throws* - `string` - When `prototype` is `nil`.</br>
---*@throws* - `string` - When `prototype` is is not a `table`.
---
---#### Implementation Guidance
---- This is an abstract method that must be implemented by subclasses.
---- Implementations should mutate the prototype in place, and set copies of the graphics.
---@param prototype data.PrototypeBase
function GraphicsPackBase:apply_to_entity(prototype)
	if not reskins_suppress_errors then
		error("apply_to_entity must be implemented by subclass")
	end
end

function GraphicsPackBase:try_apply_to_named_entity(name, type_name)
	local prototype = data.raw[type_name][name]
	if prototype then
		self:apply_to_entity(prototype)
	end
end

---Applies a copy of the remnants to the specified `corpse` prototype.
---
---The prototype is mutated in place.
---
---#### Exceptions
---*@throws* - `string` - When `corpse` is `nil`.</br>
---*@throws* - `string` - When `corpse` is is not a `table`.</br>
---*@throws* - `string` - When `corpse` is is not a [CorpsePrototype](lua://data.CorpsePrototype).
---@param corpse data.CorpsePrototype
function GraphicsPackBase:apply_to_corpse(corpse)
	assert(corpse, "'corpse' must not be nil")
	assert(type(corpse) == "table", "'corpse' must be a table")
	assert(corpse.type == "corpse", "'corpse' must be a corpse prototype.")

	if not self.remnants then
		return
	end

	corpse.animation = util.copy(self.remnants)
end

function GraphicsPackBase:try_apply_to_corpse(corpse)
	if corpse and type(corpse) == "table" and corpse.type == "corpse" then
		self:apply_to_corpse(corpse)
	end
end

function GraphicsPackBase:try_apply_to_named_corpse(name)
	self:try_apply_to_corpse(data.raw["corpse"][name])
end

return GraphicsPackBase
