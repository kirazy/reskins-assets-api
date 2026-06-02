local _defines = require("api.defines")
local ElectricPoleGraphicsPack = require("graphics-packs.abstractions.electric-pole-graphics-pack")

---@class Reskins.Base.ElectricPoleMediumGraphicsPack:Reskins.Abstractions.ElectricPoleGraphicsPack
local ElectricPoleMediumGraphicsPack = {}
ElectricPoleMediumGraphicsPack.__index = ElectricPoleMediumGraphicsPack

-- Set up inheritance.
setmetatable(ElectricPoleMediumGraphicsPack, {
	__index = ElectricPoleGraphicsPack,
})

---@class Reskins.Base.ElectricPoleMediumGraphicsParams
---@field tint data.Color?

---@param params Reskins.Base.ElectricPoleMediumGraphicsParams
---@return Reskins.Base.ElectricPoleMediumGraphicsPack
---@nodiscard
function ElectricPoleMediumGraphicsPack:configure(params)
	local instance = ElectricPoleGraphicsPack.configure(self, {
		tint = params.tint,
		pictures = self.get_pictures(params.tint),
		remnants = self.get_corpse_animation(params.tint),
		remnants_overlay = self.get_corpse_animation_overlay(params.tint),
		required_assets = { [_defines.assets.base_assets] = true },
	}) --[[@as Reskins.Base.ElectricPoleMediumGraphicsPack]]

	-- Set the correct metatable for this class.
	setmetatable(instance, ElectricPoleMediumGraphicsPack)
	return instance
end

---@param prototype data.ElectricPolePrototype
function ElectricPoleMediumGraphicsPack:apply_to_entity(prototype)
	ElectricPoleGraphicsPack.apply_to_entity(self, prototype)
	self:try_apply_to_named_corpse(prototype.name .. "-remnants")
end

---@param tint data.Color?
---@return data.RotatedSprite
---@nodiscard
function ElectricPoleMediumGraphicsPack.get_pictures(tint)
	local assets_path = _defines.assets.base_assets .. "/graphics/entity/electric-pole-medium/"
	local base_path = _defines.assets.base .. "/graphics/entity/medium-electric-pole/"

	---@type data.RotatedSprite
	local pictures = {
		layers = {
			{
				filename = base_path .. "medium-electric-pole.png",
				priority = "extra-high",
				width = 84,
				height = 252,
				direction_count = 4,
				shift = util.by_pixel(3.5, -44),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(pictures.layers, {
			filename = assets_path .. "electric-pole-medium-mask.png",
			priority = "extra-high",
			width = 84,
			height = 252,
			direction_count = 4,
			shift = util.by_pixel(3.5, -44),
			tint = tint,
			scale = 0.5,
		})
		table.insert(pictures.layers, {
			filename = assets_path .. "electric-pole-medium-highlights.png",
			priority = "extra-high",
			width = 84,
			height = 252,
			direction_count = 4,
			shift = util.by_pixel(3.5, -44),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	table.insert(pictures.layers, {
		filename = base_path .. "medium-electric-pole-shadow.png",
		priority = "extra-high",
		width = 280,
		height = 64,
		direction_count = 4,
		shift = util.by_pixel(56.5, -1),
		draw_as_shadow = true,
		scale = 0.5,
	})

	return pictures
end

---@param tint data.Color?
---@return data.RotatedAnimationVariations
---@nodiscard
function ElectricPoleMediumGraphicsPack.get_corpse_animation(tint)
	local assets_path = _defines.assets.base_assets .. "/graphics/entity/electric-pole-medium/remnants/"
	local base_path = _defines.assets.base .. "/graphics/entity/medium-electric-pole/remnants/"

	---@type data.RotatedAnimation
	local animation = {
		layers = {
			{
				filename = base_path .. "medium-electric-pole-base-remnants.png",
				width = 284,
				height = 140,
				direction_count = 1,
				shift = util.by_pixel(35, -5),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers, {
			filename = assets_path .. "electric-pole-medium-base-remnants-mask.png",
			width = 284,
			height = 140,
			direction_count = 1,
			shift = util.by_pixel(35, -5),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers, {
			filename = assets_path .. "electric-pole-medium-base-remnants-highlights.png",
			width = 284,
			height = 140,
			direction_count = 1,
			shift = util.by_pixel(35, -5),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	return { animation, util.copy(animation), util.copy(animation) }
end

---@param tint data.Color?
---@return data.RotatedAnimationVariations
---@nodiscard
function ElectricPoleMediumGraphicsPack.get_corpse_animation_overlay(tint)
	local assets_path = _defines.assets.base_assets .. "/graphics/entity/electric-pole-medium/remnants/"
	local base_path = _defines.assets.base .. "/graphics/entity/medium-electric-pole/remnants/"

	---@type data.RotatedAnimation
	local animation = {
		layers = {
			{
				filename = base_path .. "medium-electric-pole-top-remnants.png",
				width = 100,
				height = 184,
				direction_count = 1,
				shift = util.by_pixel(0, -38.5),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers, {
			filename = assets_path .. "electric-pole-medium-top-remnants-mask.png",
			width = 100,
			height = 184,
			direction_count = 1,
			shift = util.by_pixel(0, -38.5),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers, {
			filename = assets_path .. "electric-pole-medium-top-remnants-highlights.png",
			width = 100,
			height = 184,
			direction_count = 1,
			shift = util.by_pixel(0, -38.5),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	return { animation, util.copy(animation), util.copy(animation) }
end

return ElectricPoleMediumGraphicsPack
