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

---Provides methods for getting the technology icon of the electric chemical furnace,
---`furnace-electric-chemical/furnace-electric-chemical-{role}.png`.
---
---#### Examples
---```lua
---local FurnaceElectricChemical = require("__reskins-assets-api__.assets.bobs.technologies.furnace-electric-chemical")
---```
---@class FurnaceElectricChemical
local M = {}

-- The game renders a layer with a tint alpha of zero additively.
local icon_builder = technologies:tinted("furnace-electric-chemical"):layer("lights", { tint = { 1, 1, 1, 0 } })

---Gets the technology icon for the electric chemical furnace, in the tints given by `params`.
M.get_icon = icon_builder:build("get_icon")

---Gets the technology icon for the electric chemical furnace as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icon_builder:build_composition("get_icon_composition")

return M
