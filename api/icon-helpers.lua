-- THIS MODULE IS EXTREMELY WIP AND SUBJECT TO CHANGE.
-- The type signatures are not stable.

local assets_api = {
	defines = require("api.defines"),
	pipes = require("assets.base.entities.pipe-pictures"),
}
local sprite_utils = {
	icons = require("__reskins-sprite-utils__.icons"),
}

---@class Internal.PipeCreatableIcon
---@field type "pipe"|"pipe-to-ground"

---@class Internal.SimpleCreatableIcon
---@field folder string
---@field icon_name string
---@field icon_size data.SpriteSizeType?

---@class Internal.LayeredCreatableIcon:Internal.SimpleCreatableIcon
---@field icon_base string?
---@field icon_mask string?
---@field icon_highlights string?
---@field extras data.IconData[]?

---@class Internal.IconHelpers
local _helpers = {}

---Returns a function that when called with optional `tint`, `shift`, and `scale` parameters, will return a colored
---three-layer icon created using the provided `creatable_icon`.
---@param creatable_icon Internal.LayeredCreatableIcon Parameters that define the location of the sprites that comprise the icon.
---@return TintedIconCreator creator_fn
function _helpers.make_tinted_three_layer_icon_creator_fn(creatable_icon)
	assert(creatable_icon.folder, "creatable_icon.folder is required")
	assert(creatable_icon.icon_name, "creatable_icon.icon_name is required")

	---@type TintedIconCreator
	local creator_fn = function(tint, shift, scale)
		local folder = creatable_icon.folder .. "/" .. creatable_icon.icon_name
		---@type data.IconData[]
		local icon_data = {
			{
				icon = folder .. "/" .. (creatable_icon.icon_base or creatable_icon.icon_name) .. "-icon-base.png",
				shift = shift,
				scale = scale,
			},
			{
				icon = folder .. "/" .. (creatable_icon.icon_mask or creatable_icon.icon_name) .. "-icon-mask.png",
				tint = tint,
				shift = shift,
				scale = scale,
			},
			{
				icon = folder .. "/" .. (creatable_icon.icon_highlights or creatable_icon.icon_name) .. "-icon-highlights.png",
				tint = { 1, 1, 1, 0 },
				shift = shift,
				scale = scale,
			},
		}

		if creatable_icon.extras then
			for _, extra in pairs(creatable_icon.extras) do
				local icon_datum = sprite_utils.icons.transform_icon(extra, scale, shift, tint, "default")
				table.insert(icon_data, icon_datum)
			end
		end

		return sprite_utils.icons.add_missing_icons_defaults(icon_data, "default")
	end

	return creator_fn
end

---Returns a function that when called with optional `tint`, `shift`, and `scale` parameters, will return a colored
---circuit icon created using the provided `creatable_icon`.
---@param creatable_icon Internal.SimpleCreatableIcon Parameters that define the location of the sprites that comprise the icon.
---@return TintedIconCreator creator_fn
function _helpers.make_tinted_circuit_icon_creator_fn(creatable_icon)
	---@type TintedIconCreator
	local creator_fn = function(tint, shift, scale)
		local folder = creatable_icon.folder .. "/" .. creatable_icon.icon_name
		---@type data.IconData[]
		local icon_data = {
			{
				icon = folder .. "/" .. creatable_icon.icon_name .. "-icon-base.png",
				tint = tint,
				shift = shift,
				scale = scale,
			},
			{
				icon = folder .. "/" .. creatable_icon.icon_name .. "-icon-highlights.png",
				shift = shift,
				scale = scale,
			},
			{
				icon = folder .. "/" .. creatable_icon.icon_name .. "-traces.png",
				shift = shift,
				scale = scale,
			},
		}

		return sprite_utils.icons.add_missing_icons_defaults(icon_data, "default")
	end

	return creator_fn
end

---Returns a function that when called with optional `shift` and `scale` parameters, will return a
---flat icon using the provided `creatable_icon`.
---@param creatable_icon Internal.SimpleCreatableIcon Parameters that define the location of the sprites that comprise the icon.
---@return IconCreator
function _helpers.make_flat_icon_creator_fn(creatable_icon)
	---@type IconCreator
	local creator_fn = function(shift, scale)
		---@type data.IconData[]
		local icon_data = {
			{
				icon = creatable_icon.folder .. "/" .. creatable_icon.icon_name .. ".png",
				icon_size = creatable_icon.icon_size or defines.default_icon_size,
				shift = shift,
				scale = scale,
			},
		}

		return sprite_utils.icons.add_missing_icons_defaults(icon_data)
	end

	return creator_fn
end

---@param creatable_icon Internal.PipeCreatableIcon
---@return PipeIconCreator
function _helpers.make_pipe_icon_creator_fn(creatable_icon)
	---@type PipeIconCreator
	local creator_fn = function(pipe_material, shift, scale)
		-- The iron pipe icon comes from base.
		local is_iron = pipe_material == assets_api.defines.pipe_material.iron
		local material_asset = is_iron and assets_api.defines.assets.base
			or assets_api.pipes.asset_from_material(pipe_material)

		local material_name = assets_api.pipes.name_from_material(pipe_material)
		local assets_base_path = material_asset .. "/graphics/icons/"

		local icon_name = is_iron and creatable_icon.type
			or creatable_icon.type .. "/" .. material_name .. "-" .. creatable_icon.type .. "-icon"
		---@type data.IconData[]
		local icon_data = {
			{
				icon = assets_base_path .. icon_name .. ".png",
				icon_size = 64,
				shift = shift,
				scale = scale,
			},
		}

		return sprite_utils.icons.add_missing_icons_defaults(icon_data)
	end

	return creator_fn
end

return _helpers
