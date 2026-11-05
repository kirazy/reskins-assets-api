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

---Provides methods for getting the technology icons at the root of the technology folder, such as
---`electronics-original.png`.
---
---#### Examples
---```lua
---local Icons = require("__reskins-assets-api__.assets.base.technologies.icons")
---```
---@class Icons
local M = {}

local electronics_original = technologies:flat("electronics-original")

---Gets the original technology icon for electronics.
M.get_electronics_original_icon = electronics_original:build("get_electronics_original_icon")

---Gets the original technology icon for electronics as an `IconComposition`.
M.get_electronics_original_icon_composition =
	electronics_original:build_composition("get_electronics_original_icon_composition")

return M
