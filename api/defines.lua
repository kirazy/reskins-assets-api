---@namespace Reskins.Assets

---Provides enumerations specific to Artisanal Reskins.
---
---#### Examples
---```lua
---local _defines = require("__reskins-assets-api__.api.defines")
---```
---@class Defines
local _defines = {}

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

	---The sprite set for `TransportBeltPrototype`, `UndergroundBeltPrototype`, `LinkedBeltPrototype`, and
	---`SplitterPrototype`.
	transport_belt_sprite_set = "TransportBeltSpriteSet",

	---The sprite set for `ElectricPolePrototype`.
	electric_pole_sprite_set = "ElectricPoleSpriteSet",

	---The sprite set for `PipePrototype`.
	pipe_sprite_set = "PipeSpriteSet",

	---The sprite set for `PipeToGroundPrototype`.
	pipe_to_ground_sprite_set = "PipeToGroundSpriteSet",

	---The sprite set for `HeatPipePrototype`.
	heat_pipe_sprite_set = "HeatPipeSpriteSet",

	---The sprite set for `CombatRobotPrototype`.
	flying_robot_sprite_set = "FlyingRobotSpriteSet",

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
}

return _defines
