-- cspell: words composters crystallizers powderizers refugiums liquifier whinning
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

for name, params in pairs(induction_furnaces) do
	InductionFurnaceGraphicsPack:configure(params):try_apply_to_entity(data.raw["assembling-machine"][name])
end

local ChemicalPlantGraphicsPack = require("graphics-packs.angels.petrochem.chemical-plant-graphics-pack")
local chemical_plants = {
	["chemical-plant"] = { tint = tints.cobalt_blue },
	["angels-chemical-plant-2"] = { tint = tints.cerulean },
	["angels-chemical-plant-3"] = { tint = tints.lime_green },
	["angels-chemical-plant-4"] = { tint = tints.golden_yellow },
}

for name, params in pairs(chemical_plants) do
	ChemicalPlantGraphicsPack:configure(params):try_apply_to_entity(data.raw["assembling-machine"][name])
end

-- stylua: ignore start
local AdvancedChemicalPlantGraphicsPack = require("graphics-packs.angels.petrochem.advanced-chemical-plant-graphics-pack")
local advanced_chemical_plants = {
	["angels-advanced-chemical-plant"] ={ tint = tints.cobalt_blue },
	["angels-advanced-chemical-plant-2"]= { tint = tints.cerulean },

	-- Extended Angels
	["angels-advanced-chemical-plant-3"]= { tint = tints.lime_green },
}
-- stylua: ignore end

for name, params in pairs(advanced_chemical_plants) do
	AdvancedChemicalPlantGraphicsPack:configure(params):try_apply_to_entity(data.raw["assembling-machine"][name])
end

local OilRefineryGraphicsPack = require("graphics-packs.base.oil-refinery-graphics-pack")
local oil_refineries = {
	["oil-refinery"] = { tint = tints.cobalt_blue },
	["angels-oil-refinery-2"] = { tint = tints.cerulean },
	["angels-oil-refinery-3"] = { tint = tints.lime_green },
	["angels-oil-refinery-4"] = { tint = tints.golden_yellow },
}

for name, params in pairs(oil_refineries) do
	OilRefineryGraphicsPack:configure(params):try_apply_to_entity(data.raw["assembling-machine"][name])
end

local ChemicalFurnaceGraphicsPack = require("graphics-packs.angels.smelting.chemical-furnace-graphics-pack")
local chemical_furnaces = {
	["angels-chemical-furnace"] = { tint = tints.cobalt_blue },
	["angels-chemical-furnace-2"] = { tint = tints.cerulean },
	["angels-chemical-furnace-3"] = { tint = tints.lime_green },
	["angels-chemical-furnace-4"] = { tint = tints.golden_yellow },
}

for name, params in pairs(chemical_furnaces) do
	ChemicalFurnaceGraphicsPack:configure(params):try_apply_to_entity(data.raw["assembling-machine"][name])
end

local OreProcessingMachineGraphicsPack = require("graphics-packs.angels.smelting.ore-processing-machine-graphics-pack")
local ore_processing_machines = {
	["angels-ore-processing-machine"] = { tint = tints.cobalt_blue },
	["angels-ore-processing-machine-2"] = { tint = tints.cerulean },
	["angels-ore-processing-machine-3"] = { tint = tints.lime_green },
	["angels-ore-processing-machine-4"] = { tint = tints.golden_yellow },
}

for name, params in pairs(ore_processing_machines) do
	OreProcessingMachineGraphicsPack:configure(params):try_apply_to_entity(data.raw["assembling-machine"][name])
end

local PowderMixerGraphicsPack = require("graphics-packs.angels.smelting.powder-mixer-graphics-pack")
local powder_mixers = {
	["angels-powder-mixer"] = { tint = tints.cobalt_blue },
	["angels-powder-mixer-2"] = { tint = tints.cerulean },
	["angels-powder-mixer-3"] = { tint = tints.lime_green },
	["angels-powder-mixer-4"] = { tint = tints.golden_yellow },
}

for name, params in pairs(powder_mixers) do
	PowderMixerGraphicsPack:configure(params):try_apply_to_entity(data.raw["assembling-machine"][name])
end

local SinteringOvenGraphicsPack = require("graphics-packs.angels.smelting.sintering-over-graphics-pack")
local sintering_ovens = {
	["angels-sintering-oven"] = { tint = tints.cobalt_blue },
	["angels-sintering-oven-2"] = { tint = tints.cerulean },
	["angels-sintering-oven-3"] = { tint = tints.lime_green },
	["angels-sintering-oven-4"] = { tint = tints.golden_yellow },
	["angels-sintering-oven-5"] = { tint = tints.vermilion },
}

for name, params in pairs(sintering_ovens) do
	SinteringOvenGraphicsPack:configure(params):try_apply_to_entity(data.raw["assembling-machine"][name])
end

local PelletPressGraphicsPack = require("graphics-packs.angels.smelting.pellet-press-graphics-pack")
local pellet_presses = {
	["angels-pellet-press"] = { tint = tints.cobalt_blue },
	["angels-pellet-press-2"] = { tint = tints.cerulean },
	["angels-pellet-press-3"] = { tint = tints.lime_green },
	["angels-pellet-press-4"] = { tint = tints.golden_yellow },
}

for name, params in pairs(pellet_presses) do
	PelletPressGraphicsPack:configure(params):try_apply_to_entity(data.raw["assembling-machine"][name])
end

local BlastFurnaceGraphicsPack = require("graphics-packs.angels.smelting.blast-furnace-graphics-pack")
local blast_furnaces = {
	["angels-blast-furnace"] = { tint = tints.cobalt_blue },
	["angels-blast-furnace-2"] = { tint = tints.cerulean },
	["angels-blast-furnace-3"] = { tint = tints.lime_green },
	["angels-blast-furnace-4"] = { tint = tints.golden_yellow },
}

for name, params in pairs(blast_furnaces) do
	BlastFurnaceGraphicsPack:configure(params):try_apply_to_entity(data.raw["assembling-machine"][name])
end

local CastingMachineGraphicsPack = require("graphics-packs.angels.smelting.casting-machine-graphics-pack")
local casting_machines = {
	["angels-casting-machine"] = { tint = tints.cobalt_blue },
	["angels-casting-machine-2"] = { tint = tints.cerulean },
	["angels-casting-machine-3"] = { tint = tints.lime_green },
	["angels-casting-machine-4"] = { tint = tints.golden_yellow },
}

for name, params in pairs(casting_machines) do
	CastingMachineGraphicsPack:configure(params):try_apply_to_entity(data.raw["assembling-machine"][name])
end

local StrandCastingMachineGraphicsPack = require("graphics-packs.angels.smelting.strand-casting-machine-graphics-pack")
local strand_casting_machines = {
	["angels-strand-casting-machine"] = { tint = tints.cobalt_blue },
	["angels-strand-casting-machine-2"] = { tint = tints.cerulean },
	["angels-strand-casting-machine-3"] = { tint = tints.lime_green },
	["angels-strand-casting-machine-4"] = { tint = tints.golden_yellow },
}

for name, params in pairs(strand_casting_machines) do
	StrandCastingMachineGraphicsPack:configure(params):try_apply_to_entity(data.raw["assembling-machine"][name])
end

local WashingPlantGraphicsPack = require("graphics-packs.angels.refining.washing-plant-graphics-pack")
local washing_plants = {
	["angels-washing-plant"] = { tint = tints.cobalt_blue },
	["angels-washing-plant-2"] = { tint = tints.cerulean },

	-- Extended Angels
	["angels-washing-plant-3"] = { tint = tints.lime_green },
	["angels-washing-plant-4"] = { tint = tints.golden_yellow },
}

for name, params in pairs(washing_plants) do
	WashingPlantGraphicsPack:configure(params):try_apply_to_entity(data.raw["assembling-machine"][name])
end

local SalinationPlantGraphicsPack = require("graphics-packs.angels.refining.salination-plant-graphics-pack")
local salination_plants = {
	["angels-salination-plant"] = { tint = tints.cobalt_blue },
	["angels-salination-plant-2"] = { tint = tints.cerulean },

	-- Extended Angels
	["angels-salination-plant-3"] = { tint = tints.lime_green },
}

for name, params in pairs(salination_plants) do
	SalinationPlantGraphicsPack:configure(params):try_apply_to_entity(data.raw["assembling-machine"][name])
end

local OreSortingFacilityGraphicsPack = require("graphics-packs.angels.refining.ore-sorting-facility-graphics-pack")
local ore_sorting_facilities = {
	["angels-ore-sorting-facility"] = { tint = tints.cobalt_blue },
	["angels-ore-sorting-facility-2"] = { tint = tints.cerulean },
	["angels-ore-sorting-facility-3"] = { tint = tints.lime_green },
	["angels-ore-sorting-facility-4"] = { tint = tints.golden_yellow },
	["angels-ore-sorting-facility-5"] = { tint = tints.vermilion },
}

for name, params in pairs(ore_sorting_facilities) do
	OreSortingFacilityGraphicsPack:configure(params):try_apply_to_entity(data.raw["assembling-machine"][name])
end

local PowderizerGraphicsPack = require("graphics-packs.angels.refining.powderizer-graphics-pack")
local powderizers = {
	["angels-powderizer"] = { tint = tints.cobalt_blue },
	["angels-powderizer-2"] = { tint = tints.cerulean },
	["angels-powderizer-3"] = { tint = tints.lime_green },
}

for name, params in pairs(powderizers) do
	PowderizerGraphicsPack:configure(params):try_apply_to_entity(data.raw["assembling-machine"][name])
end

local OreLeachingPlantGraphicsPack = require("graphics-packs.angels.refining.ore-leaching-plant-graphics-pack")
local ore_leaching_plants = {
	["angels-ore-leaching-plant"] = { tint = tints.cobalt_blue },
	["angels-ore-leaching-plant-2"] = { tint = tints.cerulean },
	["angels-ore-leaching-plant-3"] = { tint = tints.lime_green },

	-- Extended Angels
	["angels-ore-leaching-plant-4"] = { tint = tints.golden_yellow },
}

for name, params in pairs(ore_leaching_plants) do
	OreLeachingPlantGraphicsPack:configure(params):try_apply_to_entity(data.raw["assembling-machine"][name])
end

local OreFlotationCellGraphicsPack = require("graphics-packs.angels.refining.ore-flotation-cell-graphics-pack")
local ore_flotation_cells = {
	["angels-ore-floatation-cell"] = { tint = tints.cobalt_blue },
	["angels-ore-floatation-cell-2"] = { tint = tints.cerulean },
	["angels-ore-floatation-cell-3"] = { tint = tints.lime_green },

	-- Extended Angels
	["angels-ore-floatation-cell-4"] = { tint = tints.golden_yellow },
}

for name, params in pairs(ore_flotation_cells) do
	OreFlotationCellGraphicsPack:configure(params):try_apply_to_entity(data.raw["assembling-machine"][name])
end

local OreCrusherGraphicsPack = require("graphics-packs.angels.refining.ore-crusher-graphics-pack")
local ore_crushers = {
	["angels-burner-ore-crusher"] = { tint = util.color("#262626") },
	["angels-ore-crusher"] = { tint = tints.cobalt_blue },
	["angels-ore-crusher-2"] = { tint = tints.cerulean },
	["angels-ore-crusher-3"] = { tint = tints.lime_green },

	-- Extended Angels
	["angels-ore-crusher-4"] = { tint = tints.golden_yellow },
}

for name, params in pairs(ore_crushers) do
	OreCrusherGraphicsPack:configure(params):try_apply_to_entity(data.raw["assembling-machine"][name])
end

local LiquefierGraphicsPack = require("graphics-packs.angels.refining.liquefier-graphics-pack")
local liquefiers = {
	["angels-liquifier"] = { tint = tints.cobalt_blue },
	["angels-liquifier-2"] = { tint = tints.cerulean },
	["angels-liquifier-3"] = { tint = tints.lime_green },
	["angels-liquifier-4"] = { tint = tints.golden_yellow },
}

for name, params in pairs(liquefiers) do
	LiquefierGraphicsPack:configure(params):try_apply_to_entity(data.raw["assembling-machine"][name])
end

local HydroPlantGraphicsPack = require("graphics-packs.angels.refining.hydro-plant-graphics-pack")
local hydro_plants = {
	["angels-hydro-plant"] = { tint = tints.cobalt_blue },
	["angels-hydro-plant-2"] = { tint = tints.cerulean },
	["angels-hydro-plant-3"] = { tint = tints.lime_green },

	-- Extended Angels
	["angels-hydro-plant-4"] = { tint = tints.golden_yellow },
}

for name, params in pairs(hydro_plants) do
	HydroPlantGraphicsPack:configure(params):try_apply_to_entity(data.raw["assembling-machine"][name])
end

local ElectroWinningCellGraphicsPack = require("graphics-packs.angels.refining.electro-winning-cell-graphics-pack")
local electro_winning_cells = {
	["angels-electro-whinning-cell"] = { tint = tints.cobalt_blue },
	["angels-electro-whinning-cell-2"] = { tint = tints.cerulean },
	["angels-electro-whinning-cell-3"] = { tint = tints.lime_green },
}

for name, params in pairs(electro_winning_cells) do
	ElectroWinningCellGraphicsPack:configure(params):try_apply_to_entity(data.raw["assembling-machine"][name])
end

local CrystallizerGraphicsPack = require("graphics-packs.angels.refining.crystallizer-graphics-pack")
local crystallizers = {
	["angels-crystallizer"] = { tint = tints.cobalt_blue },
	["angels-crystallizer-2"] = { tint = tints.cerulean },
	["angels-crystallizer-3"] = { tint = tints.lime_green },

	-- Extended Angels
	["angels-crystallizer-4"] = { tint = tints.golden_yellow },
}

for name, params in pairs(crystallizers) do
	CrystallizerGraphicsPack:configure(params):try_apply_to_entity(data.raw["assembling-machine"][name])
end

local FiltrationUnitGraphicsPack = require("graphics-packs.angels.refining.filtration-unit-graphics-pack")
local filtration_units = {
	["angels-filtration-unit"] = { tint = tints.cobalt_blue },
	["angels-filtration-unit-2"] = { tint = tints.cerulean },
	["angels-filtration-unit-3"] = { tint = tints.lime_green },

	-- Extended Angels
	["angels-filtration-unit-4"] = { tint = tints.golden_yellow },
}

for name, params in pairs(filtration_units) do
	FiltrationUnitGraphicsPack:configure(params):try_apply_to_entity(data.raw["assembling-machine"][name])
end

local OreRefineryGraphicsPack = require("graphics-packs.angels.refining.ore-refinery-graphics-pack")
local ore_refineries = {
	["angels-ore-refinery"] = { tint = tints.cobalt_blue },
	["angels-ore-refinery-2"] = { tint = tints.cerulean },

	-- Extended Angels
	["angels-ore-refinery-3"] = { tint = tints.lime_green },
}

for name, params in pairs(ore_refineries) do
	OreRefineryGraphicsPack:configure(params):try_apply_to_entity(data.raw["assembling-machine"][name])
end

local SteamCrackerGraphicsPack = require("graphics-packs.angels.petrochem.steam-cracker-graphics-pack")
local steam_crackers = {
	["angels-steam-cracker"] = { tint = tints.cobalt_blue },
	["angels-steam-cracker-2"] = { tint = tints.cerulean },
	["angels-steam-cracker-3"] = { tint = tints.lime_green },
	["angels-steam-cracker-4"] = { tint = tints.golden_yellow },
}

for name, params in pairs(steam_crackers) do
	SteamCrackerGraphicsPack:configure(params):try_apply_to_entity(data.raw["assembling-machine"][name])
end

local SeparatorGraphicsPack = require("graphics-packs.angels.petrochem.separator-graphics-pack")
local separators = {
	["angels-separator"] = { tint = tints.cobalt_blue },
	["angels-separator-2"] = { tint = tints.cerulean },
	["angels-separator-3"] = { tint = tints.lime_green },
	["angels-separator-4"] = { tint = tints.golden_yellow },
}

for name, params in pairs(separators) do
	SeparatorGraphicsPack:configure(params):try_apply_to_entity(data.raw["assembling-machine"][name])
end

local GasRefineryGraphicsPack = require("graphics-packs.angels.petrochem.gas-refinery-graphics-pack")
local gas_refineries = {
	["angels-gas-refinery-small"] = { tint = tints.cobalt_blue },
	["angels-gas-refinery-small-2"] = { tint = tints.cerulean },
	["angels-gas-refinery-small-3"] = { tint = tints.lime_green },
	["angels-gas-refinery-small-4"] = { tint = tints.golden_yellow },
}

for name, params in pairs(gas_refineries) do
	GasRefineryGraphicsPack:configure(params):try_apply_to_entity(data.raw["assembling-machine"][name])
end

local ElectrolyserGraphicsPack = require("graphics-packs.angels.petrochem.electrolyser-graphics-pack")
local electrolysers = {
	["angels-electrolyser"] = { tint = tints.cobalt_blue },
	["angels-electrolyser-2"] = { tint = tints.cerulean },
	["angels-electrolyser-3"] = { tint = tints.lime_green },
	["angels-electrolyser-4"] = { tint = tints.golden_yellow },
}

for name, params in pairs(electrolysers) do
	ElectrolyserGraphicsPack:configure(params):try_apply_to_entity(data.raw["assembling-machine"][name])
end

local ElectricBoilerGraphicsPack = require("graphics-packs.angels.petrochem.electric-boiler-graphics-pack")
local electric_boilers = {
	["angels-electric-boiler"] = { tint = tints.cobalt_blue },
	["angels-electric-boiler-2"] = { tint = tints.cerulean },
	["angels-electric-boiler-3"] = { tint = tints.lime_green },
}

for name, params in pairs(electric_boilers) do
	ElectricBoilerGraphicsPack:configure(params):try_apply_to_entity(data.raw["assembling-machine"][name])
end

local AirFilterGraphicsPack = require("graphics-packs.angels.petrochem.air-filter-graphics-pack")
local air_filters = {
	["angels-air-filter"] = { tint = tints.cobalt_blue },
	["angels-air-filter-2"] = { tint = tints.cerulean },
	["angels-air-filter-3"] = { tint = tints.lime_green },

	-- Extended Angels
	["angels-air-filter-4"] = { tint = tints.golden_yellow },
}

for name, params in pairs(air_filters) do
	AirFilterGraphicsPack:configure(params):try_apply_to_entity(data.raw["assembling-machine"][name])
end

local AdvancedGasRefineryGraphicsPack = require("graphics-packs.angels.petrochem.advanced-gas-refinery-graphics-pack")
local advanced_gas_refineries = {
	["angels-gas-refinery"] = { tint = tints.cobalt_blue },
	["angels-gas-refinery-2"] = { tint = tints.cerulean },
	["angels-gas-refinery-3"] = { tint = tints.lime_green },
	["angels-gas-refinery-4"] = { tint = tints.golden_yellow },
}

for name, params in pairs(advanced_gas_refineries) do
	AdvancedGasRefineryGraphicsPack:configure(params):try_apply_to_entity(data.raw["assembling-machine"][name])
end

local SeedExtractorGraphicsPack = require("graphics-packs.angels.bioprocessing.seed-extractor-graphics-pack")
local seed_extractors = {
	["angels-seed-extractor"] = { tint = tints.cobalt_blue },
	["angels-seed-extractor-2"] = { tint = tints.cerulean },
	["angels-seed-extractor-3"] = { tint = tints.lime_green },
}

for name, params in pairs(seed_extractors) do
	SeedExtractorGraphicsPack:configure(params):try_apply_to_entity(data.raw["assembling-machine"][name])
end

local AlgaeFarmGraphicsPack = require("graphics-packs.angels.bioprocessing.algae-farm-graphics-pack")
local algae_farms = {
	["angels-algae-farm"] = { tint = tints.cobalt_blue },
	["angels-algae-farm-2"] = { tint = tints.cerulean },
	["angels-algae-farm-3"] = { tint = tints.lime_green },
	["angels-algae-farm-4"] = { tint = tints.golden_yellow },

	-- Extended Angels
	["angels-algae-farm-5"] = { tint = tints.vermilion },
}

for name, params in pairs(algae_farms) do
	AlgaeFarmGraphicsPack:configure(params):try_apply_to_entity(data.raw["assembling-machine"][name])
end

local OilPressGraphicsPack = require("graphics-packs.angels.bioprocessing.oil-press-graphics-pack")
local oil_presses = {
	["angels-bio-press"] = { tint = tints.cobalt_blue },
	["angels-bio-press-2"] = { tint = tints.cerulean },
	["angels-bio-press-3"] = { tint = tints.lime_green },
}

for name, params in pairs(oil_presses) do
	OilPressGraphicsPack:configure(params):try_apply_to_entity(data.raw["assembling-machine"][name])
end

local NutrientExtractorGraphicsPack = require("graphics-packs.angels.bioprocessing.nutrient-extractor-graphics-pack")
local nutrient_extractors = {
	["angels-nutrient-extractor"] = { tint = tints.cobalt_blue },
	["angels-nutrient-extractor-2"] = { tint = tints.cerulean },
	["angels-nutrient-extractor-3"] = { tint = tints.lime_green },
}

for name, params in pairs(nutrient_extractors) do
	NutrientExtractorGraphicsPack:configure(params):try_apply_to_entity(data.raw["assembling-machine"][name])
end

local ComposterGraphicsPack = require("graphics-packs.angels.bioprocessing.composter-graphics-pack")
local composters = {
	["angels-composter"] = { tint = tints.cobalt_blue },
	["angels-composter-2"] = { tint = tints.cerulean },
	["angels-composter-3"] = { tint = tints.lime_green },
}

for name, params in pairs(composters) do
	ComposterGraphicsPack:configure(params):try_apply_to_entity(data.raw["furnace"][name])
end

local ButcheryGraphicsPack = require("graphics-packs.angels.bioprocessing.butchery-graphics-pack")
local butcheries = {
	["angels-bio-butchery"] = { tint = tints.cobalt_blue },
	["angels-bio-butchery-2"] = { tint = tints.cerulean },
	["angels-bio-butchery-3"] = { tint = tints.lime_green },
}

for name, params in pairs(butcheries) do
	ButcheryGraphicsPack:configure(params):try_apply_to_entity(data.raw["furnace"][name])
end

local BioProcessorGraphicsPack = require("graphics-packs.angels.bioprocessing.bio-processor-graphics-pack")
local bio_processors = {
	["angels-bio-processor"] = { tint = tints.cobalt_blue },
	["angels-bio-processor-2"] = { tint = tints.cerulean },
	["angels-bio-processor-3"] = { tint = tints.lime_green },
}

for name, params in pairs(bio_processors) do
	BioProcessorGraphicsPack:configure(params):try_apply_to_entity(data.raw["assembling-machine"][name])
end

local HatcheryGraphicsPack = require("graphics-packs.angels.bioprocessing.hatchery-graphics-pack")
local hatcheries = {
	["angels-bio-hatchery"] = { tint = tints.cobalt_blue },
	["angels-bio-hatchery-2"] = { tint = tints.cerulean },
	["angels-bio-hatchery-3"] = { tint = tints.lime_green },
}

for name, params in pairs(hatcheries) do
	HatcheryGraphicsPack:configure(params):try_apply_to_entity(data.raw["furnace"][name])
end

local ArboretumGraphicsPack = require("graphics-packs.angels.bioprocessing.arboretum-graphics-pack")
local arboretums = {
	["angels-bio-arboretum-1"] = { tint = tints.cobalt_blue },
	["angels-bio-arboretum-2"] = { tint = tints.cerulean },
	["angels-bio-arboretum-3"] = { tint = tints.lime_green },
}

for name, params in pairs(arboretums) do
	ArboretumGraphicsPack:configure(params):try_apply_to_entity(data.raw["assembling-machine"][name])
end

local TreeGeneratorGraphicsPack = require("graphics-packs.angels.bioprocessing.tree-generator-graphics-pack")
local tree_generators = {
	["angels-bio-generator-temperate-1"] = { tint = tints.cobalt_blue, variant = "temperate" },
	["angels-bio-generator-temperate-2"] = { tint = tints.cerulean, variant = "temperate" },
	["angels-bio-generator-temperate-3"] = { tint = tints.lime_green, variant = "temperate" },
	["angels-bio-generator-swamp-1"] = { tint = tints.cobalt_blue, variant = "swamp" },
	["angels-bio-generator-swamp-2"] = { tint = tints.cerulean, variant = "swamp" },
	["angels-bio-generator-swamp-3"] = { tint = tints.lime_green, variant = "swamp" },
	["angels-bio-generator-desert-1"] = { tint = tints.cobalt_blue, variant = "desert" },
	["angels-bio-generator-desert-2"] = { tint = tints.cerulean, variant = "desert" },
	["angels-bio-generator-desert-3"] = { tint = tints.lime_green, variant = "desert" },
}

for name, params in pairs(tree_generators) do
	TreeGeneratorGraphicsPack:configure(params):try_apply_to_entity(data.raw["assembling-machine"][name])
end

local RefugiumBiterGraphicsPack = require("graphics-packs.angels.bioprocessing.refugium-biter-graphics-pack")
local biter_refugiums = {
	["angels-bio-refugium-biter"] = { tint = tints.cobalt_blue },
	["angels-bio-refugium-biter-2"] = { tint = tints.cerulean },
	["angels-bio-refugium-biter-3"] = { tint = tints.lime_green },
}

for name, params in pairs(biter_refugiums) do
	RefugiumBiterGraphicsPack:configure(params):try_apply_to_entity(data.raw["assembling-machine"][name])
end

local RefugiumFishGraphicsPack = require("graphics-packs.angels.bioprocessing.refugium-fish-graphics-pack")
local fish_refugiums = {
	["angels-bio-refugium-fish"] = { tint = tints.cobalt_blue },
	["angels-bio-refugium-fish-2"] = { tint = tints.cerulean },
	["angels-bio-refugium-fish-3"] = { tint = tints.lime_green },
}

for name, params in pairs(fish_refugiums) do
	RefugiumFishGraphicsPack:configure(params):try_apply_to_entity(data.raw["assembling-machine"][name])
end

local RefugiumPufferGraphicsPack = require("graphics-packs.angels.bioprocessing.refugium-puffer-graphics-pack")
local puffer_refugiums = {
	["angels-bio-refugium-puffer"] = { tint = tints.cobalt_blue },
	["angels-bio-refugium-puffer-2"] = { tint = tints.cerulean },
	["angels-bio-refugium-puffer-3"] = { tint = tints.lime_green },
}

for name, params in pairs(puffer_refugiums) do
	RefugiumPufferGraphicsPack:configure(params):try_apply_to_entity(data.raw["assembling-machine"][name])
end

local CropFarmGraphicsPack = require("graphics-packs.angels.bioprocessing.crop-farm-graphics-pack")
local crop_farms = {
	["angels-crop-farm"] = { tint = tints.cobalt_blue, variant = "basic" },
	["angels-crop-farm-2"] = { tint = tints.cerulean, variant = "basic" },
	["angels-crop-farm-3"] = { tint = tints.lime_green, variant = "basic" },
	["angels-temperate-farm"] = { tint = tints.cobalt_blue, variant = "temperate" },
	["angels-temperate-farm-2"] = { tint = tints.cerulean, variant = "temperate" },
	["angels-temperate-farm-3"] = { tint = tints.lime_green, variant = "temperate" },
	["angels-swamp-farm"] = { tint = tints.cobalt_blue, variant = "swamp" },
	["angels-swamp-farm-2"] = { tint = tints.cerulean, variant = "swamp" },
	["angels-swamp-farm-3"] = { tint = tints.lime_green, variant = "swamp" },
	["angels-desert-farm"] = { tint = tints.cobalt_blue, variant = "desert" },
	["angels-desert-farm-2"] = { tint = tints.cerulean, variant = "desert" },
	["angels-desert-farm-3"] = { tint = tints.lime_green, variant = "desert" },
}

for name, params in pairs(crop_farms) do
	CropFarmGraphicsPack:configure(params):try_apply_to_entity(data.raw["assembling-machine"][name])
end
