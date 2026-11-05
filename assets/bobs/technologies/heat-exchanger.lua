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

---Provides methods for getting the technology icon of the heat exchanger,
---`heat-exchanger/heat-exchanger[-{pipe_material}]-{role}.png`.
---
---#### Examples
---```lua
---local HeatExchanger = require("__reskins-assets-api__.assets.bobs.technologies.heat-exchanger")
---```
---@class HeatExchanger
local M = {}

local icon_builder = technologies:tinted("heat-exchanger"):keyed(
	"pipe_material",
	V.one_of({ "base", "aluminum-invar", "silver-aluminum", "silver-titanium", "gold-copper" }),
	{ IconBuilderFactory.role.base }
)

---Gets the technology icon for the heat exchanger with the heat pipes of the given `pipe_material`, in the tints given
---by `params`.
M.get_icon = icon_builder:build("get_icon")

---Gets the technology icon for the heat exchanger with the heat pipes of the given `pipe_material` as an
---`IconComposition`, in the tints given by `params`.
M.get_icon_composition = icon_builder:build_composition("get_icon_composition")

return M
