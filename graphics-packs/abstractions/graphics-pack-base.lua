local PrototypeScaler = require("graphics-packs.abstractions.prototype-scaler")

---The abstract base class for prototype graphics packs. Classes that extend from `GraphicsPackBase` must provide the
---necessary method implementations to apply the graphics pack to their specific entity type.
---@class Reskins.Abstractions.GraphicsPackBase
---@field tint data.Color?
---@field remnants data.RotatedAnimationVariations?
---@field required_assets RequiredAssets
---@field nominal_width double? The width, in tiles, of the selection box of an entity bearing the sprites at their nominal scale. Drives automatic scaling.
---@field nominal_height double? The height, in tiles, of the selection box of an entity bearing the sprites at their nominal scale. Drives automatic scaling.
---@field scale double? The desired resulting sprite scale, relative to the baseline of `0.5`. Overrides automatic scaling.
---@field scale_factor double? An explicit scale multiplier. Overrides both `scale` and automatic scaling.
local GraphicsPackBase = {}
GraphicsPackBase.__index = GraphicsPackBase

---The caller-facing knobs shared by every graphics pack: the customizations a consumer supplies when
---configuring a predefined skin.
---@class Reskins.Abstractions.BaseGraphicsParams
---@field tint data.Color?
---@field scale double? The desired resulting sprite scale, relative to the baseline of `0.5`. Overrides automatic scaling.
---@field scale_factor double? An explicit scale multiplier. Overrides both `scale` and automatic scaling.

---@class Reskins.Abstractions.GraphicsParams:Reskins.Abstractions.BaseGraphicsParams
---@field remnants data.RotatedAnimationVariations?
---@field required_assets RequiredAssets?
---@field nominal_width double? The width, in tiles, of the selection box of an entity bearing the sprites at their nominal scale. Drives automatic scaling.
---@field nominal_height double? The height, in tiles, of the selection box of an entity bearing the sprites at their nominal scale. Drives automatic scaling.

---Creates a new `GraphicsPackBase` instance from the provided [`params`](lua://Reskins.Abstractions.GraphicsParams).
---@param params Reskins.Abstractions.GraphicsParams
---@return Reskins.Abstractions.GraphicsPackBase
---@nodiscard
function GraphicsPackBase:configure(params)
	local instance = {
		tint = params.tint,
		scale = params.scale,
		scale_factor = params.scale_factor,
		remnants = params.remnants,
		required_assets = params.required_assets or {},
		nominal_width = params.nominal_width,
		nominal_height = params.nominal_height,
	} --[[@as Reskins.Abstractions.GraphicsPackBase]]

	setmetatable(instance, self)
	return instance
end

---Creates a [`PrototypeScaler`](lua://Reskins.Abstractions.PrototypeScaler) for the given `prototype`,
---using this graphics pack's nominal dimensions and any explicit `scale` / `scale_factor`.
---
---When none of those are set, the returned scaler is an identity (a no-op), so implementations may
---construct and use it unconditionally.
---
---#### Implementation Guidance
---- Construct the scaler once at the start of `apply_to_entity`, then call
---  [`scaler:rescale(subset)`](lua://Reskins.Abstractions.PrototypeScaler.rescale) on each sprite-bearing
---  subset.
---@param prototype data.EntityPrototype The prototype to derive scaling from.
---@return Reskins.Abstractions.PrototypeScaler
---@nodiscard
function GraphicsPackBase:create_scaler(prototype)
	return PrototypeScaler.for_prototype(prototype, {
		nominal_width = self.nominal_width,
		nominal_height = self.nominal_height,
		scale = self.scale,
		scale_factor = self.scale_factor,
	})
end

---Indicates if the required asset mods are available.
---@return boolean `true` if all of the required asset mods are enabled; otherwise, `false`.
---@nodiscard
function GraphicsPackBase:has_required_asset_mods()
	if not self.required_assets then
		return true
	end

	for mod_name, _ in pairs(self.required_assets) do
		if not mods[mod_name] then
			return false
		end
	end

	return true
end

---Applies a copy of the graphics pack to the specified `prototype`.
---
---The prototype is mutated in place.
---
---#### Exceptions
---*@throws* - `string` - When `prototype` is `nil`.</br>
---*@throws* - `string` - When `prototype` is not a `table`.
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

---Applies a copy of the graphics pack to the specified `prototype`.
---
---The prototype is mutated in place if it exists; otherwise, no action is taken.
---@param prototype data.PrototypeBase|nil
function GraphicsPackBase:try_apply_to_entity(prototype)
	if prototype then
		self:apply_to_entity(prototype)
	end
end

---Applies the explosion and particle configuration to the specified `explosion` that goes with the graphics pack.
---
---The prototype is mutated in place.
---
---#### Exceptions
---*@throws* - `string` - When `explosion` is `nil`.</br>
---*@throws* - `string` - When `explosion` is not a `table`.
---*@throws* - `string` - When `corpse` is not an [ExplosionPrototype](lua://data.ExplosionPrototype).
---
---#### Implementation Guidance
---- This is an abstract method that must be implemented by subclasses.
---- Implementations should mutate the explosion in place, and create any required particles.
---@param explosion data.ExplosionPrototype
function GraphicsPackBase:apply_to_explosion(explosion)
	assert(explosion, "'explosion' must not be nil")
	assert(type(explosion) == "table", "'explosion' must be a table")
	assert(explosion.type == "explosion", "'explosion' must be an explosion prototype.")

	if not reskins_suppress_errors then
		error("apply_to_explosion must be implemented by subclass")
	end
end

---Applies the explosion and particle configuration to the specified `prototype`.
---
---The prototype is mutated in place if it exists and is a [ExplosionPrototype](lua://data.ExplosionPrototype);
---otherwise, no action is taken.
---@param prototype data.PrototypeBase|nil
function GraphicsPackBase:try_apply_to_explosion(prototype)
	if self.remnants and prototype and type(prototype) == "table" and prototype.type == "explosion" then
		---@cast prototype data.ExplosionPrototype
		self:apply_to_explosion(prototype)
	end
end

---Applies the explosion and particle configuration to the explosion with the specified `name`.
---
---The named explosion is mutated in place if it exists and is an [ExplosionPrototype](lua://data.ExplosionPrototype);
---otherwise, no action is taken.
---@param name data.EntityID
function GraphicsPackBase:try_apply_to_named_explosion(name)
	self:try_apply_to_explosion(data.raw["explosion"][name])
end

---Applies a copy of the remnants to the specified `corpse` prototype.
---
---The prototype is mutated in place.
---
---#### Exceptions
---*@throws* - `string` - When `corpse` is `nil`.</br>
---*@throws* - `string` - When `corpse` is not a `table`.</br>
---*@throws* - `string` - When `corpse` is not a [CorpsePrototype](lua://data.CorpsePrototype).
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

---Applies a copy of the remnants to the specified `prototype`.
---
---The prototype is mutated in place if it exists and is a [CorpsePrototype](lua://data.CorpsePrototype); otherwise, no
---action is taken.
---@param prototype data.PrototypeBase|nil
function GraphicsPackBase:try_apply_to_corpse(prototype)
	if self.remnants and prototype and type(prototype) == "table" and prototype.type == "corpse" then
		---@cast prototype data.CorpsePrototype
		self:apply_to_corpse(prototype)
	end
end

---Applies a copy of the remnants to the corpse with the specified `name`.
---
---The named corpse is mutated in place if it exists and is a [CorpsePrototype](lua://data.CorpsePrototype);
---otherwise, no action is taken.
---@param name data.EntityID
function GraphicsPackBase:try_apply_to_named_corpse(name)
	self:try_apply_to_corpse(data.raw["corpse"][name])
end

return GraphicsPackBase
