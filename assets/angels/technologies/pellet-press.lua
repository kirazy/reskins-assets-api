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

---Provides methods for getting the technology icon of the pellet press, `pellet-press/pellet-press-{role}.png`.
---
---#### Examples
---```lua
---local PelletPress = require("__reskins-assets-api__.assets.angels.technologies.pellet-press")
---```
---@class PelletPress
local M = {}

local icon_builder = technologies:tinted("pellet-press")

---Gets the technology icon for the pellet press, in the tints given by `params`.
M.get_icon = icon_builder:build("get_icon")

---Gets the technology icon for the pellet press as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icon_builder:build_composition("get_icon_composition")

return M
