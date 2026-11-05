---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Assorted.Items

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local icons = IconBuilderFactory:create({ folder = _defines.assets_source.assorted_assets .. "/graphics/icons" })

---Provides methods for getting the icon of the miniature electric furnace,
---`mini-furnace-electric/mini-furnace-electric-{role}.png`.
---
---#### Examples
---```lua
---local MiniFurnaceElectric = require("__reskins-assets-api__.assets.assorted.items.mini-furnace-electric")
---```
---@class MiniFurnaceElectric
local M = {}

---Gets the icon for the miniature electric furnace as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icons:tinted("mini-furnace-electric"):build_composition("get_icon_composition")

return M
