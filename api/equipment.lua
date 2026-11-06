---@using data
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets

local _defines = require("api.defines")
local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")

---Provides methods for creating the functions that get the sprite sets of equipment.
---
---#### Examples
---```lua
---local Equipment = require("__reskins-assets-api__.api.equipment")
---```
---@class Equipment
local _equipment = {}

-- The size of a cell in the equipment grid, in pixels of artwork drawn at a scale of 0.5.
local CELL_SIZE = 64

---Defines the artwork for a piece of equipment.
---@class EquipmentArtwork
---The path to the folder of the artwork, such as `__reskins-assets-base__/graphics/equipment/equipment-battery`. The
---name of the folder is the stem of the file names, such as `equipment-battery` in `equipment-battery-base.png`.
---@field folder string
---The width of the files, in pixels.
---@field width SpriteSizeType
---The height of the files, in pixels.
---@field height SpriteSizeType

---Defines the artwork in one file for a piece of equipment.
---@class FlatEquipmentArtwork
---The path to the file of the artwork.
---@field filename FileName
---The width of the file, in pixels.
---@field width SpriteSizeType
---The height of the file, in pixels.
---@field height SpriteSizeType

---Defines the options for the sprite set for a piece of equipment.
---@class EquipmentSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color

---Defines the options for the sprite set for a piece of equipment with a base layer for each tier.
---@class TieredEquipmentSpriteSetParams
---The tier of the equipment, which selects its base layer.
---@field tier 1|2|3|4
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color

local EquipmentArtwork = V.struct({
	folder = Common.non_empty_string,
	width = Common.sprite_size,
	height = Common.sprite_size,
}):describe_as("an EquipmentArtwork")

local FlatEquipmentArtwork = V.struct({
	filename = Common.non_empty_string,
	width = Common.sprite_size,
	height = Common.sprite_size,
}):describe_as("a FlatEquipmentArtwork")

---Gets a layer of the sprite for a piece of equipment.
---@param filename FileName
---@param artwork EquipmentArtwork|FlatEquipmentArtwork
---@return Sprite
local function get_layer(filename, artwork)
	---@type Sprite
	return {
		filename = filename,
		width = artwork.width,
		height = artwork.height,
		priority = "medium",
		flags = { "no-crop" },
		scale = 0.5,
	}
end

---Gets the sprite set with the given `sprite`, drawn for the given `artwork`.
---@param sprite Sprite
---@param artwork EquipmentArtwork|FlatEquipmentArtwork
---@return SpriteSetDefinition<EquipmentSpriteSet>
local function get_sprite_set(sprite, artwork)
	---@type SpriteSetDefinition<EquipmentSpriteSet>
	return {
		set_type = _defines.sprite_set_type.equipment_sprite_set,
		set = {
			sprite = sprite,
			nominal_width = artwork.width / CELL_SIZE,
			nominal_height = artwork.height / CELL_SIZE,
		},
	}
end

---Gets the sprite for a piece of equipment with a base layer, and with a mask and a highlights layer when `tint` is
---given.
---@param artwork EquipmentArtwork The artwork of the equipment.
---@param base_stem string The stem of the file name for the base layer.
---@param tint? Color The color to tint the mask layer.
---@return Sprite
local function get_tinted_sprite(artwork, base_stem, tint)
	local folder = artwork.folder:gsub("/$", "")
	local stem = folder:match("[^/]+$") --[[@as string]]

	local layers = { get_layer(folder .. "/" .. base_stem .. "-base.png", artwork) }

	if tint then
		local mask = get_layer(folder .. "/" .. stem .. "-mask.png", artwork)
		mask.tint = tint

		local highlights = get_layer(folder .. "/" .. stem .. "-highlights.png", artwork)
		highlights.blend_mode = "additive"

		layers[#layers + 1] = mask
		layers[#layers + 1] = highlights
	end

	---@type Sprite
	return { layers = layers }
end

local check_tinted = V.signature("tinted", {
	{ "artwork", EquipmentArtwork },
	{ "creator_name", Common.non_empty_string },
})

---Creates a function that gets the sprite set of the equipment with the given `artwork`, which has a `base`, a `mask`,
---and a `highlights` layer.
---
---The files of the layers are `{folder}/{stem}-base.png`, `{stem}-mask.png`, and `{stem}-highlights.png`. The mask and
---highlights layers are omitted when the `tint` parameter is not given.
---@param artwork EquipmentArtwork The artwork of the equipment.
---@param creator_name string The name of the function in error messages.
---@return fun(params?: EquipmentSpriteSetParams): SpriteSetDefinition<EquipmentSpriteSet> # The function.
---@throws When `artwork` is not a valid `EquipmentArtwork`.
---@throws When `creator_name` is `nil` or an empty string.
---@nodiscard
function _equipment.tinted(artwork, creator_name)
	check_tinted(artwork, creator_name)

	local stem = artwork.folder:gsub("/$", ""):match("[^/]+$") --[[@as string]]
	local check = V.signature(creator_name, {
		{
			"params",
			V.struct({ tint = Common.color:optional() }):strict():describe_as("an EquipmentSpriteSetParams"):optional(),
		},
	})

	return function(params)
		check(params)

		local tint = params and params.tint

		return get_sprite_set(get_tinted_sprite(artwork, stem, tint), artwork)
	end
end

local check_tiered = V.signature("tiered", {
	{ "artwork", EquipmentArtwork },
	{ "creator_name", Common.non_empty_string },
})

---Creates a function that gets the sprite set of the equipment with the given `artwork`, which has a `base` layer for
---each tier, and a `mask` and a `highlights` layer.
---
---The files of the layers are `{folder}/{stem}-{tier}-base.png`, `{stem}-mask.png`, and `{stem}-highlights.png`. The
---mask and highlights layers are omitted when the `tint` parameter is not given.
---@param artwork EquipmentArtwork The artwork of the equipment.
---@param creator_name string The name of the function in error messages.
---@return fun(params: TieredEquipmentSpriteSetParams): SpriteSetDefinition<EquipmentSpriteSet> # The function.
---@throws When `artwork` is not a valid `EquipmentArtwork`.
---@throws When `creator_name` is `nil` or an empty string.
---@nodiscard
function _equipment.tiered(artwork, creator_name)
	check_tiered(artwork, creator_name)

	local stem = artwork.folder:gsub("/$", ""):match("[^/]+$") --[[@as string]]
	local check = V.signature(creator_name, {
		{
			"params",
			V.struct({
				tier = V.one_of({ 1, 2, 3, 4 }),
				tint = Common.color:optional(),
			})
				:strict()
				:describe_as("a TieredEquipmentSpriteSetParams"),
		},
	})

	return function(params)
		check(params)

		return get_sprite_set(get_tinted_sprite(artwork, stem .. "-" .. params.tier, params.tint), artwork)
	end
end

local check_flat = V.signature("flat", {
	{ "artwork", FlatEquipmentArtwork },
	{ "creator_name", Common.non_empty_string },
})

---Creates a function that gets the sprite set of the equipment with the given `artwork`, which is drawn in one file
---that is not tinted.
---@param artwork FlatEquipmentArtwork The artwork of the equipment.
---@param creator_name string The name of the function in error messages.
---@return fun(params?: {}): SpriteSetDefinition<EquipmentSpriteSet> # The function.
---@throws When `artwork` is not a valid `FlatEquipmentArtwork`.
---@throws When `creator_name` is `nil` or an empty string.
---@nodiscard
function _equipment.flat(artwork, creator_name)
	check_flat(artwork, creator_name)

	local check = V.signature(creator_name, {
		{ "params", V.struct({}):strict():describe_as("the parameters of the sprite set"):optional() },
	})

	return function(params)
		check(params)

		local sprite = get_layer(artwork.filename, artwork)
		sprite.flags = nil

		return get_sprite_set(sprite, artwork)
	end
end

return _equipment
