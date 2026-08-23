local _defines = require("api.defines")

local CraftingMachineGraphicsPack = require("graphics-packs.abstractions.crafting-machine-graphics-pack")

---@class Reskins.Angels.SteamCrackerGraphicsPack:Reskins.Abstractions.CraftingMachineGraphicsPack
local SteamCrackerGraphicsPack = {}
SteamCrackerGraphicsPack.__index = CraftingMachineGraphicsPack

-- Set up inheritance
setmetatable(SteamCrackerGraphicsPack, {
	__index = CraftingMachineGraphicsPack,
})

---@class Reskins.Angels.SteamCrackerGraphicsParams:Reskins.Abstractions.BaseGraphicsParams

---@param params Reskins.Angels.SteamCrackerGraphicsParams
---@return Reskins.Angels.SteamCrackerGraphicsPack
---@nodiscard
function SteamCrackerGraphicsPack:configure(params)
	local instance = CraftingMachineGraphicsPack.configure(self, {
		tint = params.tint,
		scale = params.scale,
		scale_factor = params.scale_factor,
		required_assets = {
			[_defines.assets_source.petrochem_graphics] = true,
		},
		nominal_width = 5,
		nominal_height = 5,
		graphics_set = self.get_graphics_set(params.tint),
	}) --[[@as Reskins.Angels.SteamCrackerGraphicsPack]]

	-- Set the correct metatable for this class.
	setmetatable(instance, SteamCrackerGraphicsPack)
	return instance
end

---@param tint data.Color?
---@return data.CraftingMachineGraphicsSet
---@nodiscard
function SteamCrackerGraphicsPack.get_graphics_set(tint)
	local animation = {
		layers = {
			-- Base
			{
				filename = "__angelspetrochemgraphics__/graphics/entity/steam-cracker/steam-cracker.png",
				priority = "extra-high",
				width = 512,
				height = 512,
				scale = 0.5,
				shift = { 0.5, -0.5 },
			},
		},
	}

	if tint then
		table.insert(animation.layers, {
			-- Mask
			filename = "__reskins-assets-angels__/graphics/entity/steam-cracker/steam-cracker-mask.png",
			priority = "extra-high",
			width = 512,
			height = 512,
			scale = 0.5,
			shift = { 0.5, -0.5 },
			tint = tint,
		})
		table.insert(animation.layers, {
			-- Highlights
			filename = "__reskins-assets-angels__/graphics/entity/steam-cracker/steam-cracker-highlights.png",
			priority = "extra-high",
			width = 512,
			height = 512,
			scale = 0.5,
			shift = { 0.5, -0.5 },
			blend_mode = "additive-soft",
		})
	end

	---@type data.CraftingMachineGraphicsSet
	local graphics_set = {
		animation = animation,
		working_visualisations = {
			-- Flame
			{
				fadeout = true,
				constant_speed = true,
				animation = {
					filename = "__base__/graphics/entity/oil-refinery/oil-refinery-fire.png",
					line_length = 10,
					width = 40,
					height = 81,
					frame_count = 60,
					animation_speed = 0.75,
					shift = util.by_pixel(-66, -110),
					draw_as_glow = true,
					scale = 0.5,
				},
			},
			-- Light
			{
				animation = {
					filename = "__reskins-assets-angels__/graphics/entity/steam-cracker/steam-cracker-light.png",
					priority = "extra-high",
					width = 512,
					height = 512,
					scale = 0.5,
					shift = { 0.5, -0.5 },
					blend_mode = "additive-soft",
					draw_as_glow = true,
				},
			},
		},
	}

	return graphics_set
end

return SteamCrackerGraphicsPack
