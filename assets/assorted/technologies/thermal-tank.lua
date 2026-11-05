---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Assorted.Technologies

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local technologies = IconBuilderFactory:create({
	folder = _defines.assets_source.assorted_assets .. "/graphics/technology",
	defaults_type = "technology",
	icon_size = 256,
})

---Provides methods for getting the technology icon of the thermal tank, `thermal-tank/thermal-tank-{role}.png`.
---
---#### Examples
---```lua
---local ThermalTank = require("__reskins-assets-api__.assets.assorted.technologies.thermal-tank")
---```
---@class ThermalTank
local M = {}

local icon_builder = technologies:tinted("thermal-tank")

---Gets the technology icon for the thermal tank, in the tints given by `params`.
M.get_icon = icon_builder:build("get_icon")

---Gets the technology icon for the thermal tank as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icon_builder:build_composition("get_icon_composition")

return M
