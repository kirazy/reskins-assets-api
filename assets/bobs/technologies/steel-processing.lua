---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Technologies

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local technologies = IconBuilderFactory:create({
	folder = _defines.assets_source.bobs_assets .. "/graphics/technology/steel-processing",
	defaults_type = "technology",
})

---Provides methods for getting the technology icons in the `steel-processing` folder, such as
---`steel-processing/steel-processing.png`.
---
---#### Examples
---```lua
---local SteelProcessing = require("__reskins-assets-api__.assets.bobs.technologies.steel-processing")
---```
---@class SteelProcessing
local M = {}

local steel_processing = technologies:flat("steel-processing")

---Gets the technology icon for steel processing.
M.get_steel_processing_icon = steel_processing:build("get_steel_processing_icon")

---Gets the technology icon for steel processing as an `IconComposition`.
M.get_steel_processing_icon_composition = steel_processing:build_composition("get_steel_processing_icon_composition")

local titanium_processing = technologies:flat("titanium-processing")

---Gets the technology icon for titanium processing.
M.get_titanium_processing_icon = titanium_processing:build("get_titanium_processing_icon")

---Gets the technology icon for titanium processing as an `IconComposition`.
M.get_titanium_processing_icon_composition =
	titanium_processing:build_composition("get_titanium_processing_icon_composition")

local tungsten_processing = technologies:flat("tungsten-processing")

---Gets the technology icon for tungsten processing.
M.get_tungsten_processing_icon = tungsten_processing:build("get_tungsten_processing_icon")

---Gets the technology icon for tungsten processing as an `IconComposition`.
M.get_tungsten_processing_icon_composition =
	tungsten_processing:build_composition("get_tungsten_processing_icon_composition")

return M
