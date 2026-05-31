local _defines = require("api.defines")
local _sprites = require("__reskins-sprite-utils__.sprites")

local CraftingMachineGraphicsPack = require("crafting-machine-graphics-pack")

---@class Reskins.Base.FurnaceStoneGraphicsPack:Reskins.Abstractions.CraftingMachineGraphicsPack
local FurnaceStoneGraphicsPack = {}
FurnaceStoneGraphicsPack.__index = FurnaceStoneGraphicsPack

-- Setup inheritance.
setmetatable(FurnaceStoneGraphicsPack, {
	__index = CraftingMachineGraphicsPack,
})

---@class Reskins.Base.FurnaceStoneGraphicsParams
---@field tint data.Color?
---@field variant "standard" | "chemical"

-- Private sprite helpers

---@return data.Animation
---@private
local function get_stone_furnace_fire_animation()
	return {
		filename = "__base__/graphics/entity/stone-furnace/stone-furnace-fire.png",
		priority = "extra-high",
		width = 41,
		height = 100,
		line_length = 8,
		frame_count = 48,
		draw_as_glow = true,
		shift = util.by_pixel(-0.75, 5.5),
		scale = 0.5,
	}
end

---@return data.Animation
---@private
local function get_stone_furnace_ground_light()
	return {
		filename = "__base__/graphics/entity/stone-furnace/stone-furnace-ground-light.png",
		blend_mode = "additive",
		draw_as_light = true,
		width = 116,
		height = 110,
		repeat_count = 48,
		shift = util.by_pixel(-1, 44),
		scale = 0.5,
	}
end

---@param orientation? "bottom" | "left-front" | "left-rear" | "right-front" | "right-rear"
---@return data.Animation
---@private
local function get_stone_furnace_working_light(orientation)
	local filename
	if orientation then
		local bobs_lights = _defines.assets.bobs_assets .. "/graphics/entity/furnace-stone-chemical/lights/"
		filename = bobs_lights .. "furnace-stone-chemical-light-" .. orientation .. "-obscure.png"
	else
		filename = _defines.assets.base_assets .. "/graphics/entity/furnace-stone/lights/furnace-stone-light.png"
	end

	return {
		filename = filename,
		blend_mode = "additive",
		draw_as_glow = true,
		width = 152,
		height = 172,
		repeat_count = 48,
		shift = util.by_pixel(0, 1),
		scale = 0.5,
	}
end

-- Graphics set builders

---@param tint data.Color?
---@param variant "standard" | "chemical"
---@return data.CraftingMachineGraphicsSet
function FurnaceStoneGraphicsPack.get_graphics_set(tint, variant)
	local base_path = _defines.assets.base_assets .. "/graphics/entity/furnace-stone/"
	local bobs_path = _defines.assets.bobs_assets .. "/graphics/entity/furnace-stone-chemical/"

	local is_chemical = variant == "chemical"
	local assets_path = is_chemical and bobs_path or base_path
	local image_name = is_chemical and "furnace-stone-chemical" or "furnace-stone"
	local shadow_filename = is_chemical and (bobs_path .. "furnace-stone-chemical-shadow.png")
		or (base_path .. "shadows/furnace-stone-shadow.png")

	---@type data.Animation[]
	local layers = {
		{
			filename = assets_path .. image_name .. "-base.png",
			priority = "high",
			width = 152,
			height = 152,
			shift = util.by_pixel(0, 1),
			scale = 0.5,
		},
	}

	if tint then
		table.insert(layers, {
			filename = assets_path .. image_name .. "-mask.png",
			priority = "high",
			width = 152,
			height = 152,
			tint = tint,
			shift = util.by_pixel(0, 1),
			scale = 0.5,
		})
		table.insert(layers, {
			filename = assets_path .. image_name .. "-highlights.png",
			priority = "high",
			width = 152,
			height = 152,
			blend_mode = "additive-soft",
			shift = util.by_pixel(0, 1),
			scale = 0.5,
		})
	end

	table.insert(layers, {
		filename = shadow_filename,
		priority = "high",
		width = 176,
		height = 140,
		draw_as_shadow = true,
		shift = util.by_pixel(12, 3),
		scale = 0.5,
	})

	local animation = { layers = layers }

	---@type data.WorkingVisualisation[]
	local working_visualisations
	if is_chemical then
		working_visualisations = {
			-- Fire effect
			{
				fadeout = true,
				effect = "flicker",
				north_animation = get_stone_furnace_fire_animation(),
				south_animation = get_stone_furnace_fire_animation(),
				west_animation = get_stone_furnace_fire_animation(),
			},
			-- Furnace light
			{
				fadeout = true,
				effect = "flicker",
				north_animation = get_stone_furnace_working_light("right-rear"),
				east_animation = get_stone_furnace_working_light("bottom"),
				south_animation = get_stone_furnace_working_light("left-front"),
				west_animation = get_stone_furnace_working_light(),
			},
			-- Ground light
			{
				fadeout = true,
				effect = "flicker",
				north_animation = get_stone_furnace_ground_light(),
				south_animation = get_stone_furnace_ground_light(),
				west_animation = get_stone_furnace_ground_light(),
			},
		}
		animation = _sprites.make_4way_animation_from_spritesheet(animation)
	else
		working_visualisations = {
			-- Fire effect
			{
				fadeout = true,
				effect = "flicker",
				animation = get_stone_furnace_fire_animation(),
			},
			-- Furnace light
			{
				fadeout = true,
				effect = "flicker",
				animation = get_stone_furnace_working_light(),
			},
			-- Ground light
			{
				fadeout = true,
				effect = "flicker",
				animation = get_stone_furnace_ground_light(),
			},
		}
	end

	---@type data.CraftingMachineGraphicsSet
	return {
		animation = animation,
		working_visualisations = working_visualisations,
	}
end

---@param tint data.Color?
---@return data.CraftingMachineGraphicsSet
---@private
function FurnaceStoneGraphicsPack.get_graphics_set_flipped(tint)
	local bobs_path = _defines.assets.bobs_assets .. "/graphics/entity/furnace-stone-chemical/"

	---@type data.Animation[]
	local layers = {
		{
			filename = bobs_path .. "furnace-stone-chemical-mirror-base.png",
			priority = "high",
			width = 152,
			height = 152,
			shift = util.by_pixel(0, 1),
			scale = 0.5,
		},
	}

	if tint then
		table.insert(layers, {
			filename = bobs_path .. "furnace-stone-chemical-mirror-mask.png",
			priority = "high",
			width = 152,
			height = 152,
			tint = tint,
			shift = util.by_pixel(0, 1),
			scale = 0.5,
		})
		table.insert(layers, {
			filename = bobs_path .. "furnace-stone-chemical-mirror-highlights.png",
			priority = "high",
			width = 152,
			height = 152,
			blend_mode = "additive-soft",
			shift = util.by_pixel(0, 1),
			scale = 0.5,
		})
	end

	table.insert(layers, {
		filename = bobs_path .. "furnace-stone-chemical-mirror-shadow.png",
		priority = "high",
		width = 176,
		height = 140,
		draw_as_shadow = true,
		shift = util.by_pixel(12, 3),
		scale = 0.5,
	})

	---@type data.CraftingMachineGraphicsSet
	return {
		animation = _sprites.make_4way_animation_from_spritesheet({ layers = layers }),
		working_visualisations = {
			-- Fire effect
			{
				fadeout = true,
				effect = "flicker",
				north_animation = get_stone_furnace_fire_animation(),
				east_animation = get_stone_furnace_fire_animation(),
				south_animation = get_stone_furnace_fire_animation(),
			},
			-- Furnace light
			{
				fadeout = true,
				effect = "flicker",
				north_animation = get_stone_furnace_working_light("left-rear"),
				east_animation = get_stone_furnace_working_light(),
				south_animation = get_stone_furnace_working_light("right-front"),
				west_animation = get_stone_furnace_working_light("bottom"),
			},
			-- Ground light
			{
				fadeout = true,
				effect = "flicker",
				north_animation = get_stone_furnace_ground_light(),
				east_animation = get_stone_furnace_ground_light(),
				south_animation = get_stone_furnace_ground_light(),
			},
		},
	}
end

---@param tint data.Color?
---@param variant "standard" | "chemical"
---@return data.RotatedAnimationVariations
function FurnaceStoneGraphicsPack.get_corpse_animation(tint, variant)
	local is_chemical = variant == "chemical"
	local direction_count = is_chemical and 4 or 1
	local image_name = is_chemical and "furnace-stone-chemical-remnants" or "furnace-stone-remnants"
	local assets_path = is_chemical
			and (_defines.assets.bobs_assets .. "/graphics/entity/furnace-stone-chemical/remnants/")
		or (_defines.assets.base_assets .. "/graphics/entity/furnace-stone/remnants/")

	---@type data.RotatedAnimationVariations
	local animation = {
		layers = {
			{
				filename = assets_path .. image_name .. "-base.png",
				width = 202,
				height = 180,
				line_length = direction_count,
				direction_count = direction_count,
				shift = util.by_pixel(2, 17),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers, {
			filename = assets_path .. image_name .. "-mask.png",
			width = 202,
			height = 180,
			line_length = direction_count,
			direction_count = direction_count,
			tint = tint,
			shift = util.by_pixel(2, 17),
			scale = 0.5,
		})
		table.insert(animation.layers, {
			filename = assets_path .. image_name .. "-highlights.png",
			width = 202,
			height = 180,
			line_length = direction_count,
			direction_count = direction_count,
			blend_mode = "additive-soft",
			shift = util.by_pixel(2, 17),
			scale = 0.5,
		})
	end

	return animation
end

-- Public API

---@param params Reskins.Base.FurnaceStoneGraphicsParams
---@return Reskins.Base.FurnaceStoneGraphicsPack
---@nodiscard
function FurnaceStoneGraphicsPack:configure(params)
	local graphics_set = self.get_graphics_set(params.tint, params.variant)
	local graphics_set_flipped = nil
	if params.variant == "chemical" then
		graphics_set_flipped = self.get_graphics_set_flipped(params.tint)
	end

	local remnants = self.get_corpse_animation(params.tint, params.variant)

	local required_assets = { [_defines.assets.base_assets] = true }
	if params.variant == "chemical" then
		required_assets[_defines.assets.bobs_assets] = true
	end

	local instance = CraftingMachineGraphicsPack.configure(self, {
		tint = params.tint,
		remnants = remnants,
		required_assets = required_assets,
		graphics_set = graphics_set,
		graphics_set_flipped = graphics_set_flipped,
		-- Chemical variant has fluid boxes but must show them regardless of active recipe.
		fluid_boxes_off_when_no_fluid_recipe = params.variant == "chemical" and false or nil,
	}) --[[@as Reskins.Base.FurnaceStoneGraphicsPack]]

	setmetatable(instance, FurnaceStoneGraphicsPack)
	return instance
end

return FurnaceStoneGraphicsPack
