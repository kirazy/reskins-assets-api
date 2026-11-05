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

---Provides methods for getting the technology icon of the sniper turret, `turret-sniper/turret-sniper-{role}.png`.
---
---#### Examples
---```lua
---local TurretSniper = require("__reskins-assets-api__.assets.bobs.technologies.turret-sniper")
---```
---@class TurretSniper
local M = {}

local icon_builder = technologies:tinted("turret-sniper")

---Gets the technology icon for the sniper turret, in the tints given by `params`.
M.get_icon = icon_builder:build("get_icon")

---Gets the technology icon for the sniper turret as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icon_builder:build_composition("get_icon_composition")

return M
