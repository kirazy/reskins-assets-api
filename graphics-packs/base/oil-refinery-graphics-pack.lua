local _defines = require("api.defines")
local _sprites = require("__reskins-sprite-utils__.sprites")

local CraftingMachineGraphicsPack = require("crafting-machine-graphics-pack")

---@class Reskins.Base.OilRefineryGraphicsPack:Reskins.Abstractions.CraftingMachineGraphicsPack
local OilRefineryGraphicsPack = {}
OilRefineryGraphicsPack.__index = OilRefineryGraphicsPack

-- Setup inheritance.
setmetatable(OilRefineryGraphicsPack, {
	__index = CraftingMachineGraphicsPack,
})

---@class Reskins.Base.OilRefineryGraphicsParams
---@field tint data.Color?

---@param params Reskins.Base.OilRefineryGraphicsParams
---@return Reskins.Base.OilRefineryGraphicsPack
---@nodiscard
function OilRefineryGraphicsPack:configure(params)
	local graphics_set = self.get_graphics_set(params.tint)
	local remnants = self.get_corpse_animation(params.tint)

	local instance = CraftingMachineGraphicsPack.configure(self, {
		tint = params.tint,
		remnants = remnants,
		required_assets = { [_defines.assets.base_assets] = true },
		graphics_set = graphics_set,
	}) --[[@as Reskins.Base.OilRefineryGraphicsPack]]

	setmetatable(instance, OilRefineryGraphicsPack)
	return instance
end

---@param tint data.Color?
---@return data.CraftingMachineGraphicsSet
function OilRefineryGraphicsPack.get_graphics_set(tint)
	local assets_path = _defines.assets.base_assets .. "/graphics/entity/oil-refinery/"

	---@type data.Animation[]
	local layers = {
		-- Base
		{
			filename = "__base__/graphics/entity/oil-refinery/oil-refinery.png",
			priority = "high",
			width = 386,
			height = 430,
			shift = util.by_pixel(0, -7.5),
			scale = 0.5,
		},
	}

	if tint then
		table.insert(layers, {
			filename = assets_path .. "oil-refinery-mask.png",
			priority = "high",
			width = 386,
			height = 430,
			shift = util.by_pixel(0, -7.5),
			tint = tint,
			scale = 0.5,
		})
		table.insert(layers, {
			filename = assets_path .. "oil-refinery-highlights.png",
			priority = "high",
			width = 386,
			height = 430,
			shift = util.by_pixel(0, -7.5),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	-- Shadow
	table.insert(layers, {
		filename = "__base__/graphics/entity/oil-refinery/oil-refinery-shadow.png",
		width = 674,
		height = 426,
		shift = util.by_pixel(82.5, 26.5),
		draw_as_shadow = true,
		scale = 0.5,
	})

	---@type data.CraftingMachineGraphicsSet
	local graphics_set = {
		animation = _sprites.make_4way_animation_from_spritesheet({ layers = layers }),
	}

	return graphics_set
end

---@param tint data.Color?
---@return data.RotatedAnimationVariations
function OilRefineryGraphicsPack.get_corpse_animation(tint)
	local assets_path = _defines.assets.base_assets .. "/graphics/entity/oil-refinery/remnants/"

	---@type data.RotatedAnimation
	local animation = {
		layers = {
			{
				filename = "__base__/graphics/entity/oil-refinery/remnants/refinery-remnants.png",
				width = 467,
				height = 415,
				direction_count = 1,
				shift = util.by_pixel(-0.25, -0.25),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers, {
			filename = assets_path .. "oil-refinery-remnants-mask.png",
			width = 467,
			height = 415,
			direction_count = 1,
			shift = util.by_pixel(-0.25, -0.25),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers, {
			filename = assets_path .. "oil-refinery-remnants-highlights.png",
			width = 467,
			height = 415,
			direction_count = 1,
			shift = util.by_pixel(-0.25, -0.25),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	return animation
end

return OilRefineryGraphicsPack
