---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Assorted.Technologies

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local technologies = IconBuilderFactory:create({
	folder = _defines.assets_source.assorted_assets .. "/graphics/technology",
	defaults_type = "technology",
})

---Provides methods for getting the technology icon of the 1 x 1 vanilla loader,
---`vanilla-loader-1x1/vanilla-loader-1x1-{role}.png`.
---
---#### Examples
---```lua
---local VanillaLoader1x1 = require("__reskins-assets-api__.assets.assorted.technologies.vanilla-loader-1x1")
---```
---@class VanillaLoader1x1
local M = {}

local icon_builder = technologies:tinted("vanilla-loader-1x1")

---Gets the technology icon for the 1 x 1 vanilla loader, in the tints given by `params`.
M.get_icon = icon_builder:build("get_icon")

---Gets the technology icon for the 1 x 1 vanilla loader as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icon_builder:build_composition("get_icon_composition")

return M
