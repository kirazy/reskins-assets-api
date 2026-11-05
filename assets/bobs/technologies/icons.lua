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

---Provides methods for getting the technology icons at the root of the technology folder, such as
---`vehicle-engine-equipment.png`.
---
---#### Examples
---```lua
---local Icons = require("__reskins-assets-api__.assets.bobs.technologies.icons")
---```
---@class Icons
local M = {}

local vehicle_belt_immunity_equipment = technologies:flat("vehicle-belt-immunity-equipment")

---Gets the technology icon for the vehicle belt immunity equipment.
M.get_vehicle_belt_immunity_equipment_icon =
	vehicle_belt_immunity_equipment:build("get_vehicle_belt_immunity_equipment_icon")

---Gets the technology icon for the vehicle belt immunity equipment as an `IconComposition`.
M.get_vehicle_belt_immunity_equipment_icon_composition =
	vehicle_belt_immunity_equipment:build_composition("get_vehicle_belt_immunity_equipment_icon_composition")

local vehicle_engine_equipment = technologies:flat("vehicle-engine-equipment")

---Gets the technology icon for the vehicle engine equipment.
M.get_vehicle_engine_equipment_icon = vehicle_engine_equipment:build("get_vehicle_engine_equipment_icon")

---Gets the technology icon for the vehicle engine equipment as an `IconComposition`.
M.get_vehicle_engine_equipment_icon_composition =
	vehicle_engine_equipment:build_composition("get_vehicle_engine_equipment_icon_composition")

local vehicle_motor_equipment = technologies:flat("vehicle-motor-equipment")

---Gets the technology icon for the vehicle motor equipment.
M.get_vehicle_motor_equipment_icon = vehicle_motor_equipment:build("get_vehicle_motor_equipment_icon")

---Gets the technology icon for the vehicle motor equipment as an `IconComposition`.
M.get_vehicle_motor_equipment_icon_composition =
	vehicle_motor_equipment:build_composition("get_vehicle_motor_equipment_icon_composition")

return M
