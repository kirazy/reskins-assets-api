---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Assorted.Items

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")
local V = require("__reskins-sprite-utils__.validation")

local icons = IconBuilderFactory:create({ folder = _defines.assets_source.assorted_assets .. "/graphics/icons" })

---Provides methods for getting the icons of the miniature electrolysers,
---`mini-electrolyser/mini-electrolyser-{tier}-{role}.png`.
---
---#### Examples
---```lua
---local MiniElectrolyser = require("__reskins-assets-api__.assets.assorted.items.mini-electrolyser")
---```
---@class MiniElectrolyser
local M = {}

---Gets the icon for the miniature electrolyser of the given `tier` as an `IconComposition`, in the tints given by
---`params`.
M.get_icon_composition =
	icons:tinted("mini-electrolyser"):keyed("tier", V.one_of({ 1, 2, 3, 4, 5 })):build_composition("get_icon_composition")

return M
