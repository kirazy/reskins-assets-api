---@namespace Reskins.Assets

---Provides enumerations specific to Artisanal Reskins.
---
---### Examples
---```lua
---local _defines = require("__reskins-assets-api__.api.defines")
---```
---@class Defines
local _defines = {}

---Represents the different types of animated transport belt sprite sheets.
---@enum BeltSprites
_defines.belt_sprites = {
	---Indicates standard belt sprites.
	---
	---Used for slower belt speeds, typically less than 30 items/s.
	standard = 1,
	---Indicates fast belt sprites.
	---
	---Used for faster belt speeds, typically between 30 items/s and 60 items/s.
	---Has twice as many frames as `defines.belt_sprites.standard` and larger spacing between arrows.
	fast = 2,
	---Indicates turbo belt sprites.
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

---@enum Symbol
_defines.symbol = {
	area_drill = "area-drill",
	filter = "filter",
	shield = "shield",
	aperture_open = "aperture-open",
	aperture_closed = "aperture-closed",
}

---@enum Letter
_defines.letter = {
	F = "F",
	H = "H",
	L = "L",
	M = "M",
	S = "S",
}

---@alias PipeMaterialName
---| '"aluminum"'
---| '"brass"'
---| '"bronze"'
---| '"ceramic"'
---| '"copper"'
---| '"copper-tungsten"'
---| '"iron"'
---| '"nitinol"'
---| '"plastic"'
---| '"steel"'
---| '"stone"'
---| '"titanium"'
---| '"tungsten"'

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

---Identifies the shape of a `SpriteSetDefinition`'s `set`, so `api.apply` can route it to the
---applicator that knows how to paint that shape without the caller naming one explicitly.
---@enum SpriteSetType
_defines.sprite_set_type = {
	---Consumed by these prototypes: `AssemblingMachinePrototype`, `FurnacePrototype`
	crafting_machine_sprite_set = "CraftingMachineSpriteSet",

	---Consumed by these prototypes: `BoilerPrototype`
	boiler_sprite_set = "BoilerSpriteSet",

	---Consumed by these prototypes: `GeneratorPrototype`
	generator_sprite_set = "GeneratorSpriteSet",

	---Consumed by these prototypes: `AmmoTurretPrototype`, `ElectricTurretPrototype`, `FluidTurretPrototype`
	turret_sprite_set = "TurretSpriteSet",

	---Consumed by these prototypes: `ArtilleryTurretPrototype`
	artillery_turret_sprite_set = "ArtilleryTurretSpriteSet",

	---Consumed by these prototypes: `MiningDrillPrototype`
	mining_drill_sprite_set = "MiningDrillSpriteSet",

	---Consumed by these prototypes: `OffshorePumpPrototype`
	offshore_pump_sprite_set = "OffshorePumpSpriteSet",

	---Consumed by these prototypes: `BeaconPrototype`
	beacon_sprite_set = "BeaconSpriteSet",

	---Consumed by these prototypes: `TransportBeltPrototype`, `UndergroundBeltPrototype`, `LinkedBeltPrototype`, `SplitterPrototype`
	transport_belt_sprite_set = "TransportBeltSpriteSet",

	---Consumed by these prototypes: `ElectricPolePrototype`
	electric_pole_sprite_set = "ElectricPoleSpriteSet",

	---Consumed by these prototypes: `PipePrototype`
	pipe_sprite_set = "PipeSpriteSet",

	---Consumed by these prototypes: `PipeToGroundPrototype`
	pipe_to_ground_sprite_set = "PipeToGroundSpriteSet",

	---Consumed by these prototypes: `HeatPipePrototype`
	heat_pipe_sprite_set = "HeatPipeSpriteSet",

	---Consumed by these prototypes: `ConstructionRobotPrototype`, `LogisticRobotPrototype`, `CombatRobotPrototype`
	flying_robot_sprite_set = "FlyingRobotSpriteSet",

	---Consumed by these prototypes: `ConstructionRobotPrototype`
	construction_robot_sprite_set = "ConstructionRobotSpriteSet",

	---Consumed by these prototypes: `LogisticRobotPrototype`
	logistic_robot_sprite_set = "LogisticRobotSpriteSet",

	---Consumed by these prototypes: `AccumulatorPrototype`
	accumulator_sprite_set = "AccumulatorSpriteSet",

	---Consumed by these prototypes: `InserterPrototype`
	inserter_sprite_set = "InserterSpriteSet",

	---Consumed by these prototypes: `ReactorPrototype`
	reactor_sprite_set = "ReactorSpriteSet",

	---Consumed by these prototypes: `PumpPrototype`
	pump_sprite_set = "PumpSpriteSet",

	---Consumed by these prototypes: `RadarPrototype`
	radar_sprite_set = "RadarSpriteSet",

	---Consumed by these prototypes: `RoboportPrototype`
	roboport_sprite_set = "RoboportSpriteSet",

	---Consumed by these prototypes: `SolarPanelPrototype`
	solar_panel_sprite_set = "SolarPanelSpriteSet",

	---Consumed by these prototypes: `StorageTankPrototype`
	storage_tank_sprite_set = "StorageTankSpriteSet",
}

return _defines
