---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Base.Items

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local icons = IconBuilderFactory:create({ folder = _defines.assets_source.base_assets .. "/graphics/icons" })

---Provides methods for getting the icon of the battery, `battery/battery-{role}.png`.
---
---#### Examples
---```lua
---local Battery = require("__reskins-assets-api__.assets.base.items.battery")
---```
---@class Battery
local M = {}

---Gets the icon for the battery as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icons:tinted("battery"):build_composition("get_icon_composition")

return M
