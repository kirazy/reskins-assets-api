---@using data

---@namespace Reskins.Assets

local sounds = require("__base__.prototypes.entity.sounds")
local Corpses = require("api.corpses")

---Provides methods for building the death spiral of a flying robot from its sprite set, with the trigger effects,
---sounds, and particle fields that the base game uses for its own flying robots.
---
---#### Examples
---```lua
---local FlyingRobots = require("__reskins-assets-api__.api.flying-robots")
---```
---@class FlyingRobots
local _flying_robots = {}

-- The shift of the shadow of the falling robot.
local SHADOW_SHIFT = { -0.75, -0.40 }

-- The shift of the falling robot.
local ANIMATION_SHIFT = { 0, 0 }

---Gets a copy of the given rotated `animation` with each direction played as a frame, at the given `shift`.
---@param animation RotatedAnimation
---@param shift Vector
---@return Animation
local function get_falling_animation(animation, shift)
	local falling_animation = util.copy(animation)

	for _, layer in pairs(falling_animation.layers or { falling_animation }) do
		layer.frame_count = layer.direction_count
		layer.direction_count = nil
		layer.animation_speed = 1
		layer.shift = util.add_shift(layer.shift, shift)
	end

	return falling_animation
end

---Gets a copy of the given `animation` that plays backward.
---@param animation Animation
---@return Animation
local function get_reversed_animation(animation)
	local reversed_animation = util.copy(animation)

	for _, layer in pairs(reversed_animation.layers or { reversed_animation }) do
		layer.run_mode = "backward"
	end

	return reversed_animation
end

---Creates the dying particle of the given flying robot `prototype` from the given `set`, and sets the trigger effects
---that create it on `prototype`, in place.
---
---The particle is created as `ar-<robot name>-dying-particle` from the `in_motion` and `shadow_in_motion` of `set`. It
---falls, smokes, and sparks, then creates the corpse that the `corpse` of `set` gives the robot and plays the impact
---sound when it reaches the ground. The `dying_trigger_effect` of `prototype` creates the particle and plays the death
---sounds of the base game. The `destroy_action` of a combat robot does the same, and plays the self-destruct sound.
---@param prototype ConstructionRobotPrototype|LogisticRobotPrototype|CombatRobotPrototype The flying robot to which the sprite set is applied.
---@param set FlyingRobotSpriteSet The sprite set, which is scaled for `prototype`. When its `corpse` is `nil`, `prototype` is not modified.
function _flying_robots.apply_death_spiral(prototype, set)
	local corpse_name = Corpses.get_corpse_name(prototype, set.corpse)
	if corpse_name == nil then
		return
	end

	local particle_name = "ar-" .. prototype.name .. "-dying-particle"
	local animation = get_falling_animation(set.in_motion, ANIMATION_SHIFT)
	local shadow_animation = get_falling_animation(set.shadow_in_motion, SHADOW_SHIFT)

	data:extend({
		{
			type = "optimized-particle",
			name = particle_name,
			pictures = { animation, get_reversed_animation(animation) },
			shadows = { shadow_animation, get_reversed_animation(shadow_animation) },
			movement_modifier = 0.95,
			life_time = 1000,
			regular_trigger_effect_frequency = 2,
			regular_trigger_effect = {
				{
					type = "create-trivial-smoke",
					smoke_name = "smoke-fast",
					starting_frame_deviation = 5,
					probability = 0.5,
				},
				{
					type = "create-particle",
					particle_name = "spark-particle",
					tail_length = 10,
					tail_length_deviation = 5,
					tail_width = 5,
					probability = 0.2,
					initial_height = 0.2,
					initial_vertical_speed = 0.15,
					initial_vertical_speed_deviation = 0.05,
					speed_from_center = 0.1,
					speed_from_center_deviation = 0.05,
					offset_deviation = { { -0.25, -0.25 }, { 0.25, 0.25 } },
				},
			},
			ended_on_ground_trigger_effect = {
				{
					type = "create-entity",
					entity_name = corpse_name,
					offsets = { { 0, 0 } },
				},
				{
					type = "play-sound",
					sound = util.copy(sounds.robot_die_impact),
				},
			},
		},
	})

	prototype.dying_trigger_effect = {
		{
			type = "create-particle",
			particle_name = particle_name,
			initial_height = 1.8,
			initial_vertical_speed = 0,
			frame_speed = 1,
			frame_speed_deviation = 0.5,
			speed_from_center = 0,
			speed_from_center_deviation = 0.2,
			offset_deviation = { { -0.01, -0.01 }, { 0.01, 0.01 } },
			offsets = { { 0, 0.5 } },
		},
		{
			type = "play-sound",
			sound = util.copy(sounds.robot_die_whoosh),
		},
		{
			type = "play-sound",
			sound = util.copy(sounds.robot_die_vox),
		},
	}

	if prototype.type ~= "combat-robot" then
		return
	end

	---@cast prototype CombatRobotPrototype
	prototype.destroy_action = {
		type = "direct",
		action_delivery = {
			type = "instant",
			source_effects = {
				{
					type = "create-particle",
					particle_name = particle_name,
					initial_height = 1.8,
					initial_vertical_speed = 0,
					frame_speed = 0.5,
					frame_speed_deviation = 0.5,
					speed_from_center = 0,
					speed_from_center_deviation = 0.1,
					offset_deviation = { { -0.01, -0.01 }, { 0.01, 0.01 } },
					offsets = { { 0, 0.5 } },
				},
				{
					type = "play-sound",
					sound = util.copy(sounds.robot_die_whoosh),
				},
				{
					type = "play-sound",
					sound = util.copy(sounds.robot_die_vox),
				},
				{
					type = "play-sound",
					sound = util.copy(sounds.robot_selfdestruct),
				},
			},
		},
	}
end

return _flying_robots
