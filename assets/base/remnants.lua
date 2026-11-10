-- This file is generated from the source of the base game by reskins-workspace/tools/base_explosions/generate.py.

---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Base

local Corpses = require("api.corpses")

local M = {}

---The name of a vanilla corpse that `assets.base.remnants` duplicates.
---@alias BaseRemnantsID
---| "accumulator-remnants"
---| "active-provider-chest-remnants"
---| "artillery-turret-remnants"
---| "artillery-wagon-remnants"
---| "assembling-machine-1-remnants"
---| "assembling-machine-2-remnants"
---| "assembling-machine-3-remnants"
---| "beacon-remnants"
---| "big-electric-pole-remnants"
---| "boiler-remnants"
---| "buffer-chest-remnants"
---| "bulk-inserter-remnants"
---| "burner-inserter-remnants"
---| "cargo-wagon-remnants"
---| "centrifuge-remnants"
---| "chemical-plant-remnants"
---| "construction-robot-remnants"
---| "defender-remnants"
---| "electric-furnace-remnants"
---| "electric-mining-drill-remnants"
---| "fast-inserter-remnants"
---| "fluid-wagon-remnants"
---| "gate-remnants"
---| "gun-turret-remnants"
---| "heat-exchanger-remnants"
---| "heat-pipe-remnants"
---| "inserter-remnants"
---| "lab-remnants"
---| "laser-turret-remnants"
---| "locomotive-remnants"
---| "logistic-robot-remnants"
---| "long-handed-inserter-remnants"
---| "medium-electric-pole-remnants"
---| "nuclear-reactor-remnants"
---| "offshore-pump-remnants"
---| "oil-refinery-remnants"
---| "passive-provider-chest-remnants"
---| "pipe-remnants"
---| "pipe-to-ground-remnants"
---| "pump-remnants"
---| "pumpjack-remnants"
---| "radar-remnants"
---| "requester-chest-remnants"
---| "roboport-remnants"
---| "solar-panel-remnants"
---| "splitter-remnants"
---| "steam-engine-remnants"
---| "steam-turbine-remnants"
---| "steel-furnace-remnants"
---| "stone-furnace-remnants"
---| "storage-chest-remnants"
---| "storage-tank-remnants"
---| "substation-remnants"
---| "tank-remnants"
---| "transport-belt-remnants"
---| "underground-belt-remnants"
---| "wall-remnants"

---The fields of each vanilla corpse other than its name, icon, size, and artwork, by the name of the corpse.
---@type table<BaseRemnantsID, CorpseSpriteSet>
local definitions = {
	["accumulator-remnants"] = {
		flags = { "placeable-neutral", "not-on-map" },
		hidden_in_factoriopedia = true,
		subgroup = "energy-remnants",
		order = "a-d-a",
		selectable_in_game = false,
		time_before_removed = 60 * 60 * 15,
		expires = false,
		final_render_layer = "remnants",
		remove_on_tile_placement = false,
	},
	["active-provider-chest-remnants"] = {
		flags = { "placeable-neutral", "building-direction-8-way", "not-on-map" },
		hidden_in_factoriopedia = true,
		subgroup = "logistic-network-remnants",
		order = "a-c-a",
		selectable_in_game = false,
		time_before_removed = 60 * 60 * 15,
		expires = false,
		final_render_layer = "remnants",
		remove_on_tile_placement = false,
	},
	["artillery-turret-remnants"] = {
		flags = { "placeable-neutral", "not-on-map" },
		hidden_in_factoriopedia = true,
		subgroup = "defensive-structure-remnants",
		order = "a-f-a",
		selectable_in_game = false,
		time_before_removed = 60 * 60 * 15,
		expires = false,
		final_render_layer = "remnants",
		remove_on_tile_placement = false,
	},
	["artillery-wagon-remnants"] = {
		flags = { "placeable-neutral", "building-direction-8-way", "not-on-map" },
		hidden_in_factoriopedia = true,
		subgroup = "train-transport-remnants",
		order = "a-i-a",
		selectable_in_game = false,
		time_before_removed = 60 * 60 * 15,
		final_render_layer = "remnants",
		remove_on_tile_placement = false,
	},
	["assembling-machine-1-remnants"] = {
		hidden_in_factoriopedia = true,
		flags = { "placeable-neutral", "not-on-map" },
		subgroup = "production-machine-remnants",
		order = "a-a-a",
		selectable_in_game = false,
		time_before_removed = 60 * 60 * 15,
		expires = false,
		final_render_layer = "remnants",
	},
	["assembling-machine-2-remnants"] = {
		hidden_in_factoriopedia = true,
		flags = { "placeable-neutral", "not-on-map" },
		subgroup = "production-machine-remnants",
		order = "a-a-a",
		selectable_in_game = false,
		time_before_removed = 60 * 60 * 15,
		expires = false,
		final_render_layer = "remnants",
	},
	["assembling-machine-3-remnants"] = {
		flags = { "placeable-neutral", "not-on-map" },
		hidden_in_factoriopedia = true,
		subgroup = "production-machine-remnants",
		order = "a-a-a",
		selectable_in_game = false,
		time_before_removed = 60 * 60 * 15,
		expires = false,
		final_render_layer = "remnants",
	},
	["beacon-remnants"] = {
		flags = { "placeable-neutral", "not-on-map" },
		hidden_in_factoriopedia = true,
		subgroup = "energy-pipe-distribution-remnants",
		order = "a-d-a",
		selectable_in_game = false,
		time_before_removed = 60 * 60 * 15,
		expires = false,
		final_render_layer = "remnants",
		remove_on_tile_placement = false,
	},
	["big-electric-pole-remnants"] = {
		hidden_in_factoriopedia = true,
		flags = { "placeable-neutral", "not-on-map" },
		subgroup = "energy-pipe-distribution-remnants",
		order = "a-c-a",
		collision_box = { { -0.4, -0.4 }, { 0.4, 0.4 } },
		selectable_in_game = false,
		time_before_removed = 60 * 60 * 15,
		expires = false,
		final_render_layer = "remnants",
		animation_overlay_final_render_layer = "object",
		remove_on_tile_placement = false,
	},
	["boiler-remnants"] = {
		flags = { "placeable-neutral", "not-on-map" },
		hidden_in_factoriopedia = true,
		subgroup = "energy-remnants",
		order = "a-a-a",
		selectable_in_game = false,
		time_before_removed = 60 * 60 * 15,
		expires = false,
		final_render_layer = "remnants",
		remove_on_tile_placement = false,
	},
	["buffer-chest-remnants"] = {
		flags = { "placeable-neutral", "building-direction-8-way", "not-on-map" },
		hidden_in_factoriopedia = true,
		subgroup = "logistic-network-remnants",
		order = "a-f-a",
		selectable_in_game = false,
		time_before_removed = 60 * 60 * 15,
		expires = false,
		final_render_layer = "remnants",
		remove_on_tile_placement = false,
	},
	["bulk-inserter-remnants"] = {
		flags = { "placeable-neutral", "not-on-map" },
		hidden_in_factoriopedia = true,
		subgroup = "inserter-remnants",
		order = "a-f-a",
		selectable_in_game = false,
		time_before_removed = 60 * 60 * 15,
		expires = false,
		final_render_layer = "remnants",
		remove_on_tile_placement = false,
	},
	["burner-inserter-remnants"] = {
		hidden_in_factoriopedia = true,
		flags = { "placeable-neutral", "not-on-map" },
		subgroup = "inserter-remnants",
		order = "a-a-a",
		selectable_in_game = false,
		time_before_removed = 60 * 60 * 15,
		expires = false,
		final_render_layer = "remnants",
	},
	["cargo-wagon-remnants"] = {
		flags = { "placeable-neutral", "building-direction-8-way", "not-on-map" },
		hidden_in_factoriopedia = true,
		subgroup = "train-transport-remnants",
		order = "a-g-a",
		selectable_in_game = false,
		time_before_removed = 60 * 60 * 15,
		final_render_layer = "remnants",
		remove_on_tile_placement = false,
	},
	["centrifuge-remnants"] = {
		flags = { "placeable-neutral", "not-on-map" },
		hidden_in_factoriopedia = true,
		subgroup = "production-machine-remnants",
		order = "a-f-a",
		collision_box = { { -0.4, -0.4 }, { 0.4, 0.4 } },
		selectable_in_game = false,
		time_before_removed = 60 * 60 * 15,
		expires = false,
		final_render_layer = "remnants",
		remove_on_tile_placement = false,
	},
	["chemical-plant-remnants"] = {
		flags = { "placeable-neutral", "building-direction-8-way", "not-on-map" },
		hidden_in_factoriopedia = true,
		subgroup = "production-machine-remnants",
		order = "a-e-a",
		selectable_in_game = false,
		time_before_removed = 60 * 60 * 15,
		expires = false,
		final_render_layer = "remnants",
		remove_on_tile_placement = false,
	},
	["construction-robot-remnants"] = {
		flags = { "placeable-neutral", "not-on-map", "placeable-off-grid" },
		hidden_in_factoriopedia = true,
		selectable_in_game = false,
		subgroup = "remnants",
		order = "d[remnants]-a[generic]-a[small]",
		time_before_removed = 60 * 60 * 15,
		final_render_layer = "remnants",
		remove_on_tile_placement = false,
	},
	["defender-remnants"] = {
		flags = { "placeable-neutral", "not-on-map", "placeable-off-grid" },
		hidden_in_factoriopedia = true,
		selectable_in_game = false,
		subgroup = "remnants",
		order = "d[remnants]-a[generic]-a[small]",
		time_before_removed = 60 * 60 * 15,
		final_render_layer = "remnants",
		remove_on_tile_placement = false,
	},
	["electric-furnace-remnants"] = {
		flags = { "placeable-neutral", "building-direction-8-way", "not-on-map" },
		hidden_in_factoriopedia = true,
		subgroup = "smelting-machine-remnants",
		order = "a-a-a",
		selectable_in_game = false,
		time_before_removed = 60 * 60 * 15,
		expires = false,
		final_render_layer = "remnants",
		remove_on_tile_placement = false,
	},
	["electric-mining-drill-remnants"] = {
		flags = { "placeable-neutral", "not-on-map" },
		hidden_in_factoriopedia = true,
		subgroup = "extraction-machine-remnants",
		order = "a-a-a",
		selectable_in_game = false,
		time_before_removed = 60 * 60 * 15,
		expires = false,
		final_render_layer = "remnants",
		remove_on_tile_placement = false,
	},
	["fast-inserter-remnants"] = {
		hidden_in_factoriopedia = true,
		flags = { "placeable-neutral", "not-on-map" },
		subgroup = "inserter-remnants",
		order = "a-d-a",
		selectable_in_game = false,
		time_before_removed = 60 * 60 * 15,
		expires = false,
		final_render_layer = "remnants",
		remove_on_tile_placement = false,
	},
	["fluid-wagon-remnants"] = {
		flags = { "placeable-neutral", "building-direction-8-way", "not-on-map" },
		hidden_in_factoriopedia = true,
		subgroup = "train-transport-remnants",
		order = "a-h-a",
		selectable_in_game = false,
		time_before_removed = 60 * 60 * 15,
		final_render_layer = "remnants",
		remove_on_tile_placement = false,
	},
	["gate-remnants"] = {
		hidden_in_factoriopedia = true,
		flags = { "placeable-neutral", "not-on-map" },
		subgroup = "defensive-structure-remnants",
		order = "a-b-a",
		collision_box = { { -0.4, -0.4 }, { 0.4, 0.4 } },
		selectable_in_game = false,
		time_before_removed = 60 * 60 * 15,
		expires = false,
		final_render_layer = "remnants",
		remove_on_tile_placement = false,
	},
	["gun-turret-remnants"] = {
		flags = { "placeable-neutral", "not-on-map" },
		hidden_in_factoriopedia = true,
		subgroup = "defensive-structure-remnants",
		order = "a-c-a",
		selectable_in_game = false,
		time_before_removed = 60 * 60 * 15,
		expires = false,
		final_render_layer = "remnants",
		remove_on_tile_placement = false,
	},
	["heat-exchanger-remnants"] = {
		flags = { "placeable-neutral", "not-on-map" },
		hidden_in_factoriopedia = true,
		subgroup = "energy-remnants",
		order = "a-g-a",
		selectable_in_game = false,
		time_before_removed = 60 * 60 * 15,
		expires = false,
		final_render_layer = "remnants",
		remove_on_tile_placement = false,
	},
	["heat-pipe-remnants"] = {
		flags = { "placeable-neutral", "not-on-map" },
		hidden_in_factoriopedia = true,
		subgroup = "energy-remnants",
		order = "a-f-a",
		selectable_in_game = false,
		time_before_removed = 60 * 60 * 15,
		expires = false,
		final_render_layer = "remnants",
		remove_on_tile_placement = false,
	},
	["inserter-remnants"] = {
		hidden_in_factoriopedia = true,
		flags = { "placeable-neutral", "not-on-map" },
		subgroup = "inserter-remnants",
		order = "a-b-a",
		selectable_in_game = false,
		time_before_removed = 60 * 60 * 15,
		expires = false,
		final_render_layer = "remnants",
	},
	["lab-remnants"] = {
		flags = { "placeable-neutral", "not-on-map" },
		hidden_in_factoriopedia = true,
		subgroup = "production-machine-remnants",
		order = "a-g-a",
		selectable_in_game = false,
		time_before_removed = 60 * 60 * 15,
		expires = false,
		final_render_layer = "remnants",
		remove_on_tile_placement = false,
	},
	["laser-turret-remnants"] = {
		flags = { "placeable-neutral", "not-on-map" },
		hidden_in_factoriopedia = true,
		subgroup = "defensive-structure-remnants",
		order = "a-d-a",
		selectable_in_game = false,
		time_before_removed = 60 * 60 * 15,
		expires = false,
		final_render_layer = "remnants",
		remove_on_tile_placement = false,
	},
	["locomotive-remnants"] = {
		flags = { "placeable-neutral", "building-direction-8-way", "not-on-map" },
		hidden_in_factoriopedia = true,
		subgroup = "train-transport-remnants",
		order = "a-f-a",
		selectable_in_game = false,
		time_before_removed = 60 * 60 * 15,
		final_render_layer = "remnants",
		remove_on_tile_placement = false,
	},
	["logistic-robot-remnants"] = {
		flags = { "placeable-neutral", "not-on-map", "placeable-off-grid" },
		hidden_in_factoriopedia = true,
		selectable_in_game = false,
		subgroup = "remnants",
		order = "d[remnants]-a[generic]-a[small]",
		time_before_removed = 60 * 60 * 15,
		final_render_layer = "remnants",
		remove_on_tile_placement = false,
	},
	["long-handed-inserter-remnants"] = {
		hidden_in_factoriopedia = true,
		flags = { "placeable-neutral", "not-on-map" },
		subgroup = "inserter-remnants",
		order = "a-c-a",
		selectable_in_game = false,
		time_before_removed = 60 * 60 * 15,
		expires = false,
		final_render_layer = "remnants",
	},
	["medium-electric-pole-remnants"] = {
		hidden_in_factoriopedia = true,
		flags = { "placeable-neutral", "not-on-map" },
		subgroup = "energy-pipe-distribution-remnants",
		order = "a-b-a",
		collision_box = { { -0.4, -0.4 }, { 0.4, 0.4 } },
		selectable_in_game = false,
		time_before_removed = 60 * 60 * 15,
		expires = false,
		final_render_layer = "remnants",
		animation_overlay_final_render_layer = "object",
		remove_on_tile_placement = false,
	},
	["nuclear-reactor-remnants"] = {
		flags = { "placeable-neutral", "not-on-map" },
		hidden_in_factoriopedia = true,
		subgroup = "energy-remnants",
		order = "a-e-a",
		selectable_in_game = false,
		time_before_removed = 60 * 60 * 15,
		expires = false,
		final_render_layer = "remnants",
		remove_on_tile_placement = false,
	},
	["offshore-pump-remnants"] = {
		flags = { "placeable-neutral", "building-direction-8-way", "not-on-map" },
		hidden_in_factoriopedia = true,
		selectable_in_game = false,
		subgroup = "extraction-machine-remnants",
		order = "a-d-b",
		time_before_removed = 60 * 60 * 15,
		expires = false,
		final_render_layer = "remnants",
		remove_on_tile_placement = false,
	},
	["oil-refinery-remnants"] = {
		flags = { "placeable-neutral", "building-direction-8-way", "not-on-map" },
		hidden_in_factoriopedia = true,
		subgroup = "production-machine-remnants",
		order = "a-d-a",
		selectable_in_game = false,
		time_before_removed = 60 * 60 * 15,
		expires = false,
		final_render_layer = "remnants",
		remove_on_tile_placement = false,
	},
	["passive-provider-chest-remnants"] = {
		flags = { "placeable-neutral", "building-direction-8-way", "not-on-map" },
		hidden_in_factoriopedia = true,
		subgroup = "logistic-network-remnants",
		order = "a-d-a",
		selectable_in_game = false,
		time_before_removed = 60 * 60 * 15,
		expires = false,
		final_render_layer = "remnants",
		remove_on_tile_placement = false,
	},
	["pipe-remnants"] = {
		flags = { "placeable-neutral", "not-on-map" },
		hidden_in_factoriopedia = true,
		subgroup = "energy-pipe-distribution-remnants",
		order = "a-d-a",
		collision_box = { { -0.4, -0.4 }, { 0.4, 0.4 } },
		selectable_in_game = false,
		time_before_removed = 60 * 60 * 15,
		expires = false,
		final_render_layer = "remnants",
		remove_on_tile_placement = false,
	},
	["pipe-to-ground-remnants"] = {
		flags = { "placeable-neutral", "not-on-map" },
		hidden_in_factoriopedia = true,
		subgroup = "energy-pipe-distribution-remnants",
		order = "a-d-a",
		collision_box = { { -0.4, -0.4 }, { 0.4, 0.4 } },
		selectable_in_game = false,
		time_before_removed = 60 * 60 * 15,
		expires = false,
		final_render_layer = "remnants",
		remove_on_tile_placement = false,
	},
	["pump-remnants"] = {
		flags = { "placeable-neutral", "not-on-map" },
		hidden_in_factoriopedia = true,
		subgroup = "energy-pipe-distribution-remnants",
		order = "a-d-a",
		selectable_in_game = false,
		time_before_removed = 60 * 60 * 15,
		expires = false,
		final_render_layer = "remnants",
		remove_on_tile_placement = false,
	},
	["pumpjack-remnants"] = {
		flags = { "placeable-neutral", "building-direction-8-way", "not-on-map" },
		hidden_in_factoriopedia = true,
		subgroup = "extraction-machine-remnants",
		order = "a-d-a",
		selectable_in_game = false,
		time_before_removed = 60 * 60 * 15,
		expires = false,
		final_render_layer = "remnants",
		remove_on_tile_placement = false,
	},
	["radar-remnants"] = {
		flags = { "placeable-neutral", "not-on-map" },
		hidden_in_factoriopedia = true,
		subgroup = "defensive-structure-remnants",
		order = "a-g-a",
		selectable_in_game = false,
		time_before_removed = 60 * 60 * 15,
		expires = false,
		final_render_layer = "remnants",
		remove_on_tile_placement = false,
	},
	["requester-chest-remnants"] = {
		flags = { "placeable-neutral", "building-direction-8-way", "not-on-map" },
		hidden_in_factoriopedia = true,
		subgroup = "logistic-network-remnants",
		order = "a-g-a",
		selectable_in_game = false,
		time_before_removed = 60 * 60 * 15,
		expires = false,
		final_render_layer = "remnants",
		remove_on_tile_placement = false,
	},
	["roboport-remnants"] = {
		flags = { "placeable-neutral", "not-on-map" },
		hidden_in_factoriopedia = true,
		subgroup = "logistic-network-remnants",
		order = "a-h-a",
		selectable_in_game = false,
		time_before_removed = 60 * 60 * 15,
		expires = false,
		final_render_layer = "remnants",
		remove_on_tile_placement = false,
	},
	["solar-panel-remnants"] = {
		flags = { "placeable-neutral", "not-on-map" },
		hidden_in_factoriopedia = true,
		subgroup = "energy-remnants",
		order = "a-c-a",
		selectable_in_game = false,
		time_before_removed = 60 * 60 * 15,
		expires = false,
		final_render_layer = "remnants",
		remove_on_tile_placement = false,
	},
	["splitter-remnants"] = {
		hidden_in_factoriopedia = true,
		flags = { "placeable-neutral", "not-on-map" },
		subgroup = "belt-remnants",
		order = "a-g-a",
		selectable_in_game = false,
		time_before_removed = 60 * 60 * 15,
		expires = false,
		final_render_layer = "remnants",
		remove_on_tile_placement = false,
	},
	["steam-engine-remnants"] = {
		flags = { "placeable-neutral", "not-on-map" },
		hidden_in_factoriopedia = true,
		subgroup = "energy-remnants",
		order = "a-b-a",
		selectable_in_game = false,
		time_before_removed = 60 * 60 * 15,
		expires = false,
		final_render_layer = "remnants",
		remove_on_tile_placement = false,
	},
	["steam-turbine-remnants"] = {
		flags = { "placeable-neutral", "not-on-map" },
		hidden_in_factoriopedia = true,
		subgroup = "energy-remnants",
		order = "a-h-a",
		selectable_in_game = false,
		time_before_removed = 60 * 60 * 15,
		expires = false,
		final_render_layer = "remnants",
		remove_on_tile_placement = false,
	},
	["steel-furnace-remnants"] = {
		flags = { "placeable-neutral", "building-direction-8-way", "not-on-map" },
		hidden_in_factoriopedia = true,
		subgroup = "smelting-machine-remnants",
		order = "a-a-a",
		selectable_in_game = false,
		time_before_removed = 60 * 60 * 15,
		expires = false,
		final_render_layer = "remnants",
		remove_on_tile_placement = false,
	},
	["stone-furnace-remnants"] = {
		flags = { "placeable-neutral", "building-direction-8-way", "not-on-map" },
		hidden_in_factoriopedia = true,
		subgroup = "smelting-machine-remnants",
		order = "a-a-a",
		selectable_in_game = false,
		time_before_removed = 60 * 60 * 15,
		expires = false,
		final_render_layer = "remnants",
		remove_on_tile_placement = false,
	},
	["storage-chest-remnants"] = {
		flags = { "placeable-neutral", "building-direction-8-way", "not-on-map" },
		hidden_in_factoriopedia = true,
		subgroup = "logistic-network-remnants",
		order = "a-e-a",
		selectable_in_game = false,
		time_before_removed = 60 * 60 * 15,
		expires = false,
		final_render_layer = "remnants",
		remove_on_tile_placement = false,
	},
	["storage-tank-remnants"] = {
		flags = { "placeable-neutral", "building-direction-8-way", "not-on-map" },
		hidden_in_factoriopedia = true,
		subgroup = "storage-remnants",
		order = "a-d-a",
		selectable_in_game = false,
		time_before_removed = 60 * 60 * 15,
		expires = false,
		final_render_layer = "remnants",
		remove_on_tile_placement = false,
	},
	["substation-remnants"] = {
		flags = { "placeable-neutral", "not-on-map" },
		hidden_in_factoriopedia = true,
		subgroup = "energy-pipe-distribution-remnants",
		order = "a-d-a",
		collision_box = { { -0.4, -0.4 }, { 0.4, 0.4 } },
		selectable_in_game = false,
		time_before_removed = 60 * 60 * 15,
		expires = false,
		final_render_layer = "remnants",
		remove_on_tile_placement = false,
	},
	["tank-remnants"] = {
		flags = { "placeable-neutral", "building-direction-8-way", "not-on-map" },
		hidden_in_factoriopedia = true,
		subgroup = "transport-remnants",
		order = "a-k-a",
		selectable_in_game = false,
		time_before_removed = 60 * 60 * 15,
		final_render_layer = "remnants",
		remove_on_tile_placement = false,
	},
	["transport-belt-remnants"] = {
		hidden_in_factoriopedia = true,
		flags = { "placeable-neutral", "not-on-map" },
		subgroup = "belt-remnants",
		order = "a-a-a",
		selectable_in_game = false,
		time_before_removed = 60 * 60 * 15,
		expires = false,
		final_render_layer = "remnants",
	},
	["underground-belt-remnants"] = {
		hidden_in_factoriopedia = true,
		flags = { "placeable-neutral", "not-on-map", "building-direction-8-way" },
		subgroup = "belt-remnants",
		order = "a-d-a",
		selectable_in_game = false,
		time_before_removed = 60 * 60 * 15,
		expires = false,
		final_render_layer = "remnants",
		remove_on_tile_placement = false,
	},
	["wall-remnants"] = {
		hidden_in_factoriopedia = true,
		flags = { "placeable-neutral", "not-on-map" },
		subgroup = "defensive-structure-remnants",
		order = "a-a-a",
		collision_box = { { -0.4, -0.4 }, { 0.4, 0.4 } },
		selectable_in_game = false,
		time_before_removed = 60 * 60 * 15,
		expires = false,
		final_render_layer = "remnants",
		remove_on_tile_placement = false,
	},
}

---Gets the corpse of a sprite set with the given `artwork` and the other fields of the vanilla corpse with the given
---`name`.
---
---The corpse is given each field of the vanilla corpse other than its name, icon, size, and artwork, such as its flags,
---subgroup, and lifetime, and then each field of `artwork`.
---@param name BaseRemnantsID The name of the vanilla corpse.
---@param artwork CorpseSpriteSet The artwork of the corpse.
---@return CorpseSpriteSet # The corpse.
---
---#### Examples
---```lua
----- Get the corpse of a solar panel sprite set with the other fields of the vanilla solar panel remnants.
---local Remnants = require("__reskins-assets-api__.assets.base.remnants")
---
---local corpse = Remnants.get_corpse("solar-panel-remnants", { animation = animation })
----- `corpse` has the given `animation`, and the flags, subgroup, order, and lifetime of `solar-panel-remnants`.
---```
---@throws When `name` is not the name of a corpse that `assets.base.remnants` duplicates.
---@nodiscard
function M.get_corpse(name, artwork)
	local definition = definitions[name]
	if definition == nil then
		error(string.format("The corpse '%s' is not duplicated in 'assets.base.remnants'.", name))
	end

	local corpse = util.copy(definition)
	Corpses.apply_corpse_sprite_set(corpse, artwork)

	return corpse
end

return M
