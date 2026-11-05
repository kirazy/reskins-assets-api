---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Assorted.Items

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local icons = IconBuilderFactory:create({ folder = _defines.assets_source.assorted_assets .. "/graphics/icons" })

---Provides methods for getting the icon of the miniature electric mixing furnace,
---`mini-furnace-electric-mixing/mini-furnace-electric-mixing-{role}.png`.
---
---#### Examples
---```lua
---local MiniFurnaceElectricMixing =
---    require("__reskins-assets-api__.assets.assorted.items.mini-furnace-electric-mixing")
---```
---@class MiniFurnaceElectricMixing
local M = {}

---Gets the icon for the miniature electric mixing furnace as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icons:tinted("mini-furnace-electric-mixing"):build_composition("get_icon_composition")

return M
