local _defines = require("api.defines")
local V = require("__reskins-sprite-utils__.validation")

local CraftingMachineGraphicsPack = require("graphics-packs.abstractions.crafting-machine-graphics-pack")

---@class Reskins.Angels.CastingMachineGraphicsPack:Reskins.Abstractions.CraftingMachineGraphicsPack
local CastingMachineGraphicsPack = {}
CastingMachineGraphicsPack.__index = CraftingMachineGraphicsPack

-- Set up inheritance
setmetatable(CastingMachineGraphicsPack, {
	__index = CraftingMachineGraphicsPack,
})

---The symmetry a casting machine may be forced into, the sprites being drawn for that one axis.
local ForcedSymmetry = V.literal("horizontal"):optional()

---@class Reskins.Angels.CastingMachineGraphicsParams:Reskins.Abstractions.BaseGraphicsParams

---@param params Reskins.Angels.CastingMachineGraphicsParams
---@return Reskins.Angels.CastingMachineGraphicsPack
---@nodiscard
function CastingMachineGraphicsPack:configure(params)
	local instance = CraftingMachineGraphicsPack.configure(self, {
		tint = params.tint,
		scale = params.scale,
		scale_factor = params.scale_factor,
		required_assets = {
			[_defines.assets_source.smelting_graphics] = true,
		},
		nominal_width = 3,
		nominal_height = 3,
		graphics_set = self.get_graphics_set(params.tint),
		graphics_set_flipped = self.get_graphics_set_flipped(params.tint),
		fluid_boxes = {},
		fluid_boxes_off_when_no_fluid_recipe = false,
	}) --[[@as Reskins.Angels.CastingMachineGraphicsPack]]

	-- Set the correct metatable for this class.
	setmetatable(instance, CastingMachineGraphicsPack)
	return instance
end

---Applies a copy of the graphics pack to the specified `prototype`.
---
---#### Exceptions
---*@throws* - `string` - When `prototype` is `nil`.\
---*@throws* - `string` - When `prototype` is is not a `table`.
---
---#### Implementation Guidance
---- This is an abstract method that must be implemented by subclasses.
---- Implementations should mutate the prototype in place, and set copies of the graphics.
---@param prototype data.CraftingMachinePrototype
function CastingMachineGraphicsPack:apply_to_entity(prototype)
	ForcedSymmetry:assert(prototype.forced_symmetry, "prototype.forced_symmetry", "apply_to_entity")

	CraftingMachineGraphicsPack.apply_to_entity(self, prototype)
end

---@param tint data.Color?
---@param is_flipped boolean?
---@return data.CraftingMachineGraphicsSet
---@nodiscard
local function get_graphics_set_internal(tint, is_flipped)
	local flipped = is_flipped == true and "-flipped" or ""

	local working_visualisations = {
		-- Integration patch.
		{
			always_draw = true,
			render_layer = "floor",
			animation = util.sprite_load(
				"__angelssmeltinggraphics__/graphics/entity/casting-machine/casting-machine-integration-patch" .. flipped,
				{
					priority = "high",
					scale = 0.5,
				}
			),
		},
	}

	if tint then
		table.insert(working_visualisations, {
			always_draw = true,
			animation = {
				layers = {
					util.sprite_load(
						"__reskins-assets-angels__/graphics/entity/casting-machine/casting-machine" .. flipped .. "-mask",
						{
							priority = "high",
							frame_count = 49,
							animation_speed = 0.5,
							tint = tint,
							scale = 0.5,
						}
					),
					util.sprite_load(
						"__reskins-assets-angels__/graphics/entity/casting-machine/casting-machine" .. flipped .. "-highlights",
						{
							priority = "high",
							frame_count = 49,
							animation_speed = 0.5,
							blend_mode = "additive-soft",
							scale = 0.5,
						}
					),
				},
			},
		})
	end

	---@type data.CraftingMachineGraphicsSet
	local graphics_set = {
		animation = {
			layers = {
				util.sprite_load(
					"__angelssmeltinggraphics__/graphics/entity/casting-machine/casting-machine-animation" .. flipped,
					{
						priority = "high",
						frame_count = 49,
						animation_speed = 0.5,
						scale = 0.5,
					}
				),
				util.sprite_load(
					"__angelssmeltinggraphics__/graphics/entity/casting-machine/casting-machine-animation-shadow" .. flipped,
					{
						priority = "high",
						frame_count = 49,
						animation_speed = 0.5,
						draw_as_shadow = true,
						scale = 0.5,
					}
				),
				util.sprite_load(
					"__angelssmeltinggraphics__/graphics/entity/casting-machine/casting-machine-lights" .. flipped,
					{
						priority = "high",
						frame_count = 49,
						animation_speed = 0.5,
						draw_as_light = true,
						scale = 0.5,
					}
				),
			},
		},
		working_visualisations = working_visualisations,
	}

	return graphics_set
end

---@param tint data.Color?
---@return data.CraftingMachineGraphicsSet
---@nodiscard
function CastingMachineGraphicsPack.get_graphics_set(tint)
	return get_graphics_set_internal(tint, false)
end

---@param tint data.Color?
---@return data.CraftingMachineGraphicsSet
---@nodiscard
function CastingMachineGraphicsPack.get_graphics_set_flipped(tint)
	return get_graphics_set_internal(tint, true)
end

return CastingMachineGraphicsPack
