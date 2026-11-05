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

---Provides methods for getting the technology icon of a science pack, `science-pack/science-pack-{role}.png`.
---
---#### Examples
---```lua
---local SciencePack = require("__reskins-assets-api__.assets.base.technologies.science-pack")
---```
---@class SciencePack
local M = {}

local icon_builder = technologies:tinted("science-pack")

---Gets the technology icon for a science pack, in the tints given by `params`.
M.get_icon = icon_builder:build("get_icon")

---Gets the technology icon for a science pack as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icon_builder:build_composition("get_icon_composition")

return M
