---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators

---@namespace Reskins.Assets.Converters

---Transforms a `BoilerSpriteSet` into a `CraftingMachineSpriteSet`.
---
---Objects are assigned directly and are not copied.
---@param sprite_set BoilerSpriteSet The sprite set to convert.
---@return CraftingMachineSpriteSet # `sprite_set` as a crafting machine sprite set.
local function boiler_to_crafting_machine_sprite_set_transformer(sprite_set)
	---@type CraftingMachineGraphicsSet
	local graphics_set = {
		animation = {
			north = sprite_set.pictures.north.structure,
			east = sprite_set.pictures.east.structure,
			south = sprite_set.pictures.south.structure,
			west = sprite_set.pictures.west.structure,
		},
		working_visualisations = {
			{
				always_draw = true,
				north_animation = sprite_set.pictures.north.patch --[[@as Animation?]], -- A sprite is a subset of an animation.
				east_animation = sprite_set.pictures.east.patch --[[@as Animation?]], -- A sprite is a subset of an animation.
				south_animation = sprite_set.pictures.south.patch --[[@as Animation?]], -- A sprite is a subset of an animation.
				west_animation = sprite_set.pictures.west.patch --[[@as Animation?]], -- A sprite is a subset of an animation.
				render_layer = "higher-object-under",
			},
			{
				fadeout = true,
				effect = sprite_set.fire_glow_flicker_enabled ~= false and "flicker" or "uranium-glow",
				north_animation = sprite_set.pictures.north.fire_glow,
				east_animation = sprite_set.pictures.east.fire_glow,
				south_animation = sprite_set.pictures.south.fire_glow,
				west_animation = sprite_set.pictures.west.fire_glow,
			},
			{
				fadeout = true,
				effect = sprite_set.fire_flicker_enabled ~= false and "flicker" or "uranium-glow",
				north_animation = sprite_set.pictures.north.fire,
				east_animation = sprite_set.pictures.east.fire,
				south_animation = sprite_set.pictures.south.fire,
				west_animation = sprite_set.pictures.west.fire,
			},
		},
	}

	---@type CraftingMachineSpriteSet
	local out_value = {
		graphics_set = graphics_set,
		fluid_boxes = sprite_set.fluid_boxes,
		nominal_height = sprite_set.nominal_height,
		nominal_width = sprite_set.nominal_width,
		integration_patch = sprite_set.integration_patch,
		integration_patch_render_layer = sprite_set.integration_patch_render_layer,
		dying_explosion = sprite_set.dying_explosion,
		corpse = sprite_set.corpse,
		water_reflection = sprite_set.water_reflection,
	}

	return out_value
end

---@type SpriteSetTransformer<BoilerSpriteSet, CraftingMachineSpriteSet>
return boiler_to_crafting_machine_sprite_set_transformer
