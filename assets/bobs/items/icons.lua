---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Items

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local icons = IconBuilderFactory:create({ folder = _defines.assets_source.bobs_assets .. "/graphics/icons" })

---Provides methods for getting the icons at the root of the icon folder, such as `vehicle-engine.png`.
---
---#### Examples
---```lua
---local Icons = require("__reskins-assets-api__.assets.bobs.items.icons")
---```
---@class Icons
local M = {}

---Gets the icon for resin as an `IconComposition`.
M.get_resin_icon_composition = icons:flat("resin"):build_composition("get_resin_icon_composition")

---Gets the icon for the vehicle engine equipment as an `IconComposition`.
M.get_vehicle_engine_icon_composition =
	icons:flat("vehicle-engine"):build_composition("get_vehicle_engine_icon_composition")

---Gets the icon for the vehicle motor equipment as an `IconComposition`.
M.get_vehicle_motor_icon_composition =
	icons:flat("vehicle-motor"):build_composition("get_vehicle_motor_icon_composition")

return M
