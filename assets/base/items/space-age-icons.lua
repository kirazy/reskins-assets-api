---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Base.Items

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local icons = IconBuilderFactory:create({ folder = _defines.assets_source.space_age .. "/graphics/icons" })

---Provides methods for getting the icons of the Space Age items at the root of the Space Age icons folder,
---`__space-age__/graphics/icons/{name}.png`.
---
---#### Examples
---```lua
---local SpaceAgeIcons = require("__reskins-assets-api__.assets.base.items.space-age-icons")
---```
---@class SpaceAgeIcons
local M = {}

---Gets the icon for carbon as an `IconComposition`.
M.get_carbon_icon_composition = icons:flat("carbon"):build_composition("get_carbon_icon_composition")

---Gets the icon for the lithium plate as an `IconComposition`.
M.get_lithium_plate_icon_composition =
	icons:flat("lithium-plate"):build_composition("get_lithium_plate_icon_composition")

---Gets the icon for tungsten carbide as an `IconComposition`.
M.get_tungsten_carbide_icon_composition =
	icons:flat("tungsten-carbide"):build_composition("get_tungsten_carbide_icon_composition")

---Gets the icon for tungsten ore as an `IconComposition`, with 4 picture variations.
---
---The icon is the first picture.
---
---#### Examples
---```lua
----- Get the icon for the tungsten ore, with its pictures.
---local icon_data, pictures = SpaceAgeIcons.get_tungsten_ore_icon_composition():build()
----- The icon is tungsten-ore.png, and the pictures are that file and tungsten-ore-{i}.png for i between 1 and 3.
---```
M.get_tungsten_ore_icon_composition =
	icons:flat("tungsten-ore"):variations(4):build_composition("get_tungsten_ore_icon_composition")

---Gets the icon for the tungsten plate as an `IconComposition`.
M.get_tungsten_plate_icon_composition =
	icons:flat("tungsten-plate"):build_composition("get_tungsten_plate_icon_composition")

return M
