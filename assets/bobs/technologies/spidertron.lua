---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Technologies

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local technologies = IconBuilderFactory:create({
	folder = _defines.assets_source.bobs_assets .. "/graphics/technology/spidertron",
	defaults_type = "technology",
})

---Provides methods for getting the technology icons in the `spidertron` folder, such as
---`spidertron/heavy-spidertron.png`.
---
---#### Examples
---```lua
---local Spidertron = require("__reskins-assets-api__.assets.bobs.technologies.spidertron")
---```
---@class Spidertron
local M = {}

local heavy_spidertron = technologies:flat("heavy-spidertron")

---Gets the technology icon for the heavy spidertron.
M.get_heavy_spidertron_icon = heavy_spidertron:build("get_heavy_spidertron_icon")

---Gets the technology icon for the heavy spidertron as an `IconComposition`.
M.get_heavy_spidertron_icon_composition = heavy_spidertron:build_composition("get_heavy_spidertron_icon_composition")

local logistic_spidertron = technologies:flat("logistic-spidertron")

---Gets the technology icon for the logistic spidertron.
M.get_logistic_spidertron_icon = logistic_spidertron:build("get_logistic_spidertron_icon")

---Gets the technology icon for the logistic spidertron as an `IconComposition`.
M.get_logistic_spidertron_icon_composition =
	logistic_spidertron:build_composition("get_logistic_spidertron_icon_composition")

local tankotron = technologies:flat("tankotron")

---Gets the technology icon for the tankotron.
M.get_tankotron_icon = tankotron:build("get_tankotron_icon")

---Gets the technology icon for the tankotron as an `IconComposition`.
M.get_tankotron_icon_composition = tankotron:build_composition("get_tankotron_icon_composition")

local walking_vehicle = technologies:flat("walking-vehicle")

---Gets the technology icon for the walking vehicle.
M.get_walking_vehicle_icon = walking_vehicle:build("get_walking_vehicle_icon")

---Gets the technology icon for the walking vehicle as an `IconComposition`.
M.get_walking_vehicle_icon_composition = walking_vehicle:build_composition("get_walking_vehicle_icon_composition")

return M
