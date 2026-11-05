---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Angels.Items

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local ISOTOPES = {
	"americium-241",
	"curium-245",
	"neptunium-240",
	"plutonium-240",
	"thorium-232",
	"uranium-234",
	"uranium-235",
}

local icons = IconBuilderFactory:create({ folder = _defines.assets_source.angels_assets .. "/graphics/icons/isotopes" })

---Provides methods for getting the icons of the isotopes folder of Angel's items, `isotopes/{isotope}.png`.
---
---#### Examples
---```lua
---local Isotopes = require("__reskins-assets-api__.assets.angels.items.isotopes")
---```
---@class Isotopes
local M = {}

---Gets the icon for the given `isotope` as an `IconComposition`, with pictures that draw the isotope a second time as a
---light.
---
---#### Examples
---```lua
----- Get the icon for curium-245.
---local icon_data, pictures = Isotopes.get_icon_composition({ isotope = "curium-245" }):build()
----- The icon is isotopes/curium-245.png, and its picture has the file, then a copy of it drawn as a light.
---```
M.get_icon_composition = IconBuilderFactory.dispatch_composition(
	"isotope",
	ISOTOPES,
	"get_icon_composition",
	function(isotope)
		return icons:flat(isotope):glow()
	end
)

return M
