---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Bobs.Entities

local _defines = require("api.defines")
local V = require("__reskins-sprite-utils__.validation")

local FOLDER = _defines.assets_source.bobs_assets .. "/graphics/entity/ores/"

---A solid resource that has stages in the ores folder.
---@alias OreResource "bauxite-ore"|"cobalt-ore"|"gold-ore"|"lead-ore"|"nickel-ore"|"quartz"|"rutile-ore"|"silver-ore"|"sulfur"|"thorium-ore"|"tin-ore"|"tungsten-ore"|"zinc-ore"

---A solid resource that has a glow in the ores folder.
---@alias GlowingOreResource "thorium-ore"

---A fluid resource that has stages in the ores folder.
---@alias FluidResource "ground-water"|"lithia-water"

---@type OreResource[]
local ORES = {
	"bauxite-ore",
	"cobalt-ore",
	"gold-ore",
	"lead-ore",
	"nickel-ore",
	"quartz",
	"rutile-ore",
	"silver-ore",
	"sulfur",
	"thorium-ore",
	"tin-ore",
	"tungsten-ore",
	"zinc-ore",
}

---@type GlowingOreResource[]
local GLOWING_ORES = { "thorium-ore" }

---@type FluidResource[]
local FLUIDS = { "ground-water", "lithia-water" }

---Provides methods for getting the stages of the resources in the ores folder, `ores/{resource}/{resource}.png`.
---
---#### Examples
---```lua
---local OreStages = require("__reskins-assets-api__.assets.bobs.entities.ores")
---```
---@class OreStages
local M = {}

---Defines the options for the stages of a solid resource in the ores folder.
---@class OreStagesParams
---The resource drawn by the stages.
---@field ore OreResource

local check_get_stages = V.signature("get_stages", {
	{ "params", V.struct({ ore = V.one_of(ORES) }):strict():describe_as("an OreStagesParams") },
})

---Gets the stages for the given solid resource `params.ore`, 8 variations of 8 stages each.
---@param params OreStagesParams The options for the stages.
---@return AnimationVariations # The stages.
---
---#### Examples
---```lua
----- Set the stages of the lead ore.
---local OreStages = require("__reskins-assets-api__.assets.bobs.entities.ores")
---
---data.raw["resource"]["bob-lead-ore"].stages = OreStages.get_stages({ ore = "lead-ore" })
---```
---@throws When `params.ore` is not an `OreResource`.
---@nodiscard
function M.get_stages(params)
	check_get_stages(params)

	---@type AnimationVariations
	local stages = {
		sheet = {
			filename = FOLDER .. params.ore .. "/" .. params.ore .. ".png",
			priority = "extra-high",
			size = 128,
			frame_count = 8,
			variation_count = 8,
			scale = 0.5,
		},
	}

	return stages
end

---Defines the options for the glow of a solid resource in the ores folder.
---@class OreStagesEffectParams
---The resource drawn by the glow.
---@field ore GlowingOreResource

local check_get_stages_effect = V.signature("get_stages_effect", {
	{ "params", V.struct({ ore = V.one_of(GLOWING_ORES) }):strict():describe_as("an OreStagesEffectParams") },
})

---Gets the glow for the given solid resource `params.ore`, drawn as a light over its stages, 8 variations of 8 stages
---each.
---@param params OreStagesEffectParams The options for the glow.
---@return AnimationVariations # The glow.
---
---#### Examples
---```lua
----- Set the glow of the thorium ore.
---local OreStages = require("__reskins-assets-api__.assets.bobs.entities.ores")
---
---data.raw["resource"]["bob-thorium-ore"].stages_effect = OreStages.get_stages_effect({ ore = "thorium-ore" })
---```
---@throws When `params.ore` is not a `GlowingOreResource`.
---@nodiscard
function M.get_stages_effect(params)
	check_get_stages_effect(params)

	---@type AnimationVariations
	local stages_effect = {
		sheet = {
			filename = FOLDER .. params.ore .. "/" .. params.ore .. "-glow.png",
			priority = "extra-high",
			size = 128,
			frame_count = 8,
			variation_count = 8,
			scale = 0.5,
			blend_mode = "additive",
			flags = { "light" },
		},
	}

	return stages_effect
end

---Defines the options for the stages of a fluid resource in the ores folder.
---@class FluidResourceStagesParams
---The resource drawn by the stages.
---@field fluid FluidResource

local check_get_fluid_stages = V.signature("get_fluid_stages", {
	{ "params", V.struct({ fluid = V.one_of(FLUIDS) }):strict():describe_as("a FluidResourceStagesParams") },
})

---Gets the stages for the given fluid resource `params.fluid`, one variation of 4 stages.
---@param params FluidResourceStagesParams The options for the stages.
---@return AnimationVariations # The stages.
---
---#### Examples
---```lua
----- Set the stages of the ground water.
---local OreStages = require("__reskins-assets-api__.assets.bobs.entities.ores")
---
---data.raw["resource"]["bob-ground-water"].stages = OreStages.get_fluid_stages({ fluid = "ground-water" })
---```
---@throws When `params.fluid` is not a `FluidResource`.
---@nodiscard
function M.get_fluid_stages(params)
	check_get_fluid_stages(params)

	---@type AnimationVariations
	local stages = {
		sheet = {
			filename = FOLDER .. params.fluid .. "/" .. params.fluid .. ".png",
			priority = "extra-high",
			width = 148,
			height = 120,
			frame_count = 4,
			variation_count = 1,
			shift = util.by_pixel(0, -2),
			scale = 0.5,
		},
	}

	return stages
end

return M
