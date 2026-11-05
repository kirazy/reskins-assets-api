---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Items

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local icons = IconBuilderFactory:create({ folder = _defines.assets_source.bobs_assets .. "/graphics/icons" })

---Provides methods for getting the icon of the shotgun pellets, `shot/shot[-{i}].png`, with their picture variations.
---
---#### Examples
---```lua
---local Shot = require("__reskins-assets-api__.assets.bobs.items.shot")
---```
---@class Shot
local M = {}

---Gets the icon for the shotgun pellets as an `IconComposition`, with 5 picture variations.
---
---The icon is the first picture.
---
---#### Examples
---```lua
----- Get the icon for the shotgun pellets, with their pictures.
---local icon_data, pictures = Shot.get_icon_composition():build()
----- The icon is shot/shot.png, and the pictures are that file and shot-{i}.png for i between 1 and 4.
---```
M.get_icon_composition = icons
	:flat("shot")
	:folder(_defines.assets_source.bobs_assets .. "/graphics/icons/shot")
	:variations(5)
	:build_composition("get_icon_composition")

return M
