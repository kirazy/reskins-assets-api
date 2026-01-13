local icon_utils = require("__reskins-sprite-utils__.icons")

local helpers = {}

---Returns a function that when called with optional `tint`, `shift` and `scale` parameters, will return a tinted
---three-layer icon created from the provided `creatable_icon`.
---@param creatable_icon LayeredCreatableIcon Parameters that define the location of the sprites that comprise the icon.
---@return TintedIconCreator
function helpers.make_tinted_three_layer_icon_creator_fn(creatable_icon)
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
				local icon_datum = icon_utils.transform_icon(extra, scale, shift, tint, "default")
				table.insert(icon_data, icon_datum)
			end
		end

		return icon_utils.add_missing_icons_defaults(icon_data, "default")
	end

	return creator_fn
end

---@param creatable_icon SimpleCreatableIcon
---@return TintedIconCreator
function helpers.make_tinted_circuit_icon_creator_fn(creatable_icon)
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

		return icon_utils.add_missing_icons_defaults(icon_data, "default")
	end

	return creator_fn
end

---@param creatable_icon SimpleCreatableIcon
---@return IconCreator
function helpers.make_flat_icon_creator_fn(creatable_icon)
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

		return icon_utils.add_missing_icons_defaults(icon_data)
	end

	return creator_fn
end

return helpers
