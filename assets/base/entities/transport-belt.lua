---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Base.Entities

local _defines = require("api.defines")

local _sprites = require("__reskins-sprite-utils__.sprites")
local IconCatalog = require("api.icon-catalog")

local M = {}

-- TODO: Lift the hash-based auto-replace logic from Prismatic Belts.
-- TODO: Strip out the transport-belt-connectable replace from all-things-not-a-transport-belt.

---Builds the belt animation set for the given `tint` and `belt_sprite`.
---
---Every transport-belt-connectable entity uses the same belt, so the splitter and underground
---belt producers take theirs from here rather than each building their own.
---@param tint Color?
---@param belt_sprite BeltSprites
---@return TransportBeltAnimationSet
---@nodiscard
function M.get_belt_animation_set(tint, belt_sprite)
	local assets_path = _defines.assets_source.base_assets .. "/graphics/entity/transport-belt/"

	local frame_counts = {
		[_defines.belt_sprites.standard] = 16,
		[_defines.belt_sprites.fast] = 32,
		[_defines.belt_sprites.turbo] = 64,
	}
	local frame_count = frame_counts[belt_sprite]

	---@type RotatedAnimation
	local animation_set = {
		layers = {
			{
				filename = assets_path .. "transport-belt-" .. belt_sprite .. "-base.png",
				priority = "extra-high",
				width = 128,
				height = 128,
				frame_count = frame_count,
				direction_count = 20,
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation_set.layers--[[@cast -?]], {
			filename = assets_path .. "transport-belt-" .. belt_sprite .. "-mask.png",
			priority = "extra-high",
			width = 128,
			height = 128,
			frame_count = frame_count,
			direction_count = 20,
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation_set.layers--[[@cast -?]], {
			filename = assets_path .. "transport-belt-" .. belt_sprite .. "-highlights.png",
			priority = "extra-high",
			width = 128,
			height = 128,
			frame_count = frame_count,
			direction_count = 20,
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	return { animation_set = animation_set }
end

---@param tint Color?
---@return RotatedAnimationVariations
local function get_corpse_animation(tint)
	local assets_path = "__reskins-assets-base__/graphics/entity/transport-belt/"

	local layers = {
		{
			filename = assets_path .. "remnants/transport-belt-remnants-base.png",
			width = 106,
			height = 102,
			direction_count = 4,
			shift = util.by_pixel(1, -0.5),
			scale = 0.5,
		},
	}

	if tint then
		table.insert(layers, {
			filename = assets_path .. "remnants/transport-belt-remnants-mask.png",
			width = 106,
			height = 102,
			direction_count = 4,
			shift = util.by_pixel(1, -0.5),
			tint = tint,
			scale = 0.5,
		})
		table.insert(layers, {
			filename = assets_path .. "remnants/transport-belt-remnants-highlights.png",
			width = 106,
			height = 102,
			direction_count = 4,
			shift = util.by_pixel(1, -0.5),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	return _sprites.make_rotated_animation_variations_from_spritesheet(2, { layers = layers })
end

---@class TransportBeltSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint Color?
---The belt artwork to draw.
---@field belt_sprite BeltSprites

---Gets the sprite set for the vanilla transport belt.
---@param params TransportBeltSpriteSetParams The options the sprite set is drawn with.
---@return SpriteSetDefinition<TransportBeltSpriteSet>
---
---#### Examples
---```lua
---local transport_belt = require("__reskins-assets-api__.assets.base.entities.transport-belt")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = transport_belt.get_sprite_set({ tint = tint, belt_sprite = belt_sprite })
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@nodiscard
function M.get_sprite_set(params)
	---@type SpriteSetDefinition<TransportBeltSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.transport_belt_sprite_set,
		set = {
			belt_animation_set = M.get_belt_animation_set(params.tint, params.belt_sprite),
			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = nil,
			corpse = { animation = get_corpse_animation(params.tint) },
			water_reflection = nil,
			nominal_width = 1,
			nominal_height = 1,
		},
	}

	return definition
end

local icons = IconCatalog:create({ folder = "__reskins-assets-base__/graphics/icons" })

---Gets the icon for the vanilla transport belt, in the tints given by `params`.
M.get_icon = icons:tinted("transport-belt"):build("get_icon")

return M
