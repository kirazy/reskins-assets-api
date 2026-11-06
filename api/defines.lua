---@namespace Reskins.Assets

---Provides enumerations specific to Artisanal Reskins.
---
---#### Examples
---```lua
---local _defines = require("__reskins-assets-api__.api.defines")
---```
---@class Defines
local _defines = {}

local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")

---Represents the different types of animated transport belt sprite sheets.
---@enum BeltSprites
_defines.belt_sprites = {
	---The standard belt sprites.
	---
	---Used for slower belt speeds, typically less than 30 items/s.
	standard = 1,

	---The fast belt sprites.
	---
	---Used for faster belt speeds, typically between 30 items/s and 60 items/s.
	---Has twice as many frames as `defines.belt_sprites.standard` and larger spacing between arrows.
	fast = 2,

	---The turbo belt sprites.
	---
	---Used for faster belt speeds, typically more than 60 items/s.
	---Has twice as many frames as `defines.belt_sprites.fast` and larger spacing between arrows. Used for fastest belt speeds.
	turbo = 3,
}

local check_get_belt_sprites = V.signature("get_belt_sprites", {
	{ "speed", Common.positive_number },
})

---Gets the belt sprites for the given transport belt `speed`.
---
---A speed below 30 items/s gets `belt_sprites.standard`, a speed below 60 items/s gets `belt_sprites.fast`, and any
---other speed gets `belt_sprites.turbo`.
---@param speed double The speed of the transport belt, in tiles per tick.
---@return BeltSprites # The belt sprites.
---
---#### Examples
---```lua
----- Get the belt sprites for the speed of a transport belt.
---local belt_sprites = _defines.get_belt_sprites(data.raw["transport-belt"]["fast-transport-belt"].speed)
----- `belt_sprites` is `_defines.belt_sprites.fast`.
---```
---@throws When `speed` is not a number greater than 0.
---@nodiscard
function _defines.get_belt_sprites(speed)
	check_get_belt_sprites(speed)

	-- A transport belt moves 480 items per second on its two lanes at a speed of 1 tile per tick.
	local items_per_second = speed * 480
	if items_per_second < 30 then
		return _defines.belt_sprites.standard
	elseif items_per_second < 60 then
		return _defines.belt_sprites.fast
	end

	return _defines.belt_sprites.turbo
end

---Represents the different asset mods used to build the various graphics packs.
---@enum AssetsSource
_defines.assets_source = {
	---Factorio.
	base = "__base__",
	---Factorio: Space Age.
	space_age = "__space-age__",
	---Artisanal Reskins: Vanilla Assets.
	base_assets = "__reskins-assets-base__",
	---Artisanal Reskins: Bob's Assets.
	bobs_assets = "__reskins-assets-bobs__",
	---Artisanal Reskins: Angel's Assets.
	angels_assets = "__reskins-assets-angels__",
	---Artisanal Reskins: Assorted Assets.
	assorted_assets = "__reskins-assets-assorted__",
	---Artisanal Reskins: Space Age Assets.
	space_age_assets = "__reskins-assets-space-age__",
	---Artisanal Reskins: Hurricane Assets.
	hurricane_assets = "__reskins-assets-hurricane__",
	---Angel's Refining Graphics.
	refining_graphics = "__angelsrefininggraphics__",
	---Angel's Smelting Graphics.
	smelting_graphics = "__angelssmeltinggraphics__",
	---Angel's Petrochemical Processing Graphics.
	petrochem_graphics = "__angelspetrochemgraphics__",
	---Angel's Bioprocessing Graphics.
	bioprocessing_graphics = "__angelsbioprocessinggraphics__",
	---Angel's Addons - Mass Transit - Crawler Graphics.
	mobility_crawler_graphics = "__angelsaddons-mobility-graphics-crawler__",
	---Angel's Addons - Mass Transit - Petrochemical Graphics.
	mobility_petrochem_graphics = "__angelsaddons-mobility-graphics-petro__",
	---Angel's Addons - Mass Transit - Smelting Graphics.
	mobility_smelting_graphics = "__angelsaddons-mobility-graphics-smelting__",
}

---Represents the symbols for which `Icons.get_symbol` creates an icon.
---@enum Symbol
_defines.symbol = {
	area_drill = "area-drill",
	filter = "filter",
	shield = "shield",
	aperture_open = "aperture-open",
	aperture_closed = "aperture-closed",
}

---Represents the letters for which `Icons.get_letter` creates an icon.
---@enum Letter
_defines.letter = {
	F = "F",
	H = "H",
	L = "L",
	M = "M",
	S = "S",
}

---Represents the constant icons of the base game that `Icons.get_technology_constant` places on a technology icon.
---
---Each value names the file `__core__/graphics/icons/technology/constants/constant-{value}.png`.
---@enum TechnologyConstant
_defines.technology_constant = {
	battery = "battery",
	braking_force = "braking-force",
	capacity = "capacity",
	count = "count",
	damage = "damage",
	equipment = "equipment",
	equipment_white = "equipment-white",
	follower_count = "follower-count",
	health = "health",
	logistic_slot = "logistic-slot",
	map_zoom = "map-zoom",
	mining = "mining",
	mining_productivity = "mining-productivity",
	movement_speed = "movement-speed",
	planet = "planet",
	range = "range",
	recipe_productivity = "recipe-productivity",
	speed = "speed",
	time_to_live_ghosts = "time-to-live-ghosts",
}

---Represents the equipment overlays that `Icons.get_technology_equipment_overlay` places on a technology icon.
---@enum EquipmentOverlay
_defines.equipment_overlay = {
	---The overlay of a technology that unlocks personal equipment.
	personal = "personal",
	---The overlay of a technology that unlocks vehicle equipment.
	vehicle = "vehicle",
}

---Represents the light sprites available for composition with icons.
---@enum Light
_defines.light = {
	---A radioactive atomic artillery shell.
	atomic_artillery_shell = "atomic-artillery-shell",
	---A bullet with a glowing aura.
	aura_bullet = "aura-bullet",
	---A projectile component with a glowing aura.
	aura_projectile = "aura-projectile",
	---A rocket with a glowing aura.
	aura_rocket = "aura-rocket",
	---A shotgun shell with a glowing aura.
	aura_shotgun_shell = "aura-shotgun-shell",
	---A warhead with a glowing aura.
	aura_warhead = "aura-warhead",
	---An electric bullet.
	electric_bullet = "electric-bullet",
	---An electric projectile component.
	electric_projectile = "electric-projectile",
	---An electric rocket.
	electric_rocket = "electric-rocket",
	---An electric shotgun shell.
	electric_shotgun_shell = "electric-shotgun-shell",
	---An electric warhead.
	electric_warhead = "electric-warhead",
	---A fuel item, such as nuclear fuel.
	fuel = "fuel",
	---A reactor fuel cell.
	fuel_cell = "fuel-cell",
	---A laser rifle battery.
	laser_rifle_battery = "laser-rifle-battery",
	---A rocket, such as a uranium-tipped rocket.
	rocket = "rocket",
	---A magazine, such as uranium rounds.
	rounds_magazine = "rounds-magazine",
}

---Defines the name of a pipe material.
---@alias PipeMaterialName
---| "aluminum"
---| "brass"
---| "bronze"
---| "ceramic"
---| "copper"
---| "copper-tungsten"
---| "iron"
---| "nitinol"
---| "plastic"
---| "steel"
---| "stone"
---| "titanium"
---| "tungsten"

---Represents the materials for which pipe artwork exists.
---@enum PipeMaterial
_defines.pipe_material = {
	aluminum = "aluminum",
	brass = "brass",
	bronze = "bronze",
	ceramic = "ceramic",
	ceramic_angels = "angels-ceramic",
	copper = "copper",
	copper_tungsten = "copper-tungsten",
	iron = "iron",
	nitinol = "nitinol",
	nitinol_angels = "angels-nitinol",
	plastic = "plastic",
	steel = "steel",
	stone = "stone",
	titanium = "titanium",
	titanium_angels = "angels-titanium",
	tungsten = "tungsten",
	tungsten_angels = "angels-tungsten",
}

---Represents the name of each sprite set class, as a key for the mappings of prototype types, applicators, and
---conversions to sprite sets.
---@enum SpriteSetType
_defines.sprite_set_type = {
	---The sprite set for `AssemblingMachinePrototype` and `FurnacePrototype`.
	crafting_machine_sprite_set = "CraftingMachineSpriteSet",

	---The sprite set for `BoilerPrototype`.
	boiler_sprite_set = "BoilerSpriteSet",

	---The sprite set for `GeneratorPrototype`.
	generator_sprite_set = "GeneratorSpriteSet",

	---The sprite set for `BurnerGeneratorPrototype`.
	burner_generator_sprite_set = "BurnerGeneratorSpriteSet",

	---The sprite set for `AmmoTurretPrototype`, `ElectricTurretPrototype`, and `FluidTurretPrototype`.
	turret_sprite_set = "TurretSpriteSet",

	---The sprite set for `ArtilleryTurretPrototype`.
	artillery_turret_sprite_set = "ArtilleryTurretSpriteSet",

	---The sprite set for `MiningDrillPrototype`.
	mining_drill_sprite_set = "MiningDrillSpriteSet",

	---The sprite set for `OffshorePumpPrototype`.
	offshore_pump_sprite_set = "OffshorePumpSpriteSet",

	---The sprite set for `BeaconPrototype`.
	beacon_sprite_set = "BeaconSpriteSet",

	---The sprite set for `TransportBeltPrototype`.
	transport_belt_sprite_set = "TransportBeltSpriteSet",

	---The sprite set for `UndergroundBeltPrototype`.
	underground_belt_sprite_set = "UndergroundBeltSpriteSet",

	---The sprite set for `SplitterPrototype`.
	splitter_sprite_set = "SplitterSpriteSet",

	---The sprite set for `Loader1x2Prototype` and `Loader1x1Prototype`.
	loader_sprite_set = "LoaderSpriteSet",

	---The sprite set for `ElectricPolePrototype`.
	electric_pole_sprite_set = "ElectricPoleSpriteSet",

	---The sprite set for `PipePrototype`.
	pipe_sprite_set = "PipeSpriteSet",

	---The sprite set for `PipeToGroundPrototype`.
	pipe_to_ground_sprite_set = "PipeToGroundSpriteSet",

	---The sprite set for `HeatPipePrototype`.
	heat_pipe_sprite_set = "HeatPipeSpriteSet",

	---The sprite set for `CombatRobotPrototype`.
	combat_robot_sprite_set = "CombatRobotSpriteSet",

	---The sprite set for `ConstructionRobotPrototype`.
	construction_robot_sprite_set = "ConstructionRobotSpriteSet",

	---The sprite set for `LogisticRobotPrototype`.
	logistic_robot_sprite_set = "LogisticRobotSpriteSet",

	---The sprite set for `AccumulatorPrototype`.
	accumulator_sprite_set = "AccumulatorSpriteSet",

	---The sprite set for `InserterPrototype`.
	inserter_sprite_set = "InserterSpriteSet",

	---The sprite set for `ReactorPrototype`.
	reactor_sprite_set = "ReactorSpriteSet",

	---The sprite set for `PumpPrototype`.
	pump_sprite_set = "PumpSpriteSet",

	---The sprite set for `LandMinePrototype`.
	land_mine_sprite_set = "LandMineSpriteSet",

	---The sprite set for `RadarPrototype`.
	radar_sprite_set = "RadarSpriteSet",

	---The sprite set for `RoboportPrototype`.
	roboport_sprite_set = "RoboportSpriteSet",

	---The sprite set for `SolarPanelPrototype`.
	solar_panel_sprite_set = "SolarPanelSpriteSet",

	---The sprite set for `StorageTankPrototype`.
	storage_tank_sprite_set = "StorageTankSpriteSet",

	---The sprite set for `LabPrototype`.
	lab_sprite_set = "LabSpriteSet",

	---The sprite set for `UnitPrototype`.
	unit_sprite_set = "UnitSpriteSet",

	---The sprite set for `WallPrototype`.
	wall_sprite_set = "WallSpriteSet",

	---The sprite set for `GatePrototype`.
	gate_sprite_set = "GateSpriteSet",

	---The sprite set for `ValvePrototype`.
	valve_sprite_set = "ValveSpriteSet",

	---The sprite set for `ContainerPrototype`.
	container_sprite_set = "ContainerSpriteSet",

	---The sprite set for `LogisticContainerPrototype`.
	logistic_container_sprite_set = "LogisticContainerSpriteSet",

	---The sprite set for `LocomotivePrototype`, `CargoWagonPrototype`, `FluidWagonPrototype`,
	---`ArtilleryWagonPrototype`, and `CarPrototype`.
	entity_with_health_sprite_set = "EntityWithHealthSpriteSet",
}

---Represents the request for the generic remnants of the base game that match the size of an entity.
---@alias GenericRemnants "generic-remnants"

---Represents the request for the generic remnants of the base game that match the size of an entity, as the `corpse` of
---a sprite set. The value is the name of the subgroup for the generic remnants of the base game.
---@type GenericRemnants
_defines.generic_remnants = "generic-remnants"

return _defines
