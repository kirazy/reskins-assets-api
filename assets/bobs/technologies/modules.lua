---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Technologies

local _defines = require("api.defines")
local V = require("__reskins-sprite-utils__.validation")
local IconBuilderFactory = require("api.icon-builder-factory")

local technologies = IconBuilderFactory:create({
	folder = _defines.assets_source.bobs_assets .. "/graphics/technology/modules",
	defaults_type = "technology",
})

---Provides methods for getting the technology icons in the `modules` folder, `modules/god-module-{tier}.png`.
---
---#### Examples
---```lua
---local Modules = require("__reskins-assets-api__.assets.bobs.technologies.modules")
---```
---@class Modules
local M = {}

local god_module = technologies:flat("god-module"):keyed("tier", V.one_of({ 1, 2, 3 }))

---Gets the technology icon for the god module, with the lights of the given `tier` lit.
M.get_god_module_icon = god_module:build("get_god_module_icon")

---Gets the technology icon for the god module, with the lights of the given `tier` lit, as an `IconComposition`.
M.get_god_module_icon_composition = god_module:build_composition("get_god_module_icon_composition")

return M
