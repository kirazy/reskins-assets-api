---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Applicators

local _defines = require("api.defines")

---Retains the module art styles on `prototype` that `produced` does not replace, and logs them. A
---retained style is copied as-is: it is not retinted or repositioned for the beacon's module slots.
---@param prototype BeaconPrototype
---@param produced BeaconModuleVisualizations[]?
---@return BeaconModuleVisualizations[]?
---@nodiscard
local function retain_unhandled_art_styles(prototype, produced)
	local existing = prototype.graphics_set and prototype.graphics_set.module_visualisations
	if not existing then
		return produced
	end

	local is_drawn = {}
	for _, visualisation in pairs(produced or {}) do
		is_drawn[visualisation.art_style] = true
	end

	---@type BeaconModuleVisualizations[]
	local retained = {}
	local names = {}

	for _, visualisation in pairs(existing) do
		if not is_drawn[visualisation.art_style] then
			retained[#retained + 1] = util.copy(visualisation)
			names[#names + 1] = visualisation.art_style or "<unnamed>"
		end
	end

	if #retained == 0 then
		return produced
	end

	log(
		string.format(
			"BeaconSpriteSetApplicator: unhandled module art styles on '%s' (%s); retained as-is, not retinted "
				.. "or repositioned.",
			prototype.name or "<unnamed>",
			table.concat(names, ", ")
		)
	)

	for _, visualisation in pairs(produced or {}) do
		retained[#retained + 1] = visualisation
	end

	return retained
end

---Applies a `beacon_sprite_set`-shaped `set` to `prototype`.
---@param prototype BeaconPrototype
---@param set BeaconSpriteSet
local function apply_sprite_set_to_beacon(prototype, set)
	local graphics_set = util.copy(set.graphics_set)

	if graphics_set then
		graphics_set.module_visualisations = retain_unhandled_art_styles(prototype, graphics_set.module_visualisations)
	end

	prototype.graphics_set = graphics_set
end

---@param explosion ExplosionPrototype
---@param set BeaconSpriteSet
local function apply_sprite_set_to_explosion(explosion, set)
	error("Not implemented")
end

---@type BeaconSpriteSetApplicator
return {
	set_type = _defines.sprite_set_type.beacon_sprite_set,
	apply_to = apply_sprite_set_to_beacon,
	apply_to_explosion = apply_sprite_set_to_explosion,
}

---The sprite data a `beacon_sprite_set`-tagged `SpriteSetDefinition` carries.
---@class (exact) BeaconSpriteSet : EntityWithHealthSpriteSet
---The prototype's `graphics_set`.
---@field graphics_set BeaconGraphicsSet?

---The applicator for beacons.
---@class (exact) BeaconSpriteSetApplicator : SpriteSetApplicator<BeaconPrototype, BeaconSpriteSet>
