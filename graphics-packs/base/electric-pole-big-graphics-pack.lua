local _defines = require("api.defines")
local ElectricPoleGraphicsPack = require("electric-pole-graphics-pack")

---@class Reskins.Base.ElectricPoleBigGraphicsPack:Reskins.Abstractions.ElectricPoleGraphicsPack
local ElectricPoleBigGraphicsPack = {}
ElectricPoleBigGraphicsPack.__index = ElectricPoleBigGraphicsPack

-- Set up inheritance.
setmetatable(ElectricPoleBigGraphicsPack, {
	__index = ElectricPoleGraphicsPack,
})

---@class Reskins.Base.ElectricPoleBigGraphicsParams
---@field tint data.Color?

---@param params Reskins.Base.ElectricPoleBigGraphicsParams
---@return Reskins.Base.ElectricPoleBigGraphicsPack
---@nodiscard
function ElectricPoleBigGraphicsPack:configure(params)
	local instance = ElectricPoleGraphicsPack.configure(self, {
		tint = params.tint,
		pictures = self.get_pictures(params.tint),
		remnants = self.get_corpse_animation(params.tint),
		remnants_overlay = self.get_corpse_animation_overlay(params.tint),
		required_assets = { [_defines.assets.base_assets] = true },
	}) --[[@as Reskins.Base.ElectricPoleBigGraphicsPack]]

	-- Set the correct metatable for this class.
	setmetatable(instance, ElectricPoleBigGraphicsPack)
	return instance
end

---@param prototype data.ElectricPolePrototype
function ElectricPoleBigGraphicsPack:apply_to_entity(prototype)
	ElectricPoleGraphicsPack.apply_to_entity(self, prototype)
	self:try_apply_to_named_corpse(prototype.name .. "-remnants")
end

---@param tint data.Color?
---@return data.RotatedSprite
---@nodiscard
function ElectricPoleBigGraphicsPack.get_pictures(tint)
	local assets_path = _defines.assets.base_assets .. "/graphics/entity/electric-pole-big/"

	---@type data.RotatedSprite
	local pictures = {
		layers = {
			{
				filename = assets_path .. "electric-pole-big.png",
				priority = "extra-high",
				width = 148,
				height = 312,
				direction_count = 4,
				shift = util.by_pixel(0, -51),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(pictures.layers, {
			filename = assets_path .. "electric-pole-big-mask.png",
			priority = "extra-high",
			width = 148,
			height = 312,
			direction_count = 4,
			shift = util.by_pixel(0, -51),
			tint = tint,
			scale = 0.5,
		})
		table.insert(pictures.layers, {
			filename = assets_path .. "electric-pole-big-highlights.png",
			priority = "extra-high",
			width = 148,
			height = 312,
			direction_count = 4,
			shift = util.by_pixel(0, -51),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	table.insert(pictures.layers, {
		filename = assets_path .. "electric-pole-big-shadow.png",
		priority = "extra-high",
		width = 374,
		height = 94,
		direction_count = 4,
		shift = util.by_pixel(60, 0),
		draw_as_shadow = true,
		scale = 0.5,
	})

	return pictures
end

---@param tint data.Color?
---@return data.RotatedAnimationVariations
---@nodiscard
function ElectricPoleBigGraphicsPack.get_corpse_animation(tint)
	local assets_path = _defines.assets.base_assets .. "/graphics/entity/electric-pole-big/remnants/"

	---@type data.RotatedAnimation
	local animation = {
		layers = {
			{
				filename = assets_path .. "electric-pole-big-base-remnants.png",
				width = 366,
				height = 188,
				direction_count = 1,
				shift = util.by_pixel(43, 0.5),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers, {
			filename = assets_path .. "electric-pole-big-base-remnants-mask.png",
			width = 366,
			height = 188,
			direction_count = 1,
			shift = util.by_pixel(43, 0.5),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers, {
			filename = assets_path .. "electric-pole-big-base-remnants-highlights.png",
			width = 366,
			height = 188,
			direction_count = 1,
			shift = util.by_pixel(43, 0.5),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	return { animation, util.copy(animation), util.copy(animation), util.copy(animation) }
end

---@param tint data.Color?
---@return data.RotatedAnimationVariations
---@nodiscard
function ElectricPoleBigGraphicsPack.get_corpse_animation_overlay(tint)
	local assets_path = _defines.assets.base_assets .. "/graphics/entity/electric-pole-big/remnants/"

	---@type data.RotatedAnimation
	local animation = {
		layers = {
			{
				filename = assets_path .. "electric-pole-big-top-remnants.png",
				width = 148,
				height = 252,
				direction_count = 1,
				shift = util.by_pixel(-1.5, -48),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers, {
			filename = assets_path .. "electric-pole-big-top-remnants-mask.png",
			width = 148,
			height = 252,
			direction_count = 1,
			shift = util.by_pixel(-1.5, -48),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers, {
			filename = assets_path .. "electric-pole-big-top-remnants-highlights.png",
			width = 148,
			height = 252,
			direction_count = 1,
			shift = util.by_pixel(-1.5, -48),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	return { animation, util.copy(animation), util.copy(animation), util.copy(animation) }
end

return ElectricPoleBigGraphicsPack
