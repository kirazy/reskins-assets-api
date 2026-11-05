---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Technologies

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local technologies = IconBuilderFactory:create({
	folder = _defines.assets_source.bobs_assets .. "/graphics/technology",
	defaults_type = "technology",
})

---Provides methods for getting the technology icon of the storage tank, `storage-tank/storage-tank-{role}.png`.
---
---#### Examples
---```lua
---local StorageTank = require("__reskins-assets-api__.assets.bobs.technologies.storage-tank")
---```
---@class StorageTank
local M = {}

local icon_builder = technologies:tinted("storage-tank"):size(128)

---Gets the technology icon for the storage tank, in the tints given by `params`.
M.get_icon = icon_builder:build("get_icon")

---Gets the technology icon for the storage tank as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icon_builder:build_composition("get_icon_composition")

return M
