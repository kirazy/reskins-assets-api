---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Angels.Technologies

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local technologies = IconBuilderFactory:create({
	folder = _defines.assets_source.angels_assets .. "/graphics/technology",
	defaults_type = "technology",
	icon_size = 256,
})

---Provides methods for getting the technology icon of the gas tank, `gas-tank/gas-tank-{role}.png`.
---
---#### Examples
---```lua
---local GasTank = require("__reskins-assets-api__.assets.angels.technologies.gas-tank")
---```
---@class GasTank
local M = {}

local icon_builder = technologies:tinted("gas-tank")

---Gets the technology icon for the gas tank, in the tints given by `params`.
M.get_icon = icon_builder:build("get_icon")

---Gets the technology icon for the gas tank as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icon_builder:build_composition("get_icon_composition")

return M
