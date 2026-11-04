---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Bobs.Entities

local V = require("__reskins-sprite-utils__.validation")

local ASSETS_BOBS_PATH = "__reskins-assets-bobs__/graphics/entity/robot-capsules/"

local M = {}

---The combat robot released by a capsule, which selects the artwork of the capsule.
---@alias RobotCapsuleRobot "defender"|"distractor"|"destroyer"|"laser-robot"

local RobotCapsuleRobot = V.one_of({ "defender", "distractor", "destroyer", "laser-robot" })

---Defines the projectile graphics of a combat robot capsule.
---@class (exact) RobotCapsuleProjectileGraphics
---The animation of the projectile.
---
---See [ProjectilePrototype::animation](https://lua-api.factorio.com/latest/prototypes/ProjectilePrototype.html#animation).
---@field animation RotatedAnimationVariations
---The shadow of the projectile.
---
---See [ProjectilePrototype::shadow](https://lua-api.factorio.com/latest/prototypes/ProjectilePrototype.html#shadow).
---@field shadow RotatedAnimationVariations

---Defines the options for the projectile graphics of a combat robot capsule.
---@class RobotCapsuleProjectileGraphicsParams
---The combat robot released by the capsule, which selects its artwork.
---@field robot RobotCapsuleRobot

local check_get_projectile_graphics = V.signature("get_projectile_graphics", {
	{
		"params",
		V.class("RobotCapsuleProjectileGraphicsParams", {
			robot = RobotCapsuleRobot,
		}):strict(),
	},
})

---Gets the projectile graphics of the capsule that releases the given `params.robot`.
---
---Every capsule casts the same shadow.
---@param params RobotCapsuleProjectileGraphicsParams The options for the graphics.
---@return RobotCapsuleProjectileGraphics # The animation and the shadow of the projectile.
---
---#### Examples
---```lua
----- Reskin the projectile of the defender capsule.
---local robot_capsules = require("__reskins-assets-api__.assets.bobs.entities.robot-capsules")
---
---local projectile = data.raw["projectile"]["defender-capsule"]
---local graphics = robot_capsules.get_projectile_graphics({ robot = "defender" })
---projectile.animation = graphics.animation
---projectile.shadow = graphics.shadow
---```
---@throws When `params` defines an unrecognized field.
---@throws When `params.robot` is not one of `"defender"`, `"distractor"`, `"destroyer"`, or `"laser-robot"`.
---@nodiscard
function M.get_projectile_graphics(params)
	check_get_projectile_graphics(params)

	---@type RobotCapsuleProjectileGraphics
	local graphics = {
		animation = {
			filename = ASSETS_BOBS_PATH .. params.robot .. "-capsule.png",
			priority = "high",
			flags = { "no-crop" },
			size = 48,
			scale = 0.5,
		},
		shadow = {
			filename = ASSETS_BOBS_PATH .. "combat-robot-capsule-shadow.png",
			priority = "high",
			flags = { "no-crop" },
			size = 48,
			scale = 0.5,
		},
	}

	return graphics
end

return M
