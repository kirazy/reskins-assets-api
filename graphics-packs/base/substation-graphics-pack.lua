local _defines = require("api.defines")
local ElectricPoleGraphicsPack = require("graphics-packs.abstractions.electric-pole-graphics-pack")

---@class SubstationGraphicsPack:Reskins.Abstractions.ElectricPoleGraphicsPack
local SubstationGraphicsPack = {}
SubstationGraphicsPack.__index = SubstationGraphicsPack

-- Set up inheritance.
setmetatable(SubstationGraphicsPack, {
	__index = ElectricPoleGraphicsPack,
})

---@class SubstationGraphicsParams
---@field tint data.Color?

---@param params SubstationGraphicsParams
---@return SubstationGraphicsPack
---@nodiscard
function SubstationGraphicsPack:configure(params)
	local instance = ElectricPoleGraphicsPack.configure(self, {
		tint = params.tint,
		pictures = self.get_pictures(params.tint),
		remnants = self.get_corpse_animation(params.tint),
		required_assets = { [_defines.assets.base_assets] = true },
	}) --[[@as SubstationGraphicsPack]]

	-- Set the correct metatable for this class.
	setmetatable(instance, SubstationGraphicsPack)
	return instance
end

---@param prototype data.ElectricPolePrototype
function SubstationGraphicsPack:apply_to_entity(prototype)
	ElectricPoleGraphicsPack.apply_to_entity(self, prototype)
	self:try_apply_to_named_corpse(prototype.name .. "-remnants")
end

---@param tint data.Color?
---@return data.RotatedSprite
---@nodiscard
function SubstationGraphicsPack.get_pictures(tint)
	local assets_path = _defines.assets.base_assets .. "/graphics/entity/substation/"

	---@type data.RotatedSprite
	local pictures = {
		layers = {
			{
				filename = assets_path .. "substation-base.png",
				priority = "high",
				width = 138,
				height = 270,
				direction_count = 4,
				shift = util.by_pixel(0, -31),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(pictures.layers, {
			filename = assets_path .. "substation-mask.png",
			priority = "high",
			width = 138,
			height = 270,
			direction_count = 4,
			shift = util.by_pixel(0, -31),
			tint = tint,
			scale = 0.5,
		})
		table.insert(pictures.layers, {
			filename = assets_path .. "substation-highlights.png",
			priority = "high",
			width = 138,
			height = 270,
			direction_count = 4,
			shift = util.by_pixel(0, -31),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	table.insert(pictures.layers, {
		filename = assets_path .. "substation-shadow.png",
		priority = "high",
		width = 370,
		height = 104,
		direction_count = 4,
		shift = util.by_pixel(62, 10),
		draw_as_shadow = true,
		scale = 0.5,
	})

	return pictures
end

---@param tint data.Color?
---@return data.RotatedAnimationVariations
---@nodiscard
function SubstationGraphicsPack.get_corpse_animation(tint)
	local assets_path = _defines.assets.base_assets .. "/graphics/entity/substation/remnants/"

	---@type data.RotatedAnimation
	local animation = {
		layers = {
			{
				filename = assets_path .. "substation-remnants.png",
				width = 182,
				height = 134,
				direction_count = 1,
				shift = util.by_pixel(2.5, 0.5),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers, {
			filename = assets_path .. "substation-remnants-mask.png",
			width = 182,
			height = 134,
			direction_count = 1,
			shift = util.by_pixel(2.5, 0.5),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers, {
			filename = assets_path .. "substation-remnants-highlights.png",
			width = 182,
			height = 134,
			direction_count = 1,
			shift = util.by_pixel(2.5, 0.5),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	return { animation }
end

return SubstationGraphicsPack
