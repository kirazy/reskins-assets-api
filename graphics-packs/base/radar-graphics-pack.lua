local _defines = require("api.defines")
local GraphicsPackBase = require("graphics-packs.abstractions.graphics-pack-base")

---@class RadarGraphicsPack:Reskins.Abstractions.GraphicsPackBase
---@field pictures data.RotatedSprite
---@field integration_patch data.Sprite
local RadarGraphicsPack = {}
RadarGraphicsPack.__index = RadarGraphicsPack

-- Set up inheritance.
setmetatable(RadarGraphicsPack, {
	__index = GraphicsPackBase,
})

---@class RadarGraphicsParams
---@field tint data.Color?

---@param params RadarGraphicsParams
---@return RadarGraphicsPack
---@nodiscard
function RadarGraphicsPack:configure(params)
	local instance = GraphicsPackBase.configure(self, {
		tint = params.tint,
		remnants = self.get_corpse_animation(params.tint),
		required_assets = { [_defines.assets.base_assets] = true },
	}) --[[@as RadarGraphicsPack]]

	instance.pictures = self.get_pictures(params.tint)
	instance.integration_patch = self.get_integration_patch()

	-- Set the correct metatable for this class.
	setmetatable(instance, RadarGraphicsPack)
	return instance
end

---@param prototype data.RadarPrototype
function RadarGraphicsPack:apply_to_entity(prototype)
	prototype.pictures = util.copy(self.pictures)
	prototype.integration_patch = util.copy(self.integration_patch)
	self:try_apply_to_named_corpse(prototype.name .. "-remnants")
end

---@param tint data.Color?
---@return data.RotatedSprite
---@nodiscard
function RadarGraphicsPack.get_pictures(tint)
	local assets_path = _defines.assets.base_assets .. "/graphics/entity/radar/"
	local base_path = _defines.assets.base .. "/graphics/entity/radar/"

	---@type data.RotatedSprite
	local pictures = {
		layers = {
			{
				filename = base_path .. "radar.png",
				priority = "low",
				width = 196,
				height = 254,
				apply_projection = false,
				direction_count = 64,
				line_length = 8,
				shift = util.by_pixel(1, -16),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(pictures.layers, {
			filename = assets_path .. "radar-mask.png",
			priority = "low",
			width = 196,
			height = 254,
			apply_projection = false,
			direction_count = 64,
			line_length = 8,
			shift = util.by_pixel(1, -16),
			tint = tint,
			scale = 0.5,
		})
		table.insert(pictures.layers, {
			filename = assets_path .. "radar-highlights.png",
			priority = "low",
			width = 196,
			height = 254,
			apply_projection = false,
			direction_count = 64,
			line_length = 8,
			shift = util.by_pixel(1, -16),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	table.insert(pictures.layers, {
		filename = base_path .. "radar-shadow.png",
		priority = "low",
		width = 336,
		height = 170,
		apply_projection = false,
		direction_count = 64,
		line_length = 8,
		shift = util.by_pixel(39, 6),
		draw_as_shadow = true,
		scale = 0.5,
	})

	return pictures
end

---@return data.Sprite
---@nodiscard
function RadarGraphicsPack.get_integration_patch()
	---@type data.Sprite
	local patch = {
		filename = _defines.assets.base .. "/graphics/entity/radar/radar-integration.png",
		priority = "low",
		width = 238,
		height = 216,
		shift = util.by_pixel(1.5, 4),
		scale = 0.5,
	}
	return patch
end

---@param tint data.Color?
---@return data.RotatedAnimationVariations
---@nodiscard
function RadarGraphicsPack.get_corpse_animation(tint)
	local assets_path = _defines.assets.base_assets .. "/graphics/entity/radar/remnants/"
	local base_path = _defines.assets.base .. "/graphics/entity/radar/remnants/"

	---@type data.RotatedAnimation
	local animation = {
		layers = {
			{
				filename = base_path .. "radar-remnants.png",
				width = 282,
				height = 212,
				direction_count = 1,
				shift = util.by_pixel(12, 4.5),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers, {
			filename = assets_path .. "radar-remnants-mask.png",
			width = 282,
			height = 212,
			direction_count = 1,
			shift = util.by_pixel(12, 4.5),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers, {
			filename = assets_path .. "radar-remnants-highlights.png",
			width = 282,
			height = 212,
			direction_count = 1,
			shift = util.by_pixel(12, 4.5),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	return { animation }
end

return RadarGraphicsPack
