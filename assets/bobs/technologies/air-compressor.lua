---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Technologies

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local technologies = IconBuilderFactory:create({
	folder = _defines.assets_source.bobs_assets .. "/graphics/technology",
	defaults_type = "technology",
	icon_size = 128,
})

---Provides methods for getting the technology icon of the air compressor, `air-compressor/air-compressor-{role}.png`.
---
---#### Examples
---```lua
---local AirCompressor = require("__reskins-assets-api__.assets.bobs.technologies.air-compressor")
---```
---@class AirCompressor
local M = {}

local icon_builder = technologies:tinted("air-compressor")

---Gets the technology icon for the air compressor, in the tints given by `params`.
M.get_icon = icon_builder:build("get_icon")

---Gets the technology icon for the air compressor as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icon_builder:build_composition("get_icon_composition")

return M
