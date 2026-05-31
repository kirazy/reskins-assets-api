local _defines = require("api.defines")
local GraphicsPackBase = require("graphics-pack-base")
local StringValidator = require("prototypes.string-validator")
local NumberValidator = require("prototypes.number-validator")

---@class Reskins.Base.AccumulatorGraphicsPack:Reskins.Abstractions.GraphicsPackBase
---@field chargable_graphics data.ChargableGraphics
---@field water_reflection data.WaterReflectionDefinition
local AccumulatorGraphicsPack = {}
AccumulatorGraphicsPack.__index = AccumulatorGraphicsPack

-- Set up inheritance
setmetatable(AccumulatorGraphicsPack, {
	__index = GraphicsPackBase,
})

---@alias Reskins.Base.AccumulatorSpriteSet
---| "base"
---| "fast"
---| "high-capacity"
---| "slow"

---@class Reskins.Base.AccumulatorGraphicsParams
---@field tint data.Color?
---@field sprite_set Reskins.Base.AccumulatorSpriteSet?

---@param params Reskins.Base.AccumulatorGraphicsParams
---@return Reskins.Base.AccumulatorGraphicsPack
---@nodiscard
function AccumulatorGraphicsPack:configure(params)
	local instance = GraphicsPackBase.configure(self, {
		tint = params.tint,
		remnants = nil,
		required_assets = {
			[_defines.assets.base] = true,
			[_defines.assets.base_assets] = true,
		},
	}) --[[@as Reskins.Base.AccumulatorGraphicsPack]]

	instance.chargable_graphics = self.get_chargable_graphics(params.sprite_set, params.tint)
	instance.water_reflection = self.get_accumulator_reflection()

	if type(params.sprite_set) == "string" and params.sprite_set ~= "base" then
		instance.required_assets[_defines.assets.bobs_assets] = true
	end

	setmetatable(instance, AccumulatorGraphicsPack)
	return instance
end

---@param prototype data.AccumulatorPrototype
function AccumulatorGraphicsPack:apply_to_entity(prototype)
	prototype.chargable_graphics = util.copy(self.chargable_graphics)
	prototype.water_reflection = util.copy(self.water_reflection)
end

---@param sprite_set Reskins.Base.AccumulatorSpriteSet?
---@param tint data.Color?
---@return data.ChargableGraphics
---@nodiscard
function AccumulatorGraphicsPack.get_chargable_graphics(sprite_set, tint)
	---@type data.ChargableGraphics
	local chargable_graphics = {
		picture = AccumulatorGraphicsPack.get_accumulator_pictures(sprite_set, tint),
		charge_animation = AccumulatorGraphicsPack.get_accumulator_charge_animation(sprite_set, tint),
		charge_animation_is_looped = true,
		charge_cooldown = 30, -- same as base
		discharge_animation = AccumulatorGraphicsPack.get_accumulator_discharge_animation(sprite_set, tint),
		discharge_cooldown = 60, -- same as base
	}

	return chargable_graphics
end

---@param sprite_set Reskins.Base.AccumulatorSpriteSet? # Default "base".
---@param tint data.Color? # Default nil.
---@param repeat_count integer? # Default nil.
---@return data.Sprite|data.Animation
---@nodiscard
function AccumulatorGraphicsPack.get_accumulator_pictures(sprite_set, tint, repeat_count)
	if repeat_count ~= nil then
		NumberValidator.validate(repeat_count, "repeat_count"):is_integer():is_positive()
	end

	sprite_set = sprite_set or "base"
	StringValidator.validate(sprite_set, "sprite_set")

	-- Validate sprite_set is one of the allowed values
	local valid_sprite_sets = {
		["base"] = true,
		["high-capacity"] = true,
		["fast"] = true,
		["slow"] = true,
	}
	if not valid_sprite_sets[sprite_set] then
		error("Invalid sprite_set: " .. tostring(sprite_set) .. ". Must be one of: base, high-capacity, fast, slow")
	end

	local assets_base_path = sprite_set == "base" and _defines.assets.base or _defines.assets.bobs_assets
	local accumulator_type = sprite_set == "base" and "" or ("-" .. sprite_set)

	---@type data.Sprite|data.Animation
	local sprite = {
		layers = {
			{
				filename = assets_base_path .. "/graphics/entity/accumulator/accumulator" .. accumulator_type .. ".png",
				priority = "high",
				width = 130,
				height = 189,
				repeat_count = repeat_count,
				shift = util.by_pixel(0, -11),
				scale = 0.5,
			},
			{
				filename = "__base__/graphics/entity/accumulator/accumulator-shadow.png",
				priority = "high",
				width = 234,
				height = 106,
				repeat_count = repeat_count,
				shift = util.by_pixel(29, 6),
				draw_as_shadow = true,
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(sprite.layers, {
			filename = "__reskins-assets-base__/graphics/entity/accumulator/accumulator-mask.png",
			priority = "high",
			width = 130,
			height = 189,
			repeat_count = repeat_count,
			shift = util.by_pixel(0, -11),
			tint = tint,
			scale = 0.5,
		})

		table.insert(sprite.layers, {
			filename = "__reskins-assets-base__/graphics/entity/accumulator/accumulator-highlights.png",
			priority = "high",
			width = 130,
			height = 189,
			repeat_count = repeat_count,
			shift = util.by_pixel(0, -11),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	return sprite
end

---@param sprite_set Reskins.Base.AccumulatorSpriteSet?
---@param tint data.Color?
---@return data.Animation
---@nodiscard
function AccumulatorGraphicsPack.get_accumulator_charge_animation(sprite_set, tint)
	local repeat_count = 24

	---@type data.Animation
	local animation = {
		layers = {
			AccumulatorGraphicsPack.get_accumulator_pictures(sprite_set, tint, repeat_count),
			{
				filename = "__base__/graphics/entity/accumulator/accumulator-charge.png",
				priority = "high",
				width = 178,
				height = 210,
				line_length = 6,
				frame_count = 24,
				draw_as_glow = true,
				shift = util.by_pixel(1, -20),
				scale = 0.5,
			},
		},
	}

	return animation
end

---@param sprite_set Reskins.Base.AccumulatorSpriteSet?
---@param tint data.Color?
---@return data.Animation
---@nodiscard
function AccumulatorGraphicsPack.get_accumulator_discharge_animation(sprite_set, tint)
	local repeat_count = 24

	---@type data.Animation
	local animation = {
		layers = {
			AccumulatorGraphicsPack.get_accumulator_pictures(sprite_set, tint, repeat_count),
			{
				filename = "__base__/graphics/entity/accumulator/accumulator-discharge.png",
				priority = "high",
				width = 174,
				height = 214,
				line_length = 6,
				frame_count = 24,
				draw_as_glow = true,
				shift = util.by_pixel(-1, -21),
				scale = 0.5,
			},
		},
	}

	return animation
end

---@return data.WaterReflectionDefinition
---@nodiscard
function AccumulatorGraphicsPack.get_accumulator_reflection()
	---@type data.WaterReflectionDefinition
	local reflection = {
		pictures = {
			filename = "__base__/graphics/entity/accumulator/accumulator-reflection.png",
			priority = "extra-high",
			width = 20,
			height = 24,
			shift = util.by_pixel(0, 50),
			variation_count = 1,
			scale = 5,
		},
		rotate = false,
		orientation_to_variation = false,
	}

	return reflection
end

---@param tint data.Color?
---@return data.RotatedAnimationVariations
function AccumulatorGraphicsPack.get_corpse_animation(tint)
	return reskins_suppress_errors and {} or error("get_corpse_animation is not implemented")
end

return AccumulatorGraphicsPack
