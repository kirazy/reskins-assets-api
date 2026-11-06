---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Assorted.Items

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local icons = IconBuilderFactory:create({ folder = _defines.assets_source.assorted_assets .. "/graphics/icons" })

---Provides methods for getting the icon of the miniature recycler, `mini-recycler.png`.
---
---#### Examples
---```lua
---local MiniRecycler = require("__reskins-assets-api__.assets.assorted.items.mini-recycler")
---```
---@class MiniRecycler
local M = {}

---Gets the icon for the miniature recycler as an `IconComposition`.
M.get_icon_composition = icons:flat("mini-recycler"):build_composition("get_icon_composition")

return M
