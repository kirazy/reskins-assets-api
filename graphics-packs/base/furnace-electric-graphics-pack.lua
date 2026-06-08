local _defines = require("api.defines")
local _pipes = require("assets.base.entities.pipe-pictures")
local _sprites = require("__reskins-sprite-utils__.sprites")

local CraftingMachineGraphicsPack = require("graphics-packs.abstractions.crafting-machine-graphics-pack")

---@class Reskins.Base.FurnaceElectricGraphicsPack:Reskins.Abstractions.CraftingMachineGraphicsPack
local FurnaceElectricGraphicsPack = {}
FurnaceElectricGraphicsPack.__index = FurnaceElectricGraphicsPack

-- Setup inheritance.
setmetatable(FurnaceElectricGraphicsPack, {
	__index = CraftingMachineGraphicsPack,
})

---@class Reskins.Base.FurnaceElectricGraphicsParams:Reskins.Abstractions.BaseGraphicsParams
---@field variant "standard" | "mixing" | "chemical" | "chemical-mixing"

-- Private sprite helpers

---Shared shadow layer used by all electric furnace variants.
---@return data.Animation
---@private
local function get_electric_furnace_shadow()
	return {
		filename = _defines.assets.base_assets .. "/graphics/entity/furnace-electric/shadows/furnace-electric-shadow.png",
		priority = "high",
		width = 228,
		height = 172,
		draw_as_shadow = true,
		shift = util.by_pixel(10.75, 7.25),
		scale = 0.5,
	}
end

---Shared heater working visualisation animation used by all electric furnace variants.
---@return data.Animation
---@private
local function get_electric_furnace_heater_animation()
	return {
		filename = _defines.assets.base_assets .. "/graphics/entity/furnace-electric/lights/furnace-electric-heater.png",
		priority = "high",
		width = 60,
		height = 56,
		frame_count = 12,
		animation_speed = 0.5,
		shift = util.by_pixel(2, 33),
		draw_as_glow = true,
		scale = 0.5,
	}
end

---Shared ground light working visualisation animation (from base game).
---@return data.Animation
---@private
local function get_electric_furnace_ground_light()
	return {
		filename = "__base__/graphics/entity/electric-furnace/electric-furnace-ground-light.png",
		blend_mode = "additive",
		width = 166,
		height = 124,
		shift = util.by_pixel(3, 69),
		draw_as_light = true,
		scale = 0.5,
	}
end

---@return data.WorkingVisualisation  -- large propeller
---@private
local function get_electric_furnace_large_propeller()
	return {
		animation = {
			filename = _defines.assets.base_assets .. "/graphics/entity/furnace-electric/animations/propeller-large.png",
			priority = "high",
			width = 38,
			height = 26,
			frame_count = 4,
			animation_speed = 0.5,
			shift = util.by_pixel(-20, -18),
			scale = 0.5,
		},
	}
end

---@param is_shifted boolean?
---@return data.WorkingVisualisation  -- small propeller
---@private
local function get_electric_furnace_small_propeller(is_shifted)
	local shift = is_shifted and util.by_pixel(1, -24) or util.by_pixel(4, -37.5)
	return {
		animation = {
			filename = _defines.assets.base_assets .. "/graphics/entity/furnace-electric/animations/propeller-small.png",
			priority = "high",
			width = 24,
			height = 16,
			frame_count = 4,
			animation_speed = 0.5,
			shift = shift,
			scale = 0.5,
		},
	}
end

---Returns the working light animation for the given variant and optional obstructed flag.
---@param variant "standard" | "mixing" | "chemical" | "chemical-mixing"
---@param is_obstructed boolean?
---@return data.Animation
---@private
local function get_electric_furnace_working_light(variant, is_obstructed)
	local filename
	if variant == "standard" then
		filename = _defines.assets.base_assets .. "/graphics/entity/furnace-electric/lights/furnace-electric-light.png"
	elseif variant == "mixing" then
		filename = _defines.assets.bobs_assets
			.. "/graphics/entity/furnace-electric-mixing/furnace-electric-mixing-light.png"
	elseif variant == "chemical" then
		filename = _defines.assets.bobs_assets
			.. "/graphics/entity/furnace-electric-chemical/furnace-chemical-electric-light.png"
	elseif variant == "chemical-mixing" then
		if is_obstructed then
			filename = _defines.assets.bobs_assets
				.. "/graphics/entity/furnace-electric-chemical-mixing/furnace-chemical-electric-mixing-light-obstructed.png"
		else
			filename = _defines.assets.bobs_assets
				.. "/graphics/entity/furnace-electric-chemical-mixing/furnace-chemical-electric-mixing-light.png"
		end
	end

	return {
		filename = filename,
		priority = "high",
		width = 238,
		height = 212,
		shift = util.by_pixel(1, 1),
		blend_mode = "additive",
		draw_as_glow = true,
		scale = 0.5,
	}
end

-- Graphics set builders

---@param tint data.Color?
---@param variant "standard" | "mixing" | "chemical" | "chemical-mixing"
---@return data.CraftingMachineGraphicsSet
function FurnaceElectricGraphicsPack.get_graphics_set(tint, variant)
	local base_path = _defines.assets.base_assets .. "/graphics/entity/furnace-electric/"
	local bobs_path = _defines.assets.bobs_assets .. "/graphics/entity/"

	-- Build the asset path and image name for the main sprite.
	local assets_path, image_name
	if variant == "standard" then
		assets_path = base_path
		image_name = "furnace-electric"
	elseif variant == "mixing" then
		assets_path = bobs_path .. "furnace-electric-mixing/"
		image_name = "furnace-electric-mixing"
	elseif variant == "chemical" then
		assets_path = bobs_path .. "furnace-electric-chemical/"
		image_name = "furnace-chemical-electric"
	elseif variant == "chemical-mixing" then
		assets_path = bobs_path .. "furnace-electric-chemical-mixing/"
		image_name = "furnace-chemical-electric-mixing"
	end

	-- All variants share the same animation dimensions and shift (238×212, shift (1,1)).
	---@type data.Animation[]
	local layers = {
		{
			filename = assets_path .. image_name .. "-base.png",
			priority = "high",
			width = 238,
			height = 212,
			shift = util.by_pixel(1, 1),
			scale = 0.5,
		},
	}

	if tint then
		table.insert(layers, {
			filename = assets_path .. image_name .. "-mask.png",
			priority = "high",
			width = 238,
			height = 212,
			tint = tint,
			shift = util.by_pixel(1, 1),
			scale = 0.5,
		})
		table.insert(layers, {
			filename = assets_path .. image_name .. "-highlights.png",
			priority = "high",
			width = 238,
			height = 212,
			blend_mode = "additive-soft",
			shift = util.by_pixel(1, 1),
			scale = 0.5,
		})
	end

	-- Shared shadow (all variants use the same shadow from base assets).
	table.insert(layers, get_electric_furnace_shadow())

	local animation = { layers = layers }

	-- Build working_visualisations per variant.
	---@type data.WorkingVisualisation[]
	local working_visualisations

	if variant == "standard" then
		working_visualisations = {
			-- Furnace heater
			{ fadeout = true, animation = get_electric_furnace_heater_animation() },
			-- Furnace light
			{ fadeout = true, animation = get_electric_furnace_working_light("standard") },
			-- Ground light
			{ fadeout = true, animation = get_electric_furnace_ground_light() },
			-- Propellers
			get_electric_furnace_large_propeller(),
			get_electric_furnace_small_propeller(),
		}
	elseif variant == "mixing" then
		working_visualisations = {
			-- Furnace heater
			{ fadeout = true, animation = get_electric_furnace_heater_animation() },
			-- Furnace light
			{ fadeout = true, animation = get_electric_furnace_working_light("mixing") },
			-- Ground light
			{ fadeout = true, animation = get_electric_furnace_ground_light() },
			-- Propellers
			get_electric_furnace_large_propeller(),
			get_electric_furnace_small_propeller(true),
		}
	elseif variant == "chemical" then
		working_visualisations = {
			-- Furnace heater (north/east/west — south is walled)
			{
				fadeout = true,
				north_animation = get_electric_furnace_heater_animation(),
				east_animation = get_electric_furnace_heater_animation(),
				west_animation = get_electric_furnace_heater_animation(),
			},
			-- Furnace light
			{
				fadeout = true,
				north_animation = get_electric_furnace_working_light("chemical"),
				east_animation = get_electric_furnace_working_light("chemical"),
				west_animation = get_electric_furnace_working_light("chemical"),
			},
			-- Ground light
			{
				fadeout = true,
				north_animation = get_electric_furnace_ground_light(),
				east_animation = get_electric_furnace_ground_light(),
				west_animation = get_electric_furnace_ground_light(),
			},
		}
	elseif variant == "chemical-mixing" then
		working_visualisations = {
			-- Furnace heater (north/east/west)
			{
				fadeout = true,
				north_animation = get_electric_furnace_heater_animation(),
				east_animation = get_electric_furnace_heater_animation(),
				west_animation = get_electric_furnace_heater_animation(),
			},
			-- Furnace light (south uses obstructed variant)
			{
				fadeout = true,
				north_animation = get_electric_furnace_working_light("chemical-mixing"),
				east_animation = get_electric_furnace_working_light("chemical-mixing"),
				south_animation = get_electric_furnace_working_light("chemical-mixing", true),
				west_animation = get_electric_furnace_working_light("chemical-mixing"),
			},
			-- Ground light
			{
				fadeout = true,
				north_animation = get_electric_furnace_ground_light(),
				east_animation = get_electric_furnace_ground_light(),
				west_animation = get_electric_furnace_ground_light(),
			},
			-- Small propeller (shifted)
			get_electric_furnace_small_propeller(true),
		}
	end

	---@type data.CraftingMachineGraphicsSet
	return {
		animation = animation,
		working_visualisations = working_visualisations,
	}
end

---Builds the shared remnant base+mask+highlights layer stack.
---
---Chemical and chemical-mixing variants add an overlay layer on top.
---@param tint data.Color?
---@param variant "standard" | "mixing" | "chemical" | "chemical-mixing"
---@return data.RotatedAnimationVariations
function FurnaceElectricGraphicsPack.get_corpse_animation(tint, variant)
	local base_remnants = _defines.assets.base_assets .. "/graphics/entity/furnace-electric/remnants/"

	-- All variants share the base remnant from __base__ plus mask/highlights from base assets.
	---@type data.RotatedAnimationVariations
	local animation = {
		layers = {
			-- Vanilla base remnant
			{
				filename = "__base__/graphics/entity/electric-furnace/remnants/electric-furnace-remnants.png",
				width = 454,
				height = 448,
				direction_count = 1,
				shift = util.by_pixel(-3.25, 7.25),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers, {
			filename = base_remnants .. "furnace-electric-remnants-mask.png",
			width = 214,
			height = 208,
			direction_count = 1,
			tint = tint,
			shift = util.by_pixel(-3.25, 7.25),
			scale = 0.5,
		})
		table.insert(animation.layers, {
			filename = base_remnants .. "furnace-electric-remnants-highlights.png",
			width = 214,
			height = 208,
			direction_count = 1,
			blend_mode = "additive-soft",
			shift = util.by_pixel(-3.25, 7.25),
			scale = 0.5,
		})
	end

	-- Chemical and chemical-mixing add a variant-specific overlay layer.
	local overlay_filename
	if variant == "chemical" then
		overlay_filename = _defines.assets.bobs_assets
			.. "/graphics/entity/furnace-electric-chemical/remnants/furnace-chemical-electric-remnants-overlay.png"
	elseif variant == "chemical-mixing" then
		overlay_filename = _defines.assets.bobs_assets
			.. "/graphics/entity/furnace-electric-chemical-mixing/remnants/furnace-chemical-electric-mixing-remnants-overlay.png"
	end

	if overlay_filename then
		table.insert(animation.layers, {
			filename = overlay_filename,
			width = 214,
			height = 208,
			direction_count = 1,
			shift = util.by_pixel(-3.25, 7.25),
			scale = 0.5,
		})
	end

	return animation
end

---Builds the pipe picture `Sprite4Way` for the chemical electric furnace fluid boxes.
---
---Both the `"chemical"` and `"chemical-mixing"` variants share the same pipe picture sprites
---from the `furnace-electric-chemical/pipes/` asset folder.
---@param tint data.Color?
---@return FluidBoxGraphics
---@private
local function get_electric_furnace_fluid_box_graphics(tint)
	local pipes_path = _defines.assets.bobs_assets .. "/graphics/entity/furnace-electric-chemical/pipes/"

	---@type data.Sprite4Way
	local pictures = {
		-- North: base layer only (no mask/highlights — wall-side pipe connection)
		north = {
			filename = pipes_path .. "furnace-chemical-electric-pipe-north-base.png",
			priority = "extra-high",
			width = 70,
			height = 26,
			shift = util.by_pixel(2.5, 10),
			scale = 0.5,
		},
		-- East
		east = {
			filename = pipes_path .. "furnace-chemical-electric-pipe-east-base.png",
			priority = "extra-high",
			width = 30,
			height = 70,
			shift = util.by_pixel(-20.5, 3),
			scale = 0.5,
		},
		-- South
		south = {
			filename = pipes_path .. "furnace-chemical-electric-pipe-south-base.png",
			priority = "extra-high",
			width = 76,
			height = 58,
			shift = util.by_pixel(0.5, -30.5),
			scale = 0.5,
		},
		-- West
		west = {
			filename = pipes_path .. "furnace-chemical-electric-pipe-west-base.png",
			priority = "extra-high",
			width = 22,
			height = 68,
			shift = util.by_pixel(21.5, 2),
			scale = 0.5,
		},
	}

	if tint then
		-- East: wrap base with mask + highlights layers
		pictures.east = {
			layers = {
				pictures.east,
				{
					filename = pipes_path .. "furnace-chemical-electric-pipe-east-mask.png",
					priority = "extra-high",
					width = 30,
					height = 70,
					tint = tint,
					shift = util.by_pixel(-20.5, 3),
					scale = 0.5,
				},
				{
					filename = pipes_path .. "furnace-chemical-electric-pipe-east-highlights.png",
					priority = "extra-high",
					width = 30,
					height = 70,
					blend_mode = "additive-soft",
					shift = util.by_pixel(-20.5, 3),
					scale = 0.5,
				},
			},
		}
		-- South
		pictures.south = {
			layers = {
				pictures.south,
				{
					filename = pipes_path .. "furnace-chemical-electric-pipe-south-mask.png",
					priority = "extra-high",
					width = 76,
					height = 58,
					tint = tint,
					shift = util.by_pixel(0.5, -30.5),
					scale = 0.5,
				},
				{
					filename = pipes_path .. "furnace-chemical-electric-pipe-south-highlights.png",
					priority = "extra-high",
					width = 76,
					height = 58,
					blend_mode = "additive-soft",
					shift = util.by_pixel(0.5, -30.5),
					scale = 0.5,
				},
			},
		}
		-- West
		pictures.west = {
			layers = {
				pictures.west,
				{
					filename = pipes_path .. "furnace-chemical-electric-pipe-west-mask.png",
					priority = "extra-high",
					width = 22,
					height = 68,
					tint = tint,
					shift = util.by_pixel(21.5, 2),
					scale = 0.5,
				},
				{
					filename = pipes_path .. "furnace-chemical-electric-pipe-west-highlights.png",
					priority = "extra-high",
					width = 22,
					height = 68,
					blend_mode = "additive-soft",
					shift = util.by_pixel(21.5, 2),
					scale = 0.5,
				},
			},
		}
	end

	---@type FluidBoxGraphics
	return {
		pipe_covers = _pipes.pipe_covers(_defines.pipe_material.iron),
		pipe_picture = pictures,
	}
end

-- Public API

---@param params Reskins.Base.FurnaceElectricGraphicsParams
---@return Reskins.Base.FurnaceElectricGraphicsPack
---@nodiscard
function FurnaceElectricGraphicsPack:configure(params)
	local graphics_set = self.get_graphics_set(params.tint, params.variant)
	local remnants = self.get_corpse_animation(params.tint, params.variant)

	local has_fluid_boxes = params.variant == "chemical" or params.variant == "chemical-mixing"
	local fluid_boxes = has_fluid_boxes and { get_electric_furnace_fluid_box_graphics(params.tint) } or nil

	local required_assets = { [_defines.assets.base_assets] = true }
	if params.variant ~= "standard" then
		required_assets[_defines.assets.bobs_assets] = true
	end

	local instance = CraftingMachineGraphicsPack.configure(self, {
		tint = params.tint,
		scale = params.scale,
		scale_factor = params.scale_factor,
		remnants = remnants,
		required_assets = required_assets,
		nominal_width = 3,
		nominal_height = 3,
		graphics_set = graphics_set,
		fluid_boxes = fluid_boxes,
		-- Chemical variants gate fluid box visibility on the active recipe.
		fluid_boxes_off_when_no_fluid_recipe = has_fluid_boxes and true or nil,
	}) --[[@as Reskins.Base.FurnaceElectricGraphicsPack]]

	setmetatable(instance, FurnaceElectricGraphicsPack)
	return instance
end

return FurnaceElectricGraphicsPack
