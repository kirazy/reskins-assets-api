---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Items

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local icons =
	IconBuilderFactory:create({ folder = _defines.assets_source.bobs_assets .. "/graphics/icons/alien-science-packs" })

---Provides methods for getting the icons of the alien-science-packs folder, such as
---`alien-science-packs/alien-science-pack.png`.
---
---#### Examples
---```lua
---local AlienSciencePacks = require("__reskins-assets-api__.assets.bobs.items.alien-science-packs")
---```
---@class AlienSciencePacks
local M = {}

---Gets the icon for the alien science pack as an `IconComposition`.
M.get_alien_science_pack_icon_composition =
	icons:flat("alien-science-pack"):build_composition("get_alien_science_pack_icon_composition")

---Gets the icon for the blue alien science pack as an `IconComposition`.
M.get_alien_science_pack_blue_icon_composition =
	icons:flat("alien-science-pack-blue"):build_composition("get_alien_science_pack_blue_icon_composition")

---Gets the icon for the green alien science pack as an `IconComposition`.
M.get_alien_science_pack_green_icon_composition =
	icons:flat("alien-science-pack-green"):build_composition("get_alien_science_pack_green_icon_composition")

---Gets the icon for the orange alien science pack as an `IconComposition`.
M.get_alien_science_pack_orange_icon_composition =
	icons:flat("alien-science-pack-orange"):build_composition("get_alien_science_pack_orange_icon_composition")

---Gets the icon for the purple alien science pack as an `IconComposition`.
M.get_alien_science_pack_purple_icon_composition =
	icons:flat("alien-science-pack-purple"):build_composition("get_alien_science_pack_purple_icon_composition")

---Gets the icon for the red alien science pack as an `IconComposition`.
M.get_alien_science_pack_red_icon_composition =
	icons:flat("alien-science-pack-red"):build_composition("get_alien_science_pack_red_icon_composition")

---Gets the icon for the yellow alien science pack as an `IconComposition`.
M.get_alien_science_pack_yellow_icon_composition =
	icons:flat("alien-science-pack-yellow"):build_composition("get_alien_science_pack_yellow_icon_composition")

return M
