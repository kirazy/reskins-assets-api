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

---Provides methods for getting the technology icon of nuclear power, `nuclear-power/nuclear-power-{role}.png`.
---
---#### Examples
---```lua
---local NuclearPower = require("__reskins-assets-api__.assets.base.technologies.nuclear-power")
---```
---@class NuclearPower
local M = {}

local icon_builder = technologies:tinted("nuclear-power")

---Gets the technology icon for nuclear power, in the tints given by `params`.
M.get_icon = icon_builder:build("get_icon")

---Gets the technology icon for nuclear power as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icon_builder:build_composition("get_icon_composition")

return M
