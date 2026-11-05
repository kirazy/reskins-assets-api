---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Items

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local icons = IconBuilderFactory:create({ folder = _defines.assets_source.bobs_assets .. "/graphics/icons/inserters" })

---Provides methods for getting the icons at the root of the inserters folder, such as `inserters/fast-inserter.png`.
---
---#### Examples
---```lua
---local Inserters = require("__reskins-assets-api__.assets.bobs.items.inserters")
---```
---@class Inserters
local M = {}

---Gets the icon for the bulk filter inserter as an `IconComposition`.
M.get_bulk_filter_inserter_icon_composition =
	icons:flat("bulk-filter-inserter"):build_composition("get_bulk_filter_inserter_icon_composition")

---Gets the icon for the bulk inserter as an `IconComposition`.
M.get_bulk_inserter_icon_composition =
	icons:flat("bulk-inserter"):build_composition("get_bulk_inserter_icon_composition")

---Gets the icon for the burner inserter as an `IconComposition`.
M.get_burner_inserter_icon_composition =
	icons:flat("burner-inserter"):build_composition("get_burner_inserter_icon_composition")

---Gets the icon for the express bulk filter inserter as an `IconComposition`.
M.get_express_bulk_filter_inserter_icon_composition =
	icons:flat("express-bulk-filter-inserter"):build_composition("get_express_bulk_filter_inserter_icon_composition")

---Gets the icon for the express bulk inserter as an `IconComposition`.
M.get_express_bulk_inserter_icon_composition =
	icons:flat("express-bulk-inserter"):build_composition("get_express_bulk_inserter_icon_composition")

---Gets the icon for the express filter inserter as an `IconComposition`.
M.get_express_filter_inserter_icon_composition =
	icons:flat("express-filter-inserter"):build_composition("get_express_filter_inserter_icon_composition")

---Gets the icon for the express inserter as an `IconComposition`.
M.get_express_inserter_icon_composition =
	icons:flat("express-inserter"):build_composition("get_express_inserter_icon_composition")

---Gets the icon for the fast inserter as an `IconComposition`.
M.get_fast_inserter_icon_composition =
	icons:flat("fast-inserter"):build_composition("get_fast_inserter_icon_composition")

---Gets the icon for the filter inserter as an `IconComposition`.
M.get_filter_inserter_icon_composition =
	icons:flat("filter-inserter"):build_composition("get_filter_inserter_icon_composition")

---Gets the icon for the inserter as an `IconComposition`.
M.get_inserter_icon_composition = icons:flat("inserter"):build_composition("get_inserter_icon_composition")

---Gets the icon for the long-handed inserter as an `IconComposition`.
M.get_long_handed_inserter_icon_composition =
	icons:flat("long-handed-inserter"):build_composition("get_long_handed_inserter_icon_composition")

return M
