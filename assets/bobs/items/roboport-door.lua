---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Items

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")
local V = require("__reskins-sprite-utils__.validation")

local icons =
	IconBuilderFactory:create({ folder = _defines.assets_source.bobs_assets .. "/graphics/icons/roboport-door" })

---Provides methods for getting the icons of the roboport hatch door, `roboport-door/roboport-door-{tier}.png`.
---
---#### Examples
---```lua
---local RoboportDoor = require("__reskins-assets-api__.assets.bobs.items.roboport-door")
---```
---@class RoboportDoor
local M = {}

---Gets the icon for the roboport hatch door of the given `tier` as an `IconComposition`.
M.get_icon_composition =
	icons:flat("roboport-door"):keyed("tier", V.one_of({ 1, 2, 3, 4 })):build_composition("get_icon_composition")

return M
