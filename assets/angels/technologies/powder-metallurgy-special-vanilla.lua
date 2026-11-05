---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Angels.Technologies

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local technologies = IconBuilderFactory:create({
	folder = _defines.assets_source.angels_assets .. "/graphics/technology",
	defaults_type = "technology",
})

---Provides methods for getting the technology icon of powder metallurgy in the special vanilla mode of Angel's mods,
---`powder-metallurgy-special-vanilla/powder-metallurgy-special-vanilla-{role}.png`.
---
---#### Examples
---```lua
---local PowderMetallurgySpecialVanilla =
---    require("__reskins-assets-api__.assets.angels.technologies.powder-metallurgy-special-vanilla")
---```
---@class PowderMetallurgySpecialVanilla
local M = {}

local icon_builder = technologies:tinted("powder-metallurgy-special-vanilla")

---Gets the technology icon for powder metallurgy in the special vanilla mode of Angel's mods, in the tints given by
---`params`.
M.get_icon = icon_builder:build("get_icon")

---Gets the technology icon for powder metallurgy in the special vanilla mode of Angel's mods as an `IconComposition`,
---in the tints given by `params`.
M.get_icon_composition = icon_builder:build_composition("get_icon_composition")

return M
