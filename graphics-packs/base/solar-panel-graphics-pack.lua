local _sprites = require("__reskins-sprite-utils__.sprites")
local _defines = require("api.defines")
local GraphicsPackBase = require("graphics-packs.abstractions.graphics-pack-base")

---@class SolarPanelGraphicsPack:Reskins.Abstractions.GraphicsPackBase
---@field picture data.Sprite
---@field overlay data.Sprite
local SolarPanelGraphicsPack = {}
SolarPanelGraphicsPack.__index = SolarPanelGraphicsPack

-- Set up inheritance.
setmetatable(SolarPanelGraphicsPack, {
	__index = GraphicsPackBase,
})

local nominal_dimensions = {
	small = { width = 2, height = 2 },
	standard = { width = 3, height = 3 },
	large = { width = 4, height = 4 },
}

---@alias SolarPanelVariant
---| "small"
---| "standard"
---| "large"

---@class SolarPanelGraphicsParams:Reskins.Abstractions.BaseGraphicsParams
---@field variant SolarPanelVariant

---@param params SolarPanelGraphicsParams
---@return SolarPanelGraphicsPack
---@nodiscard
function SolarPanelGraphicsPack:configure(params)
	local required_assets
	if params.variant == "standard" then
		required_assets = { [_defines.assets.base_assets] = true }
	else
		required_assets = { [_defines.assets.bobs_assets] = true }
	end

	local instance = GraphicsPackBase.configure(self, {
		tint = params.tint,
		scale = params.scale,
		scale_factor = params.scale_factor,
		remnants = self.get_corpse_animation(params.tint, params.variant),
		required_assets = required_assets,
		nominal_width = nominal_dimensions[params.variant].width,
		nominal_height = nominal_dimensions[params.variant].height,
	}) --[[@as SolarPanelGraphicsPack]]

	instance.picture = self.get_picture(params.tint, params.variant)
	instance.overlay = self.get_overlay(params.variant)

	-- Set the correct metatable for this class.
	setmetatable(instance, SolarPanelGraphicsPack)
	return instance
end

---@param prototype data.SolarPanelPrototype
function SolarPanelGraphicsPack:apply_to_entity(prototype)
	prototype.picture = util.copy(self.picture)
	prototype.overlay = util.copy(self.overlay)
	self:try_apply_to_named_corpse(prototype.name .. "-remnants")
end

-- Per-variant sprite configuration table.
-- Keyed by variant name; contains asset path, filename prefix, and per-field dimensions.
local variant_configs = {
	["small"] = {
		assets_path = _defines.assets.bobs_assets .. "/graphics/entity/solar-panel-small/",
		prefix = "solar-panel-small",
		body_width = 180,
		body_height = 150,
		body_shift = util.by_pixel(5, 0.5),
		shadow_width = 180,
		shadow_height = 150,
		shadow_shift = util.by_pixel(5, 0.5),
		overlay_width = 180,
		overlay_height = 150,
		overlay_shift = util.by_pixel(5, 0.5),
	},
	["standard"] = {
		assets_path = _defines.assets.base_assets .. "/graphics/entity/solar-panel/",
		prefix = "solar-panel",
		body_width = 230,
		body_height = 224,
		body_shift = util.by_pixel(-3, 3.5),
		shadow_width = 220,
		shadow_height = 180,
		shadow_shift = util.by_pixel(9.5, 6),
		overlay_width = 214,
		overlay_height = 180,
		overlay_shift = util.by_pixel(10.5, 6),
	},
	["large"] = {
		assets_path = _defines.assets.bobs_assets .. "/graphics/entity/solar-panel-large/",
		prefix = "solar-panel-large",
		body_width = 308,
		body_height = 274,
		body_shift = util.by_pixel(5, 3.5),
		shadow_width = 308,
		shadow_height = 274,
		shadow_shift = util.by_pixel(5, 3.5),
		overlay_width = 308,
		overlay_height = 274,
		overlay_shift = util.by_pixel(5, 3.5),
	},
}

---@param tint data.Color?
---@param variant SolarPanelVariant
---@return data.Sprite
---@nodiscard
function SolarPanelGraphicsPack.get_picture(tint, variant)
	local cfg = variant_configs[variant]

	---@type data.Sprite
	local picture = {
		layers = {
			-- Base
			{
				filename = cfg.assets_path .. cfg.prefix .. "-base.png",
				priority = "high",
				width = cfg.body_width,
				height = cfg.body_height,
				shift = cfg.body_shift,
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(picture.layers, {
			filename = cfg.assets_path .. cfg.prefix .. "-mask.png",
			priority = "high",
			width = cfg.body_width,
			height = cfg.body_height,
			shift = cfg.body_shift,
			tint = tint,
			scale = 0.5,
		})
		table.insert(picture.layers, {
			filename = cfg.assets_path .. cfg.prefix .. "-highlights.png",
			priority = "high",
			width = cfg.body_width,
			height = cfg.body_height,
			shift = cfg.body_shift,
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	-- Shadow
	table.insert(picture.layers, {
		filename = cfg.assets_path .. cfg.prefix .. "-shadow.png",
		priority = "high",
		width = cfg.shadow_width,
		height = cfg.shadow_height,
		shift = cfg.shadow_shift,
		draw_as_shadow = true,
		scale = 0.5,
	})

	return picture
end

---@param variant SolarPanelVariant
---@return data.Sprite
---@nodiscard
function SolarPanelGraphicsPack.get_overlay(variant)
	local cfg = variant_configs[variant]

	---@type data.Sprite
	local overlay = {
		layers = {
			{
				filename = cfg.assets_path .. cfg.prefix .. "-shadow-overlay.png",
				priority = "high",
				width = cfg.overlay_width,
				height = cfg.overlay_height,
				shift = cfg.overlay_shift,
				scale = 0.5,
			},
		},
	}

	return overlay
end

---@param tint data.Color?
---@return data.RotatedAnimation
local function get_small_solar_panel_corpse_animation(tint)
	---@type data.RotatedAnimation
	local animation = {
		layers = {
			{
				filename = "__reskins-assets-bobs__/graphics/entity/solar-panel-small/remnants/small-solar-panel-remnants-base.png",
				width = 246,
				height = 198,
				direction_count = 1,
				shift = util.by_pixel(-1, -0.5),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers, {
			filename = "__reskins-assets-bobs__/graphics/entity/solar-panel-small/remnants/small-solar-panel-remnants-mask.png",
			width = 246,
			height = 198,
			direction_count = 1,
			shift = util.by_pixel(-1, -0.5),
			tint = tint,
			scale = 0.5,
		})

		table.insert(animation.layers, {
			filename = "__reskins-assets-bobs__/graphics/entity/solar-panel-small/remnants/small-solar-panel-remnants-highlights.png",
			width = 246,
			height = 198,
			direction_count = 1,
			shift = util.by_pixel(-1, -0.5),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	return animation
end

---@param tint data.Color?
---@return data.RotatedAnimation
local function get_solar_panel_corpse_animation(tint)
	---@type data.RotatedAnimation
	local animation = {
		layers = {
			{
				filename = "__base__/graphics/entity/solar-panel/remnants/solar-panel-remnants.png",
				width = 290,
				height = 282,
				direction_count = 1,
				shift = util.by_pixel(3.5, 0),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers, {
			filename = "__reskins-assets-base__/graphics/entity/solar-panel/remnants/solar-panel-remnants-mask.png",
			width = 290,
			height = 282,
			direction_count = 1,
			shift = util.by_pixel(3.5, 0),
			tint = tint,
			scale = 0.5,
		})

		table.insert(animation.layers, {
			filename = "__reskins-assets-base__/graphics/entity/solar-panel/remnants/solar-panel-remnants-highlights.png",
			width = 290,
			height = 282,
			direction_count = 1,
			shift = util.by_pixel(3.5, 0),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	return animation
end

---@param tint data.Color?
---@param variant SolarPanelVariant
---@return data.RotatedAnimationVariations?
---@nodiscard
function SolarPanelGraphicsPack.get_corpse_animation(tint, variant)
	-- Large panels have no remnant sprites.
	if variant == "large" then
		return nil
	end

	if variant == "small" then
		local animation = get_small_solar_panel_corpse_animation(tint)
		return _sprites.make_rotated_animation_variations_from_spritesheet(2, animation)
	else
		local animation = get_solar_panel_corpse_animation(tint)
		return _sprites.make_rotated_animation_variations_from_spritesheet(2, animation)
	end
end

return SolarPanelGraphicsPack
