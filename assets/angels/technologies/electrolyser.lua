---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Angels.Technologies

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local technologies = IconBuilderFactory:create({
	folder = _defines.assets_source.angels_assets .. "/graphics/technology",
	defaults_type = "technology",
	icon_size = 224,
})

---Provides methods for getting the technology icon of the electrolyser, `electrolyser/electrolyser-{role}.png`.
---
---#### Examples
---```lua
---local Electrolyser = require("__reskins-assets-api__.assets.angels.technologies.electrolyser")
---```
---@class Electrolyser
local M = {}

local icon_builder = technologies:tinted("electrolyser")

---Gets the technology icon for the electrolyser, in the tints given by `params`.
M.get_icon = icon_builder:build("get_icon")

---Gets the technology icon for the electrolyser as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icon_builder:build_composition("get_icon_composition")

return M
