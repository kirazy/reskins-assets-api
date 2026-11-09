---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Items

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local icons = IconBuilderFactory:create({ folder = _defines.assets_source.bobs_assets .. "/graphics/icons" })

---Provides methods for getting the icon of the logistics robot tool, `robot-tool-logistics/robot-tool-logistics-{role}.png`.
---
---#### Examples
---```lua
---local RobotTool = require("__reskins-assets-api__.assets.bobs.items.robot-tool-logistics")
---```
---@class RobotToolLogistics
local M = {}

---Gets the icon for the logistics robot tool as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icons:tinted("robot-tool-logistics"):build_composition("get_icon_composition")

return M
