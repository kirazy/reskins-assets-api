---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Assorted.Items

local _defines = require("api.defines")
local V = require("__reskins-sprite-utils__.validation")
local IconBuilderFactory = require("api.icon-builder-factory")

local icons =
	IconBuilderFactory:create({ folder = _defines.assets_source.assorted_assets .. "/graphics/icons/processed-ores" })

---Provides methods for getting the icons of the processed-ores folder, `processed-ores/processed-{material}.png`.
---
---#### Examples
---```lua
---local ProcessedOres = require("__reskins-assets-api__.assets.assorted.items.processed-ores")
---```
---@class ProcessedOres
local M = {}

---Gets the icon for the processed ore of the given `material` as an `IconComposition`.
M.get_icon_composition = icons
	:flat("processed")
	:keyed("material", V.one_of({ "depleted-uranium", "magnesium", "osmium" }))
	:build_composition("get_icon_composition")

return M
