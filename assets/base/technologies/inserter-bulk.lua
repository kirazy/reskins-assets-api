---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Base.Technologies

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local technologies = IconBuilderFactory:create({
	folder = _defines.assets_source.base_assets .. "/graphics/technology",
	defaults_type = "technology",
})

---Provides methods for getting the technology icon of bulk inserters, `inserter-bulk/inserter-bulk-{role}.png`.
---
---#### Examples
---```lua
---local InserterBulk = require("__reskins-assets-api__.assets.base.technologies.inserter-bulk")
---```
---@class InserterBulk
local M = {}

local icon_builder = technologies:tinted("inserter-bulk")

---Gets the technology icon for bulk inserters, in the tints given by `params`.
M.get_icon = icon_builder:build("get_icon")

---Gets the technology icon for bulk inserters as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icon_builder:build_composition("get_icon_composition")

return M
