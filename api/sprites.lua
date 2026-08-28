---@using data

---@namespace Reskins.Assets

---Provides methods for manipulating sprites specific to Artisanal Reskins.
---
---### Examples
---```lua
---local sprites_api = require("__reskins-assets-api__.api.sprites")
---```
---@class Sprites
local _sprites = {}

local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")

---@alias LightSpriteNames
--- | "atomic-artillery-shell" The name of the sprite for a radioactive atomic artillery shell.
--- | "aura-bullet"            The name of the sprite for a bullet with a glowing aura.
--- | "aura-projectile"        The name of the sprite for a projectile component with a glowing aura.
--- | "aura-rocket"            The name of the sprite for a rocket with a glowing aura.
--- | "aura-shotgun-shell"     The name of the sprite for a shotgun shell with a glowing aura.
--- | "aura-warhead"           The name of the sprite for a warhead with a glowing aura.
--- | "electric-bullet"        The name of the sprite for an electric bullet.
--- | "electric-projectile"    The name of the sprite for an electric projectile component.
--- | "electric-rocket"        The name of the sprite for an electric rocket.
--- | "electric-shotgun-shell" The name of the sprite for an electric shotgun shell.
--- | "electric-warhead"       The name of the sprite for an electric warhead.
--- | "fuel"                   The name of the sprite for a fuel item, such as nuclear fuel.
--- | "fuel-cell"              The name of the sprite for a reactor fuel cell.
--- | "laser-rifle-battery"    The name of the sprite for a laser rifle battery.
--- | "rocket"                 The name of the sprite for a rocket, such as a uranium-tipped rocket.
--- | "rounds-magazine"        The name of the sprite for a magazine, such as uranium rounds.

local LightSpriteName = V.one_of({
	"atomic-artillery-shell",
	"aura-bullet",
	"aura-projectile",
	"aura-rocket",
	"aura-shotgun-shell",
	"aura-warhead",
	"electric-bullet",
	"electric-projectile",
	"electric-rocket",
	"electric-shotgun-shell",
	"electric-warhead",
	"fuel",
	"fuel-cell",
	"laser-rifle-battery",
	"rocket",
	"rounds-magazine",
}):describe_as("a light sprite name")

local check_get_sprite_light_layer = V.signature("get_sprite_light_layer", {
	{ "light_name", LightSpriteName },
	{ "tint", Common.color:optional() },
})

---
---Creates a `Sprite` object configured for use as a light layer for the given `light_type`,
---with the given `tint`.
---
---### Examples
---```lua
----- Gets a light layer for an projectile with a blue tint.
---local sprite = sprites.get_sprite_light_layer("aura-projectile", util.color("#1280b2"))
---```
---
---### Parameters
---@param light_name LightSpriteNames # The name of the light sprite used to create the light layer.
---@param tint? Color # The tint of the light layer. Default `nil`.
---### Returns
---@return Sprite # A `Sprite` object configured for use as a light layer.
---
---### Exceptions
---*@throws* `string` — Thrown when `light_name` is not the name of a light sprite.\
---*@throws* `string` — Thrown when `tint` is not a `Color`.
---@nodiscard
function _sprites.get_sprite_light_layer(light_name, tint)
	check_get_sprite_light_layer(light_name, tint)

	---@type Sprite
	local sprite = {
		flags = { "light", "icon" },
		draw_as_light = true,
		filename = "__reskins-assets-api__/graphics/icons/lights/" .. light_name .. "-light.png",
		size = 64,
		mipmap_count = 4,
		scale = 0.5,
		tint = tint,
	}

	return sprite
end

local check_create_sprite_variations = V.signature("create_sprite_variations", {
	{ "directory", Common.non_empty_string },
	{ "sprite_name", Common.non_empty_string },
	{ "num_variations", Common.positive_integer },
	{ "is_light", V.boolean():optional() },
	{ "tint", Common.color:optional() },
})

---
---Creates a `SpriteVariations` object with `num_variations` using the the sprite variations
---in the given `directory` and with the given `sprite_name`.
---Provide a `tint` to include a light layer.
---
---### Examples
---```lua
----- Create 5 sprite variations for the "shot" item in Bob's Warfare mod.
---local folder_path = "__reskins-bobs__/graphics/icons/warfare/components/shot"
---
---local sprite_variations = sprites.create_sprite_variations(folder_path, "shot", 5)
---```
---
---### Remarks
---The first image is named `{sprite_name}.png`, and each image after it is named
---`{sprite_name}-#.png`, where `#` counts the images following the first.
---
---For example, five variations are `shot.png`, `shot-1.png`, `shot-2.png`, `shot-3.png`, `shot-4.png`.
---
---### Parameters
---@param directory string # The path to the directory containing the sprite variations, with-or-without trailing forward slash.
---@param sprite_name string # The name of the sprite variations, without number or extensions, e.g. `{sprite_name}.png` or `{sprite_name}-#.png`.
---@param num_variations integer # The number of sprite variations; this must match the number of files.
---@param is_light? boolean # Whether the sprite variations include a light layer. Defaults to `false`.
---@param tint? Color # The tint of the light layer. Defaults to `{ r = 0.3, g = 0.3, b = 0.3, a = 0.3 }`.
---### Returns
---@return SpriteVariations[] # The `SpriteVariations` object for the given parameters.
---
---### Exceptions
---*@throws* `string` — Thrown when `directory` is not a non-empty string.\
---*@throws* `string` — Thrown when `sprite_name` is not a non-empty string.\
---*@throws* `string` — Thrown when `num_variations` is not a positive integer.\
---*@throws* `string` — Thrown when `is_light` is not a boolean.\
---*@throws* `string` — Thrown when `tint` is not a `Color`.
---@nodiscard
function _sprites.create_sprite_variations(directory, sprite_name, num_variations, is_light, tint)
	check_create_sprite_variations(directory, sprite_name, num_variations, is_light, tint)

	if not directory:match("/$") then
		directory = directory .. "/"
	end

	---@type SpriteVariations[]
	local sprites = {}
	for n = 1, num_variations do
		local file_name = sprite_name .. ((n > 1) and ("-" .. (n - 1) .. ".png") or ".png")

		if is_light then
			---@type Sprite
			local sprite = {
				layers = {
					{
						filename = directory .. file_name,
						flags = { "icon" },
						size = 64,
						mipmap_count = 4,
						scale = 0.5,
					},
					{
						filename = directory .. file_name,
						flags = { "icon" },
						size = 64,
						tint = tint or { r = 0.3, g = 0.3, b = 0.3, a = 0.3 },
						mipmap_count = 4,
						scale = 0.5,
						draw_as_light = true,
						blend_mode = "additive",
					},
				},
			}

			table.insert(sprites, sprite)
		else
			---@type Sprite
			local sprite = {
				filename = directory .. file_name,
				flags = { "icon" },
				size = 64,
				mipmap_count = 4,
				scale = 0.5,
			}

			table.insert(sprites, sprite)
		end
	end

	return sprites
end

return _sprites
