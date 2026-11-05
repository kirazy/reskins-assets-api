---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Assorted.Items

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local icons = IconBuilderFactory:create({ folder = _defines.assets_source.assorted_assets .. "/graphics/icons" })

---Provides methods for getting the icon of the miniature electric mining drill,
---`mini-mining-drill-electric/mini-mining-drill-electric-{role}.png`.
---
---#### Examples
---```lua
---local MiniMiningDrillElectric = require("__reskins-assets-api__.assets.assorted.items.mini-mining-drill-electric")
---```
---@class MiniMiningDrillElectric
local M = {}

---Gets the icon for the miniature electric mining drill as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icons:tinted("mini-mining-drill-electric"):build_composition("get_icon_composition")

return M
