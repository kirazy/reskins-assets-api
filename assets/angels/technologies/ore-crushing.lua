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

---Provides methods for getting the technology icon of ore crushing, `ore-crushing/ore-crushing-{role}.png`.
---
---#### Examples
---```lua
---local OreCrushing = require("__reskins-assets-api__.assets.angels.technologies.ore-crushing")
---```
---@class OreCrushing
local M = {}

local icon_builder = technologies:tinted("ore-crushing")

---Gets the technology icon for ore crushing, in the tints given by `params`.
M.get_icon = icon_builder:build("get_icon")

---Gets the technology icon for ore crushing as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icon_builder:build_composition("get_icon_composition")

return M
