---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Items

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local icons = IconBuilderFactory:create({ folder = _defines.assets_source.bobs_assets .. "/graphics/icons/circuits" })

---Provides methods for getting the icons of the circuits folder, such as `circuits/advanced-processing-unit.png`.
---
---#### Examples
---```lua
---local Circuits = require("__reskins-assets-api__.assets.bobs.items.circuits")
---```
---@class Circuits
local M = {}

---Gets the icon for the advanced processing unit as an `IconComposition`.
M.get_advanced_processing_unit_icon_composition =
	icons:flat("advanced-processing-unit"):build_composition("get_advanced_processing_unit_icon_composition")

return M
