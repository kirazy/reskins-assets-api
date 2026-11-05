---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Angels.Technologies

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local technologies = IconBuilderFactory:create({
	folder = _defines.assets_source.angels_assets .. "/graphics/technology",
	defaults_type = "technology",
})

---Provides methods for getting the technology icon of ore flotation, `ore-flotation/ore-flotation-{role}.png`.
---
---#### Examples
---```lua
---local OreFlotation = require("__reskins-assets-api__.assets.angels.technologies.ore-flotation")
---```
---@class OreFlotation
local M = {}

local icon_builder = technologies:tinted("ore-flotation")

---Gets the technology icon for ore flotation, in the tints given by `params`.
M.get_icon = icon_builder:build("get_icon")

---Gets the technology icon for ore flotation as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icon_builder:build_composition("get_icon_composition")

return M
