---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Technologies

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local technologies = IconBuilderFactory:create({
	folder = _defines.assets_source.bobs_assets .. "/graphics/technology",
	defaults_type = "technology",
})

---Provides methods for getting the technology icon of the electrolyser 4, `electrolyser-4/electrolyser-4-{role}.png`.
---
---#### Examples
---```lua
---local Electrolyser4 = require("__reskins-assets-api__.assets.bobs.technologies.electrolyser-4")
---```
---@class Electrolyser4
local M = {}

local icon_builder = technologies:tinted("electrolyser-4")

---Gets the technology icon for the electrolyser 4, in the tints given by `params`.
M.get_icon = icon_builder:build("get_icon")

---Gets the technology icon for the electrolyser 4 as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icon_builder:build_composition("get_icon_composition")

return M
