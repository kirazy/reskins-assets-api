local _defines = require("api.defines")
local GraphicsPackBase = require("graphics-packs.abstractions.graphics-pack-base")

---@class Reskins.Base.PumpGraphicsPack:Reskins.Abstractions.GraphicsPackBase
---@field animations data.Animation4Way
local PumpGraphicsPack = {}
PumpGraphicsPack.__index = PumpGraphicsPack

-- Set up inheritance.
setmetatable(PumpGraphicsPack, {
	__index = GraphicsPackBase,
})

---@class Reskins.Base.PumpGraphicsParams
---@field tint data.Color?

---@param params Reskins.Base.PumpGraphicsParams
---@return Reskins.Base.PumpGraphicsPack
---@nodiscard
function PumpGraphicsPack:configure(params)
	local instance = GraphicsPackBase.configure(self, {
		tint = params.tint,
		remnants = self.get_corpse_animation(params.tint),
		required_assets = { [_defines.assets.base_assets] = true },
	}) --[[@as Reskins.Base.PumpGraphicsPack]]

	instance.animations = self.get_animations(params.tint)

	-- Set the correct metatable for this class.
	setmetatable(instance, PumpGraphicsPack)
	return instance
end

---@param prototype data.PumpPrototype
function PumpGraphicsPack:apply_to_entity(prototype)
	prototype.animations = util.copy(self.animations)
end

---@param tint data.Color?
---@return data.Animation4Way
---@nodiscard
function PumpGraphicsPack.get_animations(tint)
	local base_path = _defines.assets.base .. "/graphics/entity/pump/"
	local assets_path = _defines.assets.base_assets .. "/graphics/entity/pump/"

	---@type data.Animation4Way
	local animations = {
		north = {
			layers = {
				{
					filename = base_path .. "pump-north.png",
					width = 103,
					height = 164,
					scale = 0.5,
					line_length = 8,
					frame_count = 32,
					animation_speed = 0.5,
					shift = util.by_pixel(8, -0.85),
				},
			},
		},
		east = {
			layers = {
				{
					filename = base_path .. "pump-east.png",
					width = 130,
					height = 109,
					scale = 0.5,
					line_length = 8,
					frame_count = 32,
					animation_speed = 0.5,
					shift = util.by_pixel(-0.5, 1.75),
				},
			},
		},
		south = {
			layers = {
				{
					filename = base_path .. "pump-south.png",
					width = 114,
					height = 160,
					scale = 0.5,
					line_length = 8,
					frame_count = 32,
					animation_speed = 0.5,
					shift = util.by_pixel(12.5, -8),
				},
			},
		},
		west = {
			layers = {
				{
					filename = base_path .. "pump-west.png",
					width = 131,
					height = 111,
					scale = 0.5,
					line_length = 8,
					frame_count = 32,
					animation_speed = 0.5,
					shift = util.by_pixel(-0.25, 1.25),
				},
			},
		},
	}

	if tint then
		-- North mask/highlights have a different shift from the north base layer.
		table.insert(animations.north.layers, {
			filename = assets_path .. "pump-north-mask.png",
			width = 103,
			height = 164,
			scale = 0.5,
			line_length = 8,
			frame_count = 32,
			animation_speed = 0.5,
			shift = util.by_pixel(8, 3.5),
			tint = tint,
		})
		table.insert(animations.north.layers, {
			filename = assets_path .. "pump-north-highlights.png",
			width = 103,
			height = 164,
			scale = 0.5,
			line_length = 8,
			frame_count = 32,
			animation_speed = 0.5,
			shift = util.by_pixel(8, 3.5),
			blend_mode = "additive-soft",
		})

		table.insert(animations.east.layers, {
			filename = assets_path .. "pump-east-mask.png",
			width = 130,
			height = 109,
			scale = 0.5,
			line_length = 8,
			frame_count = 32,
			animation_speed = 0.5,
			shift = util.by_pixel(-0.5, 1.75),
			tint = tint,
		})
		table.insert(animations.east.layers, {
			filename = assets_path .. "pump-east-highlights.png",
			width = 130,
			height = 109,
			scale = 0.5,
			line_length = 8,
			frame_count = 32,
			animation_speed = 0.5,
			shift = util.by_pixel(-0.5, 1.75),
			blend_mode = "additive-soft",
		})

		table.insert(animations.south.layers, {
			filename = assets_path .. "pump-south-mask.png",
			width = 114,
			height = 160,
			scale = 0.5,
			line_length = 8,
			frame_count = 32,
			animation_speed = 0.5,
			shift = util.by_pixel(12.5, -8),
			tint = tint,
		})
		table.insert(animations.south.layers, {
			filename = assets_path .. "pump-south-highlights.png",
			width = 114,
			height = 160,
			scale = 0.5,
			line_length = 8,
			frame_count = 32,
			animation_speed = 0.5,
			shift = util.by_pixel(12.5, -8),
			blend_mode = "additive-soft",
		})

		table.insert(animations.west.layers, {
			filename = assets_path .. "pump-west-mask.png",
			width = 131,
			height = 111,
			scale = 0.5,
			line_length = 8,
			frame_count = 32,
			animation_speed = 0.5,
			shift = util.by_pixel(-0.25, 1.25),
			tint = tint,
		})
		table.insert(animations.west.layers, {
			filename = assets_path .. "pump-west-highlights.png",
			width = 131,
			height = 111,
			scale = 0.5,
			line_length = 8,
			frame_count = 32,
			animation_speed = 0.5,
			shift = util.by_pixel(-0.25, 1.25),
			blend_mode = "additive-soft",
		})
	end

	return animations
end

---@param tint data.Color?
---@return data.RotatedAnimationVariations
---@nodiscard
function PumpGraphicsPack.get_corpse_animation(tint)
	local base_path = _defines.assets.base .. "/graphics/entity/pump/remnants/"
	local assets_path = _defines.assets.base_assets .. "/graphics/entity/pump/remnants/"

	---@type data.RotatedAnimation
	local animation = {
		layers = {
			{
				filename = base_path .. "pump-remnants.png",
				width = 188,
				height = 186,
				direction_count = 4,
				shift = util.by_pixel(2, 2),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers, {
			filename = assets_path .. "pump-remnants-mask.png",
			width = 188,
			height = 186,
			direction_count = 4,
			shift = util.by_pixel(2, 2),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers, {
			filename = assets_path .. "pump-remnants-highlights.png",
			width = 188,
			height = 186,
			direction_count = 4,
			shift = util.by_pixel(2, 2),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	return { animation }
end

return PumpGraphicsPack
