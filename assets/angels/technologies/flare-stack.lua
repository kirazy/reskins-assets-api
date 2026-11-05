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

---Provides methods for getting the technology icon of the flare stack, `flare-stack/flare-stack-base.png`.
---
---#### Examples
---```lua
---local FlareStack = require("__reskins-assets-api__.assets.angels.technologies.flare-stack")
---```
---@class FlareStack
local M = {}

local icon_builder = technologies:layers("flare-stack"):base()

---Gets the technology icon for the flare stack.
M.get_icon = icon_builder:build("get_icon")

---Gets the technology icon for the flare stack as an `IconComposition`.
M.get_icon_composition = icon_builder:build_composition("get_icon_composition")

return M
