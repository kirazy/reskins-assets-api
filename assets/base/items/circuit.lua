---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Base.Items

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local icons = IconBuilderFactory:create({ folder = _defines.assets_source.base_assets .. "/graphics/icons" })

---Provides methods for getting the icon of the electronic circuit, `circuit/circuit-{role}.png`.
---
---#### Examples
---```lua
---local Circuit = require("__reskins-assets-api__.assets.base.items.circuit")
---```
---@class Circuit
local M = {}

---Gets the icon for the electronic circuit as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition =
	icons:layers("circuit"):mask():highlights():layer("traces"):build_composition("get_icon_composition")

return M
