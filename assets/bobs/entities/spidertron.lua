---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Entities

local IconBuilderFactory = require("api.icon-builder-factory")

local ICONS_FOLDER = "__reskins-assets-bobs__/graphics/icons"

local M = {}

local icons = IconBuilderFactory:create({ folder = ICONS_FOLDER })

local VARIANTS = { "antron", "tankotron", "logistic", "heavy" }

---Gets the builder for the icon of the spidertron for the given `variant`.
---@param variant string
---@return FlatIconBuilder<{}>
local function get_icon_builder(variant)
	local name = "spidertron-" .. variant

	return icons:flat(name):folder(ICONS_FOLDER .. "/" .. name)
end

---Gets the spidertron icon for the given `variant`.
M.get_icon = IconBuilderFactory.dispatch("variant", VARIANTS, "get_icon", get_icon_builder)

---Gets the spidertron icon for the given `variant` as an `IconComposition`.
M.get_icon_composition =
	IconBuilderFactory.dispatch_composition("variant", VARIANTS, "get_icon_composition", get_icon_builder)

---Gets the `icon_tintables` of a spidertron item for the given `variant`.
M.get_tintable_icon = IconBuilderFactory.dispatch("variant", VARIANTS, "get_tintable_icon", function(variant)
	local name = "spidertron-" .. variant

	return icons:layers(name):stem(name .. "-runtime"):base()
end)

---Gets the `icon_tintable_masks` of a spidertron item for the given `variant`.
M.get_tintable_mask_icon = IconBuilderFactory.dispatch("variant", VARIANTS, "get_tintable_mask_icon", function(variant)
	local name = "spidertron-" .. variant

	return icons:layers(name):stem(name .. "-runtime"):layer(IconBuilderFactory.role.mask)
end)

return M
