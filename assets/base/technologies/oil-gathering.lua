---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Base.Technologies

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")
local V = require("__reskins-sprite-utils__.validation")

local technologies = IconBuilderFactory:create({
	folder = _defines.assets_source.base_assets .. "/graphics/technology",
	defaults_type = "technology",
})

---Provides methods for getting the technology icon of oil gathering,
---`oil-gathering/oil-gathering[-{variant}]-{role}.png`.
---
---#### Examples
---```lua
---local OilGathering = require("__reskins-assets-api__.assets.base.technologies.oil-gathering")
---```
---@class OilGathering
local M = {}

local icon_builder =
	technologies:tinted("oil-gathering"):keyed("variant", V.one_of({ "base", "water" }), { IconBuilderFactory.role.base })

---Gets the technology icon for oil gathering with the pumpjack of the given `variant`, in the tints given by `params`.
M.get_icon = icon_builder:build("get_icon")

---Gets the technology icon for oil gathering with the pumpjack of the given `variant` as an `IconComposition`, in the
---tints given by `params`.
M.get_icon_composition = icon_builder:build_composition("get_icon_composition")

return M
