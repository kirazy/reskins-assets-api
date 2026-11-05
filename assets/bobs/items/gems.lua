---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Items

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local icons = IconBuilderFactory:create({ folder = _defines.assets_source.bobs_assets .. "/graphics/icons/gems" })

---Provides methods for getting the icons of the gems folder, such as `gems/amethyst-5.png`.
---
---#### Examples
---```lua
---local Gems = require("__reskins-assets-api__.assets.bobs.items.gems")
---```
---@class Gems
local M = {}

---Gets the icon for the polished amethyst as an `IconComposition`.
M.get_amethyst_5_icon_composition = icons:flat("amethyst-5"):build_composition("get_amethyst_5_icon_composition")

---Gets the icon for the polished diamond as an `IconComposition`.
M.get_diamond_5_icon_composition = icons:flat("diamond-5"):build_composition("get_diamond_5_icon_composition")

---Gets the icon for the polished emerald as an `IconComposition`.
M.get_emerald_5_icon_composition = icons:flat("emerald-5"):build_composition("get_emerald_5_icon_composition")

---Gets the icon for the polished ruby as an `IconComposition`.
M.get_ruby_5_icon_composition = icons:flat("ruby-5"):build_composition("get_ruby_5_icon_composition")

---Gets the icon for the polished sapphire as an `IconComposition`.
M.get_sapphire_5_icon_composition = icons:flat("sapphire-5"):build_composition("get_sapphire_5_icon_composition")

---Gets the icon for the polished topaz as an `IconComposition`.
M.get_topaz_5_icon_composition = icons:flat("topaz-5"):build_composition("get_topaz_5_icon_composition")

return M
