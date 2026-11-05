---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Items

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local icons =
	IconBuilderFactory:create({ folder = _defines.assets_source.bobs_assets .. "/graphics/icons/modules/5-lights" })

---Provides methods for getting the icons of the modules folder, such as `modules/5-lights/god-module.png`.
---
---#### Examples
---```lua
---local Modules = require("__reskins-assets-api__.assets.bobs.items.modules")
---```
---@class Modules
local M = {}

---Gets the icon for the god module as an `IconComposition`.
M.get_god_module_icon_composition = icons:flat("god-module"):build_composition("get_god_module_icon_composition")

---Gets the icon for the productivity god module as an `IconComposition`.
M.get_god_module_productivity_icon_composition =
	icons:flat("god-module-productivity"):build_composition("get_god_module_productivity_icon_composition")

---Gets the icon for the quality god module as an `IconComposition`.
M.get_god_module_quality_icon_composition =
	icons:flat("god-module-quality"):build_composition("get_god_module_quality_icon_composition")

return M
