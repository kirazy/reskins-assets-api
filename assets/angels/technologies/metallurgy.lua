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

---Provides methods for getting the technology icon of metallurgy, `metallurgy/metallurgy-{role}.png`.
---
---#### Examples
---```lua
---local Metallurgy = require("__reskins-assets-api__.assets.angels.technologies.metallurgy")
---```
---@class Metallurgy
local M = {}

local icon_builder = technologies:tinted("metallurgy")

---Gets the technology icon for metallurgy, in the tints given by `params`.
M.get_icon = icon_builder:build("get_icon")

---Gets the technology icon for metallurgy as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icon_builder:build_composition("get_icon_composition")

return M
