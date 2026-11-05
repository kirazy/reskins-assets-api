---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Base.Technologies

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local technologies = IconBuilderFactory:create({
	folder = _defines.assets_source.base_assets .. "/graphics/technology",
	defaults_type = "technology",
})

---Provides methods for getting the technology icon of logistics, `logistics/logistics-{role}.png`.
---
---#### Examples
---```lua
---local Logistics = require("__reskins-assets-api__.assets.base.technologies.logistics")
---```
---@class Logistics
local M = {}

local icon_builder = technologies:tinted("logistics")

---Gets the technology icon for logistics, in the tints given by `params`.
M.get_icon = icon_builder:build("get_icon")

---Gets the technology icon for logistics as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icon_builder:build_composition("get_icon_composition")

return M
