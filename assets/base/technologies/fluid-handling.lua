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

---Provides methods for getting the technology icon of fluid handling, `fluid-handling/fluid-handling-{role}.png`.
---
---#### Examples
---```lua
---local FluidHandling = require("__reskins-assets-api__.assets.base.technologies.fluid-handling")
---```
---@class FluidHandling
local M = {}

local icon_builder = technologies:tinted("fluid-handling")

---Gets the technology icon for fluid handling, in the tints given by `params`.
M.get_icon = icon_builder:build("get_icon")

---Gets the technology icon for fluid handling as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icon_builder:build_composition("get_icon_composition")

return M
