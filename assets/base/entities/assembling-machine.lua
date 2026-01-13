-- THIS MODULE IS EXTREMELY WIP AND SUBJECT TO CHANGE.
-- The require path, function names and signatures are not stable.

local _defines = require("api.defines")
local _base_icon_fns = require("assets.base.icons")
local _pipe_pictures = require("assets.base.entities.pipe-pictures")

---@class Internal.AssemblyMachineOptions
---@field use_electronics_set boolean?
---@field use_burner_set boolean? # Not implemented.
---@field use_steam_set boolean? # Not implemented.

---@alias AssemblyMachineTiers 1|2|3|4|5|6

---@alias ElectronicsAssemblyMachineTiers 1|2|3

---@param sprite_set int
---@param tint data.Color?
---@param flags Internal.AssemblyMachineOptions
---@return data.Animation animation, int draw_order, Reskins.Defines.Assets[] required_assets
local function get_entity_animation(sprite_set, tint, flags)
	local shadow_sprite_set = (sprite_set >= 5) and 4 or sprite_set
	sprite_set = (sprite_set >= 5) and 5 or sprite_set

	-- Increment the draw_offset for use with fluid-boxes for every additional base-layer
	local draw_offset = 1

	local required_assets = {
		_defines.assets.base,
	}

	local assets_base_path = "__reskins-assets-base__/graphics/entity/assembling-machine/"

	---@type data.Animation
	local animation = {
		layers = {
			{
				filename = assets_base_path .. "assembling-machine-base.png",
				priority = "high",
				width = 214,
				height = 237,
				repeat_count = 32,
				shift = util.by_pixel(0, -0.75),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers, {
			filename = assets_base_path .. "assembling-machine-base-mask.png",
			priority = "high",
			width = 214,
			height = 237,
			repeat_count = 32,
			shift = util.by_pixel(0, -0.75),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers, {
			filename = assets_base_path .. "assembling-machine-base-highlights.png",
			priority = "high",
			width = 214,
			height = 237,
			repeat_count = 32,
			shift = util.by_pixel(0, -0.75),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
		draw_offset = draw_offset + 2
	end

	table.insert(animation.layers, {
		filename = assets_base_path .. "animations/assembling-machine-animation-" .. sprite_set .. ".png",
		priority = "high",
		width = 214,
		height = 237,
		frame_count = 32,
		line_length = 8,
		shift = util.by_pixel(0, -0.75),
		scale = 0.5,
	})
	table.insert(animation.layers, {
		filename = assets_base_path .. "shadows/assembling-machine-" .. shadow_sprite_set .. "-shadow.png",
		priority = "high",
		width = 264,
		height = 165,
		frame_count = 32,
		line_length = 8,
		draw_as_shadow = true,
		shift = util.by_pixel(27, 5),
		scale = 0.5,
	})

	if flags.use_electronics_set then
		table.insert(required_assets, _defines.assets.bobs_assets)

		local assets_bobs_path = "__reskins-assets-bobs__/graphics/entity/assembling-machine-electronics/"
		table.insert(animation.layers, {
			filename = assets_bobs_path .. "assembling-machine-electronics-base.png",
			priority = "high",
			width = 214,
			height = 237,
			repeat_count = 32,
			shift = util.by_pixel(0, -0.75),
			scale = 0.5,
		})
		draw_offset = draw_offset + 1
		if tint then
			table.insert(animation.layers, {
				filename = assets_bobs_path .. "assembling-machine-electronics-mask.png",
				priority = "high",
				width = 214,
				height = 237,
				repeat_count = 32,
				shift = util.by_pixel(0, -0.75),
				tint = tint,
				scale = 0.5,
			})
			table.insert(animation.layers, {
				filename = assets_bobs_path .. "assembling-machine-electronics-highlights.png",
				priority = "high",
				width = 214,
				height = 237,
				repeat_count = 32,
				shift = util.by_pixel(0, -0.75),
				blend_mode = "additive-soft",
				scale = 0.5,
			})
			draw_offset = draw_offset + 2
		end
		table.insert(animation.layers, {
			filename = assets_bobs_path .. "assembling-machine-electronics-shadow.png",
			priority = "high",
			width = 264,
			height = 165,
			repeat_count = 32,
			draw_as_shadow = true,
			shift = util.by_pixel(27, 5),
			scale = 0.5,
		})
	end

	return animation, draw_offset, required_assets
end

local function get_corpse_animation(tint)
	error("get_corpse_animation is not implemented")
end

---@param tier AssemblyMachineTiers
---@param tint data.Color?
---@param icon_data data.IconData[]
---@param options Internal.AssemblyMachineOptions
---@return CraftingMachineGraphicsPack graphics_pack
local function make_graphics_pack(tier, tint, icon_data, options)
	-- Sprites themselves are zero-based.
	local sprite_set = tier - 1

	local animation, draw_order, required_assets = get_entity_animation(sprite_set, tint, options)

	---@type CraftingMachineGraphicsPack
	local graphics_pack = {
		icons = icon_data,
		graphics_set = {
			animation = animation,
			water_reflection = {},
		},
		fluid_boxes = {
			{
				pipe_covers = _pipe_pictures.pipe_covers(),
				pipe_picture = _pipe_pictures.pipe_pictures(),
				secondary_draw_orders = {
					north = -1,
					east = draw_order,
					south = draw_order,
					west = draw_order,
				},
			},
		},
		required_assets = required_assets,
		remnants = get_corpse_animation(tint),
		has_required_asset_mods = function(self)
			for _, mod_name in pairs(self.required_assets) do
				if not mods[mod_name] then
					return false
				end
			end

			return true
		end,
		apply_to_entity = function(self, prototype)
			assert(prototype, "prototype must not be nil")
			assert(type(prototype) == "table", "prototype must be a table")

			-- Apply copies so that downstream changes will not affect the graphics pack.
			prototype.icons = util.copy(self.icons)
			prototype.icon = nil
			prototype.icon_size = nil

			prototype.graphics_set = util.copy(self.graphics_set)

			-- Need to handle fluid boxes, explosions, particles.
			error("apply_to_entity is not implemented")
		end,
		apply_to_corpse = function(self, corpse)
			assert(corpse, "corpse must not be nil")
			assert(type(corpse) == "table", "corpse must be a table")

			-- Apply copies so that downstream changes will not affect the graphics pack.
			corpse.icons = util.copy(self.icons)
			corpse.icon = nil
			corpse.icon_size = nil

			-- Apply the corpse graphics
			corpse.animation = util.copy(self.remnants)
		end,
	}

	return graphics_pack
end

---@class Reskins.Assets.Base.Entities.AssemblingMachines
local _packs = {}

---Gets the graphics pack for a standard assembling machine for the specified `sprite_set`, optionally tinted using the
---provided `color`.
---
---### Parameters
---@param sprite_set AssemblyMachineTiers The set of assembling machine animation sprites to use, from 1 to 6.
---@param color data.Color? The color of the assembly machine. When `nil`, the resulting graphics will be uncolored.
---@return CraftingMachineGraphicsPack graphics_pack
---
---### Examples
---```lua
----- Color the third assembling machine red, along with its remnants.
---local assets = require("__reskins-assets-api__.assets.entities")
---
----- Make it red, using the 6th sprite animation set.
---local graphics_pack = assets.assembling_machine(6, util.color("#ff0000"))
---
---local assembling_machine = data.raw["assembling-machine"]["assembling-machine-3"]
---graphics_pack:apply_to_entity(assembling_machine)
---
----- Also apply the corresponding remnants sprites to the corpse.
---local corpse = data.raw["corpse"][assembling_machine.corpse]
---if corpse then
---	 graphics_pack:apply_to_corpse(corpse)
---end
---```
---
---### Exceptions
---*@throws* `string` — Thrown when `sprite_set` is not an integer between 1 and 6, inclusive.
function _packs.assembling_machine(sprite_set, color)
	assert(
		type(sprite_set) == "number" and sprite_set % 1 == 0 and sprite_set >= 1 and sprite_set <= 6,
		"Invalid argument: 'sprite_set' must be an integer between 1 and 6, inclusive."
	)

	local options = {}
	local icon_data = _base_icon_fns.assembling_machine(color)
	return make_graphics_pack(sprite_set, color, icon_data, options)
end

---Gets the graphics pack for the electronics assembling machine as used in Bob's Mods for the specified `sprite_set`,
---optionally tinted using the provided `color`.
---
---### Parameters
---@param sprite_set ElectronicsAssemblyMachineTiers # The set of electronics assembling machine sprites to use, from 1 to 3.
---@param color data.Color? # The color of the electronics assembly machine. When `nil`, the resulting graphics will be uncolored.
---@return CraftingMachineGraphicsPack graphics_pack
---
---### Exceptions
---*@throws* `string` — Thrown when `sprite_set` is not an integer between 1 and 3, inclusive.
function _packs.electronics_assembling_machine(sprite_set, color)
	assert(
		type(sprite_set) == "number" and sprite_set % 1 == 0 and sprite_set >= 1 and sprite_set <= 3,
		"Invalid argument: 'sprite_set' must be an integer between 1 and 3, inclusive."
	)

	-- Remap from tier 1-3 to the tier 2/4/6 sprite sets.
	local remapped_tier = sprite_set * 2

	local options = { use_electronics_set = true }
	local icon_data = {}
	error("electronics_assembling_machine is not yet implemented.")
	return make_graphics_pack(remapped_tier, color, icon_data, options)
end

---Gets the graphics pack for the burner assembling machine as used in Bob's Mods for the specified `sprite_set`,
---optionally tinted using the provided `color`.
---
---The graphics pack is not pre-scaled. Use [Reskins.Sprites.rescale_prototype](lua://Reskins.Sprites.rescale_prototype)
---to adjust the scale of the images after applying them to an entity.
---
---### Parameters
---@param color data.Color? # The color of the assembly machine. When `nil`, the resulting graphics will be uncolored.
---@return CraftingMachineGraphicsPack graphics_pack
function _packs.burner_assembling_machine(color)
	local options = { use_burner_set = true }
	local icon_data = _base_icon_fns.assembling_machine(color)
	return make_graphics_pack(1, color, icon_data, options)
end

---Gets the graphics pack for the electronics assembling machine as used in Bob's Mods for the specified `sprite_set`,
---optionally tinted using the provided `color`.
---
---### Parameters
---@param color data.Color? # The color of the assembly machine. When `nil`, the resulting graphics will be uncolored.
---@return CraftingMachineGraphicsPack graphics_pack
function _packs.steam_assembling_machine(color)
	local options = { use_steam_set = true }
	local icon_data = _base_icon_fns.assembling_machine(color)
	return make_graphics_pack(1, color, icon_data, options)
end

return _packs
