---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Items

local _defines = require("api.defines")
local V = require("__reskins-sprite-utils__.validation")
local IconBuilderFactory = require("api.icon-builder-factory")

local icons = IconBuilderFactory:create({ folder = _defines.assets_source.bobs_assets .. "/graphics/icons/wires" })

---Provides methods for getting the icons of the wires folder, `wires/wire-{material}.png`.
---
---#### Examples
---```lua
---local Wires = require("__reskins-assets-api__.assets.bobs.items.wires")
---```
---@class Wires
local M = {}

---Gets the icon for the wire of the given `material` as an `IconComposition`.
---
---#### Examples
---```lua
----- Get the icon for the insulated wire.
---local composition = Wires.get_icon_composition({ material = "insulated" })
----- The icon is wires/wire-insulated.png.
---```
M.get_icon_composition = icons
	:flat("wire")
	:keyed("material", V.one_of({ "gilded-copper", "insulated", "tinned-copper" }))
	:build_composition("get_icon_composition")

return M
