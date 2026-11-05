---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Items

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local icons = IconBuilderFactory:create({ folder = _defines.assets_source.bobs_assets .. "/graphics/icons/isotopes" })

---Provides methods for getting the icons of the isotopes folder, such as `isotopes/plutonium-239.png`.
---
---#### Examples
---```lua
---local Isotopes = require("__reskins-assets-api__.assets.bobs.items.isotopes")
---```
---@class Isotopes
local M = {}

---Gets the icon for plutonium-239 as an `IconComposition`, with a picture that draws it a second time as a light.
M.get_plutonium_239_icon_composition =
	icons:flat("plutonium-239"):glow():build_composition("get_plutonium_239_icon_composition")

---Gets the icon for thorium-232 as an `IconComposition`.
M.get_thorium_232_icon_composition = icons:flat("thorium-232"):build_composition("get_thorium_232_icon_composition")

return M
