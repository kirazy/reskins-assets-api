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

---Provides methods for getting the technology icon of the electric chemical mixing furnace,
---`furnace-electric-chemical-mixing/furnace-electric-chemical-mixing-{role}.png`.
---
---#### Examples
---```lua
---local FurnaceElectricChemicalMixing =
---    require("__reskins-assets-api__.assets.bobs.technologies.furnace-electric-chemical-mixing")
---```
---@class FurnaceElectricChemicalMixing
local M = {}

-- The game renders a layer with a tint alpha of zero additively.
local icon_builder = technologies:tinted("furnace-electric-chemical-mixing"):layer("lights", { tint = { 1, 1, 1, 0 } })

---Gets the technology icon for the electric chemical mixing furnace, in the tints given by `params`.
M.get_icon = icon_builder:build("get_icon")

---Gets the technology icon for the electric chemical mixing furnace as an `IconComposition`, in the tints given by
---`params`.
M.get_icon_composition = icon_builder:build_composition("get_icon_composition")

return M
