local _defines = require("api.defines")
local GraphicsPackBase = require("graphics-pack-base")

---@class StorageTankGraphicsPack:GraphicsPackBase
---@field pictures data.StorageTankPictures
local StorageTankGraphicsPack = {}
StorageTankGraphicsPack.__index = StorageTankGraphicsPack

-- Set up inheritance.
setmetatable(StorageTankGraphicsPack, {
	__index = GraphicsPackBase,
})

---@class StorageTankGraphicsParams
---@field tint data.Color?

---@param params StorageTankGraphicsParams
---@return StorageTankGraphicsPack
---@nodiscard
function StorageTankGraphicsPack:configure(params)
	local instance = GraphicsPackBase.configure(self, {
		tint = params.tint,
		remnants = self.get_corpse_animation(params.tint),
		required_assets = { [_defines.assets.base_assets] = true },
	}) --[[@as StorageTankGraphicsPack]]

	instance.pictures = self.get_pictures(params.tint)

	-- Set the correct metatable for this class.
	setmetatable(instance, StorageTankGraphicsPack)
	return instance
end

---@param prototype data.StorageTankPrototype
function StorageTankGraphicsPack:apply_to_entity(prototype)
	prototype.pictures = util.copy(self.pictures)
	self:try_apply_to_named_corpse(prototype.name .. "-remnants")
end

---@param tint data.Color?
---@return data.StorageTankPictures
---@nodiscard
function StorageTankGraphicsPack.get_pictures(tint)
	local base_path = _defines.assets.base .. "/graphics/entity/storage-tank/"
	local pipe_path = _defines.assets.base .. "/graphics/entity/pipe/"
	local assets_path = _defines.assets.base_assets .. "/graphics/entity/storage-tank/base/"

	local sheets = {
		{
			filename = base_path .. "storage-tank.png",
			priority = "extra-high",
			frames = 2,
			width = 219,
			height = 235,
			shift = util.by_pixel(-0.25, -1.25),
			scale = 0.5,
		},
	}

	if tint then
		table.insert(sheets, {
			filename = assets_path .. "storage-tank-mask.png",
			priority = "extra-high",
			frames = 2,
			width = 219,
			height = 215,
			shift = util.by_pixel(-0.25, 3.75),
			tint = tint,
			scale = 0.5,
		})
		table.insert(sheets, {
			filename = assets_path .. "storage-tank-highlights.png",
			priority = "extra-high",
			frames = 2,
			width = 219,
			height = 215,
			shift = util.by_pixel(-0.25, 3.75),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	table.insert(sheets, {
		filename = base_path .. "storage-tank-shadow.png",
		priority = "extra-high",
		frames = 2,
		width = 291,
		height = 153,
		shift = util.by_pixel(29.75, 22.25),
		scale = 0.5,
		draw_as_shadow = true,
	})

	---@type data.StorageTankPictures
	return {
		picture = { sheets = sheets },
		fluid_background = {
			filename = base_path .. "fluid-background.png",
			priority = "extra-high",
			width = 32,
			height = 15,
		},
		window_background = {
			filename = base_path .. "window-background.png",
			priority = "extra-high",
			width = 34,
			height = 48,
			scale = 0.5,
		},
		flow_sprite = {
			filename = pipe_path .. "fluid-flow-low-temperature.png",
			priority = "extra-high",
			width = 160,
			height = 20,
		},
		gas_flow = {
			filename = pipe_path .. "steam.png",
			priority = "extra-high",
			line_length = 10,
			width = 48,
			height = 30,
			frame_count = 60,
			animation_speed = 0.25,
			scale = 0.5,
		},
	}
end

---@param tint data.Color?
---@return data.RotatedAnimation
---@nodiscard
function StorageTankGraphicsPack.get_corpse_animation(tint)
	local base_path = _defines.assets.base .. "/graphics/entity/storage-tank/remnants/"
	local assets_path = _defines.assets.base_assets .. "/graphics/entity/storage-tank/remnants/"

	---@type data.RotatedAnimation
	local animation = {
		layers = {
			{
				filename = base_path .. "storage-tank-remnants.png",
				width = 426,
				height = 282,
				shift = util.by_pixel(27, 21),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers, {
			filename = assets_path .. "storage-tank-remnants-mask.png",
			width = 426,
			height = 282,
			shift = util.by_pixel(27, 21),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers, {
			filename = assets_path .. "storage-tank-remnants-highlights.png",
			width = 426,
			height = 282,
			shift = util.by_pixel(27, 21),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	return animation
end

return StorageTankGraphicsPack
