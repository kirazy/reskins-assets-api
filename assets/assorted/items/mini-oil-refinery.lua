---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Assorted.Items

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local icons = IconBuilderFactory:create({ folder = _defines.assets_source.assorted_assets .. "/graphics/icons" })

---Provides methods for getting the icon of the miniature oil refinery,
---`mini-oil-refinery/mini-oil-refinery-{role}.png`.
---
---#### Examples
---```lua
---local MiniOilRefinery = require("__reskins-assets-api__.assets.assorted.items.mini-oil-refinery")
---```
---@class MiniOilRefinery
local M = {}

---Gets the icon for the miniature oil refinery as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icons:tinted("mini-oil-refinery"):build_composition("get_icon_composition")

return M
