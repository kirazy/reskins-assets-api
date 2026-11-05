---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Base.Technologies

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local technologies = IconBuilderFactory:create({
	folder = _defines.assets_source.base_assets .. "/graphics/technology",
	defaults_type = "technology",
})

---Provides methods for getting the technology icon of inserters, `inserter/inserter-{role}.png`.
---
---#### Examples
---```lua
---local Inserter = require("__reskins-assets-api__.assets.base.technologies.inserter")
---```
---@class Inserter
local M = {}

local icon_builder = technologies:tinted("inserter")

---Gets the technology icon for inserters, in the tints given by `params`.
M.get_icon = icon_builder:build("get_icon")

---Gets the technology icon for inserters as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icon_builder:build_composition("get_icon_composition")

return M
