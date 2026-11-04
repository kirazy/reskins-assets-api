---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Entities

local _defines = require("api.defines")
local _sprites = require("__reskins-sprite-utils__.sprites")
local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")
local IconBuilderFactory = require("api.icon-builder-factory")

local ASSETS_BOBS_PATH = "__reskins-assets-bobs__/graphics/entity/electrolyser/"

local M = {}

---The tier of an electrolyser, which selects its artwork.
---@alias ElectrolyserTier 1|2|3|4|5

local ElectrolyserTier = V.one_of({ 1, 2, 3, 4, 5 })

-- The fourth tier has no shadow of its own, and casts the shadow of the third.
---@type table<ElectrolyserTier, ElectrolyserTier>
local shadow_tiers = { [1] = 1, [2] = 2, [3] = 3, [4] = 3, [5] = 5 }

---Gets the animation of the electrolyser for the given `tier`.
---@param tint? Color
---@param tier ElectrolyserTier
---@return Animation4Way
local function get_animation(tint, tier)
	local source_layers = {
		{
			filename = ASSETS_BOBS_PATH .. "electrolyser-" .. tier .. "-base.png",
			width = 272,
			height = 260,
			shift = util.by_pixel(17, 0),
			scale = 0.5,
		},
		{
			filename = ASSETS_BOBS_PATH .. "electrolyser-" .. shadow_tiers[tier] .. "-shadow.png",
			width = 272,
			height = 260,
			draw_as_shadow = true,
			shift = util.by_pixel(17, 0),
			scale = 0.5,
		},
	}

	if tint then
		source_layers[#source_layers + 1] = {
			filename = ASSETS_BOBS_PATH .. "electrolyser-" .. tier .. "-mask.png",
			width = 272,
			height = 260,
			tint = tint,
			shift = util.by_pixel(17, 0),
			scale = 0.5,
		}
		source_layers[#source_layers + 1] = {
			filename = ASSETS_BOBS_PATH .. "electrolyser-" .. tier .. "-highlights.png",
			width = 272,
			height = 260,
			blend_mode = "additive",
			shift = util.by_pixel(17, 0),
			scale = 0.5,
		}
	end

	return _sprites.make_4way_animation_from_spritesheet({ layers = source_layers })
end

---Gets the circuit connector of the electrolyser for each direction.
---@return [CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition]
local function get_circuit_connector()
	---@diagnostic disable-next-line: param-type-mismatch
	return circuit_connector_definitions.create_vector(universal_connector_template, {
		{
			variation = 12,
			main_offset = util.by_pixel(12, -34),
			shadow_offset = util.by_pixel(57, 4),
			show_shadow = true,
		},
		{
			variation = 12,
			main_offset = util.by_pixel(12, -38),
			shadow_offset = util.by_pixel(57, 8),
			show_shadow = true,
		},
		{
			variation = 8,
			main_offset = util.by_pixel(-10.5, -42),
			shadow_offset = util.by_pixel(39, 31),
			show_shadow = false,
		},
		{
			variation = 8,
			main_offset = util.by_pixel(-11, -38),
			shadow_offset = util.by_pixel(39, 31),
			show_shadow = false,
		},
	})
end

---Gets the water reflection of the electrolyser.
---@return WaterReflectionDefinition
local function get_water_reflection()
	return {
		pictures = {
			filename = "__base__/graphics/entity/storage-tank/storage-tank-reflection.png",
			priority = "extra-high",
			width = 24,
			height = 24,
			shift = util.by_pixel(5, 35),
			variation_count = 1,
			scale = 5,
		},
		rotate = false,
		orientation_to_variation = false,
	}
end

---Defines the options for the Bob's electrolyser sprite set.
---@class ElectrolyserSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color
---The tier of the electrolyser, which selects its artwork.
---@field tier ElectrolyserTier

local check_get_sprite_set = V.signature("get_sprite_set", {
	{
		"params",
		V.class("ElectrolyserSpriteSetParams", {
			tint = Common.color:optional(),
			tier = ElectrolyserTier,
		}):strict(),
	},
})

---Gets the sprite set for Bob's electrolyser.
---@param params ElectrolyserSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<CraftingMachineSpriteSet> # The sprite set definition for Bob's electrolyser.
---
---#### Examples
---```lua
---local electrolyser = require("__reskins-assets-api__.assets.bobs.entities.electrolyser")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = electrolyser.get_sprite_set({ tint = tint, tier = 2 })
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@throws When `params.tier` is not an integer between 1 and 5.
---@throws When `params.tint` is not a `Color`.
---@nodiscard
function M.get_sprite_set(params)
	check_get_sprite_set(params)

	---@type SpriteSetDefinition<CraftingMachineSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.crafting_machine_sprite_set,
		set = {
			graphics_set = { animation = get_animation(params.tint, params.tier) },
			circuit_connector = get_circuit_connector(),
			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = nil,
			corpse = nil,
			water_reflection = get_water_reflection(),
			nominal_width = 3,
			nominal_height = 3,
		},
	}

	return definition
end

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-bobs__/graphics/icons" })

---Gets the icon for Bob's electrolyser of the `tier`, in the tints given by `params`.
M.get_icon = IconBuilderFactory.dispatch("tier", { 1, 2, 3, 4, 5 }, "get_icon", function(tier)
	return icons:tinted("electrolyser-" .. tier)
end)

return M
