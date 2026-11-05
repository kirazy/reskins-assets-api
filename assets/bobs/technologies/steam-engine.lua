---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Technologies

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local technologies = IconBuilderFactory:create({
	folder = _defines.assets_source.bobs_assets .. "/graphics/technology",
	defaults_type = "technology",
	icon_size = 128,
})

---Provides methods for getting the technology icon of the steam engine, `steam-engine/steam-engine-{role}.png`.
---
---#### Examples
---```lua
---local SteamEngine = require("__reskins-assets-api__.assets.bobs.technologies.steam-engine")
---```
---@class SteamEngine
local M = {}

local icon_builder = technologies:tinted("steam-engine")

---Gets the technology icon for the steam engine, in the tints given by `params`.
M.get_icon = icon_builder:build("get_icon")

---Gets the technology icon for the steam engine as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icon_builder:build_composition("get_icon_composition")

return M
