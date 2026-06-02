-- cspell: words composters crystallizers powderizers refugiums
if not mods["angelsrefining"] then
	return
end

local tints = require("reference_tints")

local InductionFurnaceGraphicsPack = require("graphics-packs.angels.smelting.induction-furnace-graphics-pack")
local induction_furnaces = {
	["angels-induction-furnace"] = { tint = tints.cobalt_blue },
	["angels-induction-furnace-2"] = { tint = tints.cerulean },
	["angels-induction-furnace-3"] = { tint = tints.lime_green },
	["angels-induction-furnace-4"] = { tint = tints.golden_yellow },
}

local OilRefineryGraphicsPack = require("graphics-packs.base.oil-refinery-graphics-pack")
local oil_refineries = {
	["oil-refinery"] = { tint = tints.cobalt_blue },
	["angels-oil-refinery-2"] = { tint = tints.cerulean },
	["angels-oil-refinery-3"] = { tint = tints.lime_green },
	["angels-oil-refinery-4"] = { tint = tints.golden_yellow },
}

local ChemicalPlantGraphicsPack = require("graphics-packs.angels.petrochem.chemical-plant-graphics-pack")
local chemical_plants = {
	["chemical-plant"] = { tint = tints.cobalt_blue },
	["bob-chemical-plant-2"] = { tint = tints.cerulean },
	["bob-chemical-plant-3"] = { tint = tints.lime_green },
	["bob-chemical-plant-4"] = { tint = tints.golden_yellow },
}

for name, params in pairs(chemical_plants) do
	ChemicalPlantGraphicsPack:configure(params):try_apply_to_entity(data.raw["petrochem-chemical-plant"][name])
end

for name, params in pairs(oil_refineries) do
	OilRefineryGraphicsPack:configure(params):try_apply_to_entity(data.raw["assembling-machine"][name])
end

for name, params in pairs(induction_furnaces) do
	InductionFurnaceGraphicsPack:configure(params):try_apply_to_entity(data.raw["assembling-machine"][name])
end

local ChemicalFurnaceGraphicsPack = require("graphics-packs.angels.smelting.chemical-furnace-graphics-pack")
local chemical_furnaces = {
	["chemical-furnace"] = { tint = tints.yellow },
}

for name, params in pairs(chemical_furnaces) do
	ChemicalFurnaceGraphicsPack:configure(params):try_apply_to_entity(data.raw["chemical-furnace"][name])
end

local OreProcessingMachineGraphicsPack = require("graphics-packs.angels.smelting.ore-processing-machine-graphics-pack")
local ore_processing_machines = {
	["ore-processing-machine"] = { tint = tints.yellow },
}

for name, params in pairs(ore_processing_machines) do
	OreProcessingMachineGraphicsPack:configure(params):try_apply_to_entity(data.raw["ore-processing-machine"][name])
end

local PowderMixerGraphicsPack = require("graphics-packs.angels.smelting.powder-mixer-graphics-pack")
local powder_mixers = {
	["powder-mixer"] = { tint = tints.yellow },
}

for name, params in pairs(powder_mixers) do
	PowderMixerGraphicsPack:configure(params):try_apply_to_entity(data.raw["powder-mixer"][name])
end

local SinteringOvenGraphicsPack = require("graphics-packs.angels.smelting.sintering-over-graphics-pack")
local sintering_ovens = {
	["sintering-oven"] = { tint = tints.yellow },
}

for name, params in pairs(sintering_ovens) do
	SinteringOvenGraphicsPack:configure(params):try_apply_to_entity(data.raw["sintering-oven"][name])
end

local PelletPressGraphicsPack = require("graphics-packs.angels.smelting.pellet-press-graphics-pack")
local pellet_presses = {
	["pellet-press"] = { tint = tints.yellow },
}

for name, params in pairs(pellet_presses) do
	PelletPressGraphicsPack:configure(params):try_apply_to_entity(data.raw["pellet-press"][name])
end

local BlastFurnaceGraphicsPack = require("graphics-packs.angels.smelting.blast-furnace-graphics-pack")
local blast_furnaces = {
	["blast-furnace"] = { tint = tints.yellow },
}

for name, params in pairs(blast_furnaces) do
	BlastFurnaceGraphicsPack:configure(params):try_apply_to_entity(data.raw["blast-furnace"][name])
end

local CastingMachineGraphicsPack = require("graphics-packs.angels.smelting.casting-machine-graphics-pack")
local casting_machines = {
	["casting-machine"] = { tint = tints.yellow },
}

for name, params in pairs(casting_machines) do
	CastingMachineGraphicsPack:configure(params):try_apply_to_entity(data.raw["casting-machine"][name])
end

local StrandCastingMachineGraphicsPack = require("graphics-packs.angels.smelting.strand-casting-machine-graphics-pack")
local strand_casting_machines = {
	["strand-casting-machine"] = { tint = tints.yellow },
}

for name, params in pairs(strand_casting_machines) do
	StrandCastingMachineGraphicsPack:configure(params):try_apply_to_entity(data.raw["strand-casting-machine"][name])
end

local WashingPlantGraphicsPack = require("graphics-packs.angels.refining.washing-plant-graphics-pack")
local washing_plants = {
	["washing-plant"] = { tint = tints.yellow },
}

for name, params in pairs(washing_plants) do
	WashingPlantGraphicsPack:configure(params):try_apply_to_entity(data.raw["washing-plant"][name])
end

local SalinationPlantGraphicsPack = require("graphics-packs.angels.refining.salination-plant-graphics-pack")
local salination_plants = {
	["salination-plant"] = { tint = tints.yellow },
}

for name, params in pairs(salination_plants) do
	SalinationPlantGraphicsPack:configure(params):try_apply_to_entity(data.raw["salination-plant"][name])
end

local OreSortingFacilityGraphicsPack = require("graphics-packs.angels.refining.ore-sorting-facility-graphics-pack")
local ore_sorting_facilities = {
	["ore-sorting-facility"] = { tint = tints.yellow },
}

for name, params in pairs(ore_sorting_facilities) do
	OreSortingFacilityGraphicsPack:configure(params):try_apply_to_entity(data.raw["ore-sorting-facility"][name])
end

local PowderizerGraphicsPack = require("graphics-packs.angels.refining.powderizer-graphics-pack")
local powderizers = {
	["powderizer"] = { tint = tints.yellow },
}

for name, params in pairs(powderizers) do
	PowderizerGraphicsPack:configure(params):try_apply_to_entity(data.raw["powderizer"][name])
end

local OreLeachingPlantGraphicsPack = require("graphics-packs.angels.refining.ore-leaching-plant-graphics-pack")
local ore_leaching_plants = {
	["ore-leaching-plant"] = { tint = tints.yellow },
}

for name, params in pairs(ore_leaching_plants) do
	OreLeachingPlantGraphicsPack:configure(params):try_apply_to_entity(data.raw["ore-leaching-plant"][name])
end

local OreFlotationCellGraphicsPack = require("graphics-packs.angels.refining.ore-flotation-cell-graphics-pack")
local ore_flotation_cells = {
	["ore-flotation-cell"] = { tint = tints.yellow },
}

for name, params in pairs(ore_flotation_cells) do
	OreFlotationCellGraphicsPack:configure(params):try_apply_to_entity(data.raw["ore-flotation-cell"][name])
end

local OreCrusherGraphicsPack = require("graphics-packs.angels.refining.ore-crusher-graphics-pack")
local ore_crushers = {
	["ore-crusher"] = { tint = tints.yellow },
}

for name, params in pairs(ore_crushers) do
	OreCrusherGraphicsPack:configure(params):try_apply_to_entity(data.raw["ore-crusher"][name])
end

local LiquefierGraphicsPack = require("graphics-packs.angels.refining.liquefier-graphics-pack")
local liquefiers = {
	["liquefier"] = { tint = tints.yellow },
}

for name, params in pairs(liquefiers) do
	LiquefierGraphicsPack:configure(params):try_apply_to_entity(data.raw["liquefier"][name])
end

local HydroPlantGraphicsPack = require("graphics-packs.angels.refining.hydro-plant-graphics-pack")
local hydro_plants = {
	["hydro-plant"] = { tint = tints.yellow },
}

for name, params in pairs(hydro_plants) do
	HydroPlantGraphicsPack:configure(params):try_apply_to_entity(data.raw["hydro-plant"][name])
end

local ElectroWinningCellGraphicsPack = require("graphics-packs.angels.refining.electro-winning-cell-graphics-pack")
local electro_winning_cells = {
	["electro-winning-cell"] = { tint = tints.yellow },
}

for name, params in pairs(electro_winning_cells) do
	ElectroWinningCellGraphicsPack:configure(params):try_apply_to_entity(data.raw["electro-winning-cell"][name])
end

local CrystallizerGraphicsPack = require("graphics-packs.angels.refining.crystallizer-graphics-pack")
local crystallizers = {
	["crystallizer"] = { tint = tints.yellow },
}

for name, params in pairs(crystallizers) do
	CrystallizerGraphicsPack:configure(params):try_apply_to_entity(data.raw["crystallizer"][name])
end

local FiltrationUnitGraphicsPack = require("graphics-packs.angels.refining.filtration-unit-graphics-pack")
local filtration_units = {
	["filtration-unit"] = { tint = tints.yellow },
}

for name, params in pairs(filtration_units) do
	FiltrationUnitGraphicsPack:configure(params):try_apply_to_entity(data.raw["filtration-unit"][name])
end

local OreRefineryGraphicsPack = require("graphics-packs.angels.refining.ore-refinery-graphics-pack")
local ore_refineries = {
	["ore-refinery"] = { tint = tints.yellow },
}

for name, params in pairs(ore_refineries) do
	OreRefineryGraphicsPack:configure(params):try_apply_to_entity(data.raw["ore-refinery"][name])
end

local SteamCrackerGraphicsPack = require("graphics-packs.angels.petrochem.steam-cracker-graphics-pack")
local steam_crackers = {
	["steam-cracker"] = { tint = tints.yellow },
}

for name, params in pairs(steam_crackers) do
	SteamCrackerGraphicsPack:configure(params):try_apply_to_entity(data.raw["steam-cracker"][name])
end

local SeparatorGraphicsPack = require("graphics-packs.angels.petrochem.separator-graphics-pack")
local separators = {
	["separator"] = { tint = tints.yellow },
}

for name, params in pairs(separators) do
	SeparatorGraphicsPack:configure(params):try_apply_to_entity(data.raw["separator"][name])
end

local GasRefineryGraphicsPack = require("graphics-packs.angels.petrochem.gas-refinery-graphics-pack")
local gas_refineries = {
	["gas-refinery"] = { tint = tints.yellow },
}

for name, params in pairs(gas_refineries) do
	GasRefineryGraphicsPack:configure(params):try_apply_to_entity(data.raw["gas-refinery"][name])
end

local ElectrolyserGraphicsPack = require("graphics-packs.angels.petrochem.electrolyser-graphics-pack")
local electrolysers = {
	["electrolyser"] = { tint = tints.yellow },
}

for name, params in pairs(electrolysers) do
	ElectrolyserGraphicsPack:configure(params):try_apply_to_entity(data.raw["electrolyser"][name])
end

local ElectricBoilerGraphicsPack = require("graphics-packs.angels.petrochem.electric-boiler-graphics-pack")
local electric_boilers = {
	["electric-boiler"] = { tint = tints.yellow },
}

for name, params in pairs(electric_boilers) do
	ElectricBoilerGraphicsPack:configure(params):try_apply_to_entity(data.raw["electric-boiler"][name])
end

local AirFilterGraphicsPack = require("graphics-packs.angels.petrochem.air-filter-graphics-pack")
local air_filters = {
	["air-filter"] = { tint = tints.yellow },
}

for name, params in pairs(air_filters) do
	AirFilterGraphicsPack:configure(params):try_apply_to_entity(data.raw["air-filter"][name])
end

local AdvancedGasRefineryGraphicsPack = require("graphics-packs.angels.petrochem.advanced-gas-refinery-graphics-pack")
local advanced_gas_refineries = {
	["advanced-gas-refinery"] = { tint = tints.yellow },
}

for name, params in pairs(advanced_gas_refineries) do
	AdvancedGasRefineryGraphicsPack:configure(params):try_apply_to_entity(data.raw["advanced-gas-refinery"][name])
end

local SeedExtractorGraphicsPack = require("graphics-packs.angels.bioprocessing.seed-extractor-graphics-pack")
local seed_extractors = {
	["seed-extractor"] = { tint = tints.yellow },
}

for name, params in pairs(seed_extractors) do
	SeedExtractorGraphicsPack:configure(params):try_apply_to_entity(data.raw["seed-extractor"][name])
end

local AlgaeFarmGraphicsPack = require("graphics-packs.angels.bioprocessing.algae-farm-graphics-pack")
local algae_farms = {
	["algae-farm"] = { tint = tints.yellow },
}

for name, params in pairs(algae_farms) do
	AlgaeFarmGraphicsPack:configure(params):try_apply_to_entity(data.raw["algae-farm"][name])
end

local OilPressGraphicsPack = require("graphics-packs.angels.bioprocessing.oil-press-graphics-pack")
local oil_presses = {
	["oil-press"] = { tint = tints.yellow },
}

for name, params in pairs(oil_presses) do
	OilPressGraphicsPack:configure(params):try_apply_to_entity(data.raw["oil-press"][name])
end

local NutrientExtractorGraphicsPack = require("graphics-packs.angels.bioprocessing.nutrient-extractor-graphics-pack")
local nutrient_extractors = {
	["nutrient-extractor"] = { tint = tints.yellow },
}

for name, params in pairs(nutrient_extractors) do
	NutrientExtractorGraphicsPack:configure(params):try_apply_to_entity(data.raw["nutrient-extractor"][name])
end

local ComposterGraphicsPack = require("graphics-packs.angels.bioprocessing.composter-graphics-pack")
local composters = {
	["composter"] = { tint = tints.yellow },
}

for name, params in pairs(composters) do
	ComposterGraphicsPack:configure(params):try_apply_to_entity(data.raw["composter"][name])
end

local ButcheryGraphicsPack = require("graphics-packs.angels.bioprocessing.butchery-graphics-pack")
local butcheries = {
	["butchery"] = { tint = tints.yellow },
}

for name, params in pairs(butcheries) do
	ButcheryGraphicsPack:configure(params):try_apply_to_entity(data.raw["butchery"][name])
end

local BioProcessorGraphicsPack = require("graphics-packs.angels.bioprocessing.bio-processor-graphics-pack")
local bio_processors = {
	["bio-processor"] = { tint = tints.yellow },
}

for name, params in pairs(bio_processors) do
	BioProcessorGraphicsPack:configure(params):try_apply_to_entity(data.raw["bio-processor"][name])
end

local HatcheryGraphicsPack = require("graphics-packs.angels.bioprocessing.hatchery-graphics-pack")
local hatcheries = {
	["hatchery"] = { tint = tints.yellow },
}

for name, params in pairs(hatcheries) do
	HatcheryGraphicsPack:configure(params):try_apply_to_entity(data.raw["hatchery"][name])
end

local ArboretumGraphicsPack = require("graphics-packs.angels.bioprocessing.arboretum-graphics-pack")
local arboretums = {
	["arboretum"] = { tint = tints.yellow },
}

for name, params in pairs(arboretums) do
	ArboretumGraphicsPack:configure(params):try_apply_to_entity(data.raw["arboretum"][name])
end

local TreeGeneratorGraphicsPack = require("graphics-packs.angels.bioprocessing.tree-generator-graphics-pack")
local tree_generators = {
	["tree-generator"] = { tint = tints.yellow },
}

for name, params in pairs(tree_generators) do
	TreeGeneratorGraphicsPack:configure(params):try_apply_to_entity(data.raw["tree-generator"][name])
end

local RefugiumGraphicsPack = require("graphics-packs.angels.bioprocessing.refugium-graphics-pack")
local refugiums = {
	["refugium"] = { tint = tints.yellow },
}

for name, params in pairs(refugiums) do
	RefugiumGraphicsPack:configure(params):try_apply_to_entity(data.raw["refugium"][name])
end

local CropFarmGraphicsPack = require("graphics-packs.angels.bioprocessing.crop-farm-graphics-pack")
local crop_farms = {
	["crop-farm"] = { tint = tints.yellow },
}

for name, params in pairs(crop_farms) do
	CropFarmGraphicsPack:configure(params):try_apply_to_entity(data.raw["crop-farm"][name])
end
