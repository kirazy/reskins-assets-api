---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Items

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local icons = IconBuilderFactory:create({ folder = _defines.assets_source.bobs_assets .. "/graphics/icons" })

---Provides methods for getting the icon of the construction robot tool, `robot-tool-construction/robot-tool-construction-{role}.png`.
---
---#### Examples
---```lua
---local RobotTool = require("__reskins-assets-api__.assets.bobs.items.robot-tool-construction")
---```
---@class RobotToolConstruction
local M = {}

---Gets the icon for the construction robot tool as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icons:tinted("robot-tool-construction"):build_composition("get_icon_composition")

return M
