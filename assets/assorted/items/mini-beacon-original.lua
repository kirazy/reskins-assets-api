---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Assorted.Items

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local icons = IconBuilderFactory:create({ folder = _defines.assets_source.assorted_assets .. "/graphics/icons" })

---Provides methods for getting the icon of the miniature classic beacon,
---`mini-beacon-original/mini-beacon-original-{role}.png`.
---
---#### Examples
---```lua
---local MiniBeaconOriginal = require("__reskins-assets-api__.assets.assorted.items.mini-beacon-original")
---```
---@class MiniBeaconOriginal
local M = {}

---Gets the icon for the miniature classic beacon as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icons:tinted("mini-beacon-original"):build_composition("get_icon_composition")

return M
