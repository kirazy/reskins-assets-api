---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Angels.Items

local _defines = require("api.defines")
local V = require("__reskins-sprite-utils__.validation")
local IconBuilderFactory = require("api.icon-builder-factory")

local MATERIALS = {
	"aluminium",
	"chrome",
	"cobalt",
	"copper",
	"copper-tungsten",
	"depleted-uranium",
	"depleted-uranium-mixture",
	"gold",
	"iron",
	"lead",
	"magnesium",
	"manganese",
	"nickel",
	"osmium",
	"osmium-mixture",
	"platinum",
	"silicon",
	"silver",
	"steel",
	"tin",
	"titanium",
	"tungsten",
	"tungsten-carbide",
	"tungsten-mixture",
	"zinc",
}

local icons = IconBuilderFactory:create({ folder = _defines.assets_source.angels_assets .. "/graphics/icons" })

---Provides methods for getting the icons of the powders collection of Angel's items,
---`powders/{material}/powder-{material}.png`, with their picture variations.
---
---#### Examples
---```lua
---local Powders = require("__reskins-assets-api__.assets.angels.items.powders")
---```
---@class Powders
local M = {}

---Gets the icon for the powder of the given `material` as an `IconComposition`, with 7 picture variations.
---
---The icon is the first picture.
---
---#### Examples
---```lua
----- Get the icon for the iron powder, with its pictures.
---local icon_data, pictures = Powders.get_icon_composition({ material = "iron" }):build()
----- The icon is powders/iron/powder-iron.png, and the pictures are that file and
----- powder-iron-{i}.png for i between 1 and 6.
---```
M.get_icon_composition = icons
	:collection("powders", "material", V.one_of(MATERIALS))
	:stem("powder")
	:variations(7)
	:build_composition("get_icon_composition")

return M
