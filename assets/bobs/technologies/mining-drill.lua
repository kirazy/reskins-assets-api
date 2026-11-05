---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Technologies

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")
local V = require("__reskins-sprite-utils__.validation")

local technologies = IconBuilderFactory:create({
	folder = _defines.assets_source.bobs_assets .. "/graphics/technology",
	defaults_type = "technology",
	icon_size = 128,
})

---Provides methods for getting the technology icon of the mining drill,
---`mining-drill/mining-drill[-{variant}]-{role}.png`.
---
---#### Examples
---```lua
---local MiningDrill = require("__reskins-assets-api__.assets.bobs.technologies.mining-drill")
---```
---@class MiningDrill
local M = {}

local icon_builder = technologies
	:tinted("mining-drill")
	:keyed("variant", V.one_of({ "standard", "area" }), { IconBuilderFactory.role.base })

---Gets the technology icon for the mining drill of the given `variant`, in the tints given by `params`.
M.get_icon = icon_builder:build("get_icon")

---Gets the technology icon for the mining drill of the given `variant` as an `IconComposition`, in the tints given by
---`params`.
M.get_icon_composition = icon_builder:build_composition("get_icon_composition")

return M
