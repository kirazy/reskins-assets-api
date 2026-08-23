local _defines = require("api.defines")
local _sprites = require("__reskins-sprite-utils__.sprites")

local CraftingMachineGraphicsPack = require("graphics-packs.abstractions.crafting-machine-graphics-pack")

---@class Reskins.Angels.ElectricBoilerGraphicsPack:Reskins.Abstractions.CraftingMachineGraphicsPack
local ElectricBoilerGraphicsPack = {}
ElectricBoilerGraphicsPack.__index = CraftingMachineGraphicsPack

-- Set up inheritance
setmetatable(ElectricBoilerGraphicsPack, {
	__index = CraftingMachineGraphicsPack,
})

---@type data.Animation4Way
local working_lights = _sprites.make_4way_animation_from_spritesheet({
	filename = "__reskins-assets-angels__/graphics/entity/boiler-electric/boiler-electric-working-lights.png",
	priority = "extra-high",
	width = 160,
	height = 160,
	shift = { 0, 0 },
	blend_mode = "additive",
	draw_as_glow = true,
})

---@class Reskins.Angels.ElectricBoilerGraphicsParams:Reskins.Abstractions.BaseGraphicsParams

---@param params Reskins.Angels.ElectricBoilerGraphicsParams
---@return Reskins.Angels.ElectricBoilerGraphicsPack
---@nodiscard
function ElectricBoilerGraphicsPack:configure(params)
	local instance = CraftingMachineGraphicsPack.configure(self, {
		tint = params.tint,
		scale = params.scale,
		scale_factor = params.scale_factor,
		required_assets = {
			[_defines.assets_source.angels_assets] = true,
		},
		nominal_width = 3,
		nominal_height = 3,
		graphics_set = self.get_graphics_set(params.tint),
	}) --[[@as Reskins.Angels.ElectricBoilerGraphicsPack]]

	-- Set the correct metatable for this class.
	setmetatable(instance, ElectricBoilerGraphicsPack)
	return instance
end

---@param tint data.Color?
---@return data.CraftingMachineGraphicsSet
---@nodiscard
function ElectricBoilerGraphicsPack.get_graphics_set(tint)
	local layers = {
		-- Base
		{
			filename = "__reskins-assets-angels__/graphics/entity/boiler-electric/boiler-electric-base.png",
			priority = "extra-high",
			width = 160,
			height = 160,
			shift = { 0, 0 },
		},
	}

	if tint then
		table.insert(layers, {
			-- Mask
			filename = "__reskins-assets-angels__/graphics/entity/boiler-electric/boiler-electric-mask.png",
			priority = "extra-high",
			width = 160,
			height = 160,
			shift = { 0, 0 },
			tint = tint,
		})
		table.insert(layers, {
			-- Highlights
			filename = "__reskins-assets-angels__/graphics/entity/boiler-electric/boiler-electric-highlights.png",
			priority = "extra-high",
			width = 160,
			height = 160,
			shift = { 0, 0 },
			blend_mode = "additive-soft",
		})
	end

	---@type data.CraftingMachineGraphicsSet
	local graphics_set = {
		animation = _sprites.make_4way_animation_from_spritesheet({ layers = layers }),
		working_visualisations = {
			{
				fadeout = true,
				effect = "uranium-glow",
				north_animation = working_lights.north,
				east_animation = working_lights.east,
				south_animation = working_lights.south,
				west_animation = working_lights.west,
			},
		},
	}

	return graphics_set
end

return ElectricBoilerGraphicsPack
