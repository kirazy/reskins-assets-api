---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Angels.Items

local _defines = require("api.defines")
local V = require("__reskins-sprite-utils__.validation")
local IconBuilderFactory = require("api.icon-builder-factory")

local icons =
	IconBuilderFactory:create({ folder = _defines.assets_source.angels_assets .. "/graphics/icons/liquid-material" })

---Provides methods for getting the icons of the liquid-material folder of Angel's items,
---`liquid-material/liquid-molten-{material}.png`.
---
---#### Examples
---```lua
---local LiquidMaterial = require("__reskins-assets-api__.assets.angels.items.liquid-material")
---```
---@class LiquidMaterial
local M = {}

---Gets the icon for the molten form of the given `material` as an `IconComposition`.
---
---#### Examples
---```lua
----- Get the icon for molten magnesium.
---local composition = LiquidMaterial.get_icon_composition({ material = "magnesium" })
----- The icon is liquid-material/liquid-molten-magnesium.png.
---```
M.get_icon_composition = icons
	:flat("liquid-molten")
	:keyed("material", V.one_of({ "depleted-uranium", "magnesium", "osmium" }))
	:build_composition("get_icon_composition")

return M
