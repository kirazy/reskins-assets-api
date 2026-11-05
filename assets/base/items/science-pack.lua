---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Base.Items

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local icons = IconBuilderFactory:create({ folder = _defines.assets_source.base_assets .. "/graphics/icons" })

---Provides methods for getting the icon of a science pack, `science-pack/science-pack-{role}.png`.
---
---#### Examples
---```lua
---local SciencePack = require("__reskins-assets-api__.assets.base.items.science-pack")
---```
---@class SciencePack
local M = {}

---Gets the icon for a science pack as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icons:tinted("science-pack"):build_composition("get_icon_composition")

return M
