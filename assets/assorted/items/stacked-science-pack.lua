---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Assorted.Items

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local icons = IconBuilderFactory:create({ folder = _defines.assets_source.assorted_assets .. "/graphics/icons" })

---Provides methods for getting the icon for a stack of science packs,
---`stacked-science-pack/stacked-science-pack-{role}.png`.
---
---#### Examples
---```lua
---local StackedSciencePack = require("__reskins-assets-api__.assets.assorted.items.stacked-science-pack")
---```
---@class StackedSciencePack
local M = {}

---Gets the icon for a stack of science packs as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icons:tinted("stacked-science-pack"):build_composition("get_icon_composition")

return M
