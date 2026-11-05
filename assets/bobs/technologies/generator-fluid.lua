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

---Provides methods for getting the technology icon of the fluid generator,
---`generator-fluid/generator-fluid-{role}.png`.
---
---#### Examples
---```lua
---local GeneratorFluid = require("__reskins-assets-api__.assets.bobs.technologies.generator-fluid")
---```
---@class GeneratorFluid
local M = {}

local icon_builder = technologies:tinted("generator-fluid")

---Gets the technology icon for the fluid generator, in the tints given by `params`.
M.get_icon = icon_builder:build("get_icon")

---Gets the technology icon for the fluid generator as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icon_builder:build_composition("get_icon_composition")

return M
