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

---Provides methods for getting the technology icon of ore refining, `ore-refining/ore-refining-{role}.png`.
---
---#### Examples
---```lua
---local OreRefining = require("__reskins-assets-api__.assets.angels.technologies.ore-refining")
---```
---@class OreRefining
local M = {}

local icon_builder = technologies:tinted("ore-refining")

---Gets the technology icon for ore refining, in the tints given by `params`.
M.get_icon = icon_builder:build("get_icon")

---Gets the technology icon for ore refining as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icon_builder:build_composition("get_icon_composition")

return M
