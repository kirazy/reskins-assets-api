---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Assorted.Items

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local icons = IconBuilderFactory:create({ folder = _defines.assets_source.assorted_assets .. "/graphics/icons" })

---Provides methods for getting the icon of the miniature Angel's chemical plant,
---`mini-angels-chemical-plant/mini-angels-chemical-plant-{role}.png`.
---
---#### Examples
---```lua
---local MiniAngelsChemicalPlant = require("__reskins-assets-api__.assets.assorted.items.mini-angels-chemical-plant")
---```
---@class MiniAngelsChemicalPlant
local M = {}

---Gets the icon for the miniature Angel's chemical plant as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icons:tinted("mini-angels-chemical-plant"):build_composition("get_icon_composition")

return M
