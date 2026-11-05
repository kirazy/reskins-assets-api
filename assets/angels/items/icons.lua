---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Angels.Items

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local icons = IconBuilderFactory:create({ folder = _defines.assets_source.angels_assets .. "/graphics/icons" })

---Provides the icons of the Angel's items at the root of the icon folder, such as `glass.png`.
---
---#### Examples
---```lua
---local Icons = require("__reskins-assets-api__.assets.angels.items.icons")
---```
---@class Icons
local M = {}

---Gets the icon for glass as an `IconComposition`.
M.get_glass_icon_composition = icons:flat("glass"):build_composition("get_glass_icon_composition")

---Gets the icon for the quartz crucible as an `IconComposition`.
M.get_quartz_crucible_icon_composition =
	icons:flat("quartz-crucible"):build_composition("get_quartz_crucible_icon_composition")

---Gets the icon for rubber as an `IconComposition`.
M.get_rubber_icon_composition = icons:flat("rubber"):build_composition("get_rubber_icon_composition")

---Gets the icon for the silicon wafer as an `IconComposition`.
M.get_silicon_wafer_icon_composition =
	icons:flat("silicon-wafer"):build_composition("get_silicon_wafer_icon_composition")

---Gets the icon for slag as an `IconComposition`.
M.get_slag_icon_composition = icons:flat("slag"):build_composition("get_slag_icon_composition")

---Gets the icon for solder as an `IconComposition`.
M.get_solder_icon_composition = icons:flat("solder"):build_composition("get_solder_icon_composition")

---Gets the icon for solid lime as an `IconComposition`.
M.get_solid_lime_icon_composition = icons:flat("solid-lime"):build_composition("get_solid_lime_icon_composition")

---Gets the icon for solid limestone as an `IconComposition`.
M.get_solid_limestone_icon_composition =
	icons:flat("solid-limestone"):build_composition("get_solid_limestone_icon_composition")

return M
