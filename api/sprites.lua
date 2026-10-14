---@using data

---@namespace Reskins.Assets

---Provides methods for manipulating sprites specific to Artisanal Reskins.
---
---#### Examples
---```lua
---local sprites_api = require("__reskins-assets-api__.api.sprites")
---```
---@class Sprites
local _sprites = {}

local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")
local AssetsCommon = require("api.validation")

local check_get_sprite_light_layer = V.signature("get_sprite_light_layer", {
	{ "light_name", AssetsCommon.light },
	{ "tint", Common.color:optional() },
})

---Gets the light sprite for the given `light_name`.
---@param light_name Light The name of the light artwork used to create the light layer.
---@param tint? Color The tint of the light layer.
---@return Sprite # A `Sprite` object configured for use as a light layer.
---
---#### Examples
---```lua
----- Create a blue light layer for a projectile.
---local sprites_api = require("__reskins-assets-api__.api.sprites")
---
---local sprite = sprites_api.get_sprite_light_layer("aura-projectile", util.color("#1280b2"))
----- sprite.filename is "__reskins-assets-api__/graphics/icons/lights/aura-projectile-light.png".
---```
---@throws When `light_name` is not a light name.
---@throws When `tint` is not a `Color`.
---@see Reskins.SpriteUtils.IconComposition.add_light
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

---Creates a `SpriteVariations` from the `num_variations` files with the given `sprite_name` in the given `directory`.
---
---The first file is named `{sprite_name}.png`, and each file after it is named `{sprite_name}-#.png`, where `#` counts
---the files following the first.
---
---For example, five variations are `shot.png`, `shot-1.png`, `shot-2.png`, `shot-3.png`, `shot-4.png`.
---
---When `is_light` is `true`, each variation has a second layer from the same file, which is drawn as a light and
---tinted with `tint`.
---
---#### Parameters
---@param directory string The path of the directory that contains the files, with or without a trailing slash.
---@param sprite_name string The name of the files, without the number or the extension.
---@param num_variations integer The number of sprites, which is the number of files.
---@param is_light? boolean When `true`, indicates that each variation includes a light layer. Default `false`.
---@param tint? Color The tint of the light layer, which is used only when `is_light` is `true`. Default `{ r = 0.3, g = 0.3, b = 0.3, a = 0.3 }`.
---
---#### Returns
---@return SpriteVariations # One sprite for each file, in the order of the files.
---
---#### Examples
---```lua
----- Create a `SpriteVariations` of the five shot sprites.
---local sprites_api = require("__reskins-assets-api__.api.sprites")
---
---local pictures = sprites_api.create_sprite_variations("__reskins-assets-bobs__/graphics/icons/shot", "shot", 5)
----- pictures[1] uses shot.png, and pictures[5] uses shot-4.png.
---```
---@throws When `directory` is `nil` or an empty string.
---@throws When `sprite_name` is `nil` or an empty string.
---@throws When `num_variations` is not a positive integer.
---@throws When `is_light` is not a boolean.
---@throws When `tint` is not a `Color`.
---@nodiscard
function _sprites.create_sprite_variations(directory, sprite_name, num_variations, is_light, tint)
	check_create_sprite_variations(directory, sprite_name, num_variations, is_light, tint)

	if not directory:match("/$") then
		directory = directory .. "/"
	end

	---@type Sprite[]
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
