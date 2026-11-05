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

---Provides methods for getting the technology icon of the artillery wagon,
---`artillery-wagons/artillery-wagons-{role}.png`.
---
---#### Examples
---```lua
---local ArtilleryWagons = require("__reskins-assets-api__.assets.bobs.technologies.artillery-wagons")
---```
---@class ArtilleryWagons
local M = {}

local icon_builder = technologies:tinted("artillery-wagons")

---Gets the technology icon for the artillery wagon, in the tints given by `params`.
M.get_icon = icon_builder:build("get_icon")

---Gets the technology icon for the artillery wagon as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icon_builder:build_composition("get_icon_composition")

return M
