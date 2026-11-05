---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Angels.Items

local _defines = require("api.defines")
local V = require("__reskins-sprite-utils__.validation")
local IconBuilderFactory = require("api.icon-builder-factory")

local icons = IconBuilderFactory:create({ folder = _defines.assets_source.angels_assets .. "/graphics/icons/numerals" })

---Provides methods for getting the icons of the numerals folder of Angel's items, `numerals/num-{number}.png`.
---
---#### Examples
---```lua
---local Numerals = require("__reskins-assets-api__.assets.angels.items.numerals")
---```
---@class Numerals
local M = {}

---Gets the icon for the Roman numeral of the given `number` as an `IconComposition`.
---
---The numeral is drawn in gray, and `IconComposition:set_tint` sets its color.
---
---#### Examples
---```lua
----- Get the icon for the numeral III.
---local icon_data = Numerals.get_icon_composition({ number = 3 }):build()
----- The icon is numerals/num-3.png.
---```
M.get_icon_composition = icons
	:flat("num")
	:keyed("number", V.one_of({ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }))
	:mipmaps(2)
	:build_composition("get_icon_composition")

return M
