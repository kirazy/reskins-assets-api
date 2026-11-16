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

---Provides methods for getting the technology icon of barreling, `barreling/barreling-{role}.png`.
---
---#### Examples
---```lua
---local Barreling = require("__reskins-assets-api__.assets.angels.technologies.barreling")
---```
---@class Barreling
local M = {}

local icon_builder = technologies:tinted("barreling")

---Gets the technology icon for barreling, in the tints given by `params`.
M.get_icon = icon_builder:build("get_icon")

---Gets the technology icon for barreling as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icon_builder:build_composition("get_icon_composition")

return M
