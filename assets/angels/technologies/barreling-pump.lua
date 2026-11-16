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

---Provides methods for getting the technology icon of the barreling pump, `barreling-pump/barreling-pump-{role}.png`.
---
---#### Examples
---```lua
---local BarrelingPump = require("__reskins-assets-api__.assets.angels.technologies.barreling-pump")
---```
---@class BarrelingPump
local M = {}

local icon_builder = technologies:tinted("barreling-pump")

---Gets the technology icon for the barreling pump, in the tints given by `params`.
M.get_icon = icon_builder:build("get_icon")

---Gets the technology icon for the barreling pump as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icon_builder:build_composition("get_icon_composition")

return M
