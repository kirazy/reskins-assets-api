---@using data

---@namespace Reskins.Assets

---The type name of an [EntityWithHealthPrototype](https://lua-api.factorio.com/latest/prototypes/EntityWithHealthPrototype.html).
---@alias PrototypeType string

---@alias SpriteSetTransformer<TIn : SpriteSetBase, TOut : SpriteSetBase> fun(sprite_set: TIn): TOut
---@alias AnySpriteSetTransformer SpriteSetTransformer<any, any>

---Options for `apply_sprite_set`. Every field is optional.
---@class (exact) ApplySpriteSetParams
---The desired resulting sprite scale, relative to the baseline of `0.5`. Overrides automatic
---scaling. Ignored if `scale_factor` is also set.
---@field scale double?
---An explicit scale multiplier multiplied against the nominal scale.
---
---Overrides both `scale` and automatic scaling.
---@field scale_factor double?

---The fields every sprite set shares, regardless of the prototype kind it paints.
---@class (exact) SpriteSetBase
---The sprite's design width, in tiles. Used for scaling.
---@field nominal_width double
---The sprite's design height, in tiles. Used for scaling.
---@field nominal_height double

---The fields shared by sprite sets for `EntityWithHealthPrototype` entities, applied the same way
---by every applicator.
---@class (exact) EntityWithHealthSpriteSet : SpriteSetBase
---The prototype's `integration_patch`.
---@field integration_patch Sprite4Way?
---The prototype's `integration_patch_render_layer`.
---@field integration_patch_render_layer RenderLayer?
---The death explosion art of the entity, applied by `SpriteSetApplicator.apply_to_explosion`.
---@field dying_explosion any
---The remnant art of the entity. Applied when the sprite set is applied to a `CorpsePrototype`;
---not applied to the entity itself.
---@field corpse CorpseSpriteSet?
---The prototype's `water_reflection`.
---@field water_reflection WaterReflectionDefinition?

---@class (exact) CorpseSpriteSet
---@field animation RotatedAnimationVariations?
---@field animation_overlay RotatedAnimationVariations?
---@field animation_overlay_render_layer RenderLayer?
---@field animation_render_layer RenderLayer?
---@field decay_animation RotatedAnimationVariations?
---@field decay_frame_transition_duration float?
---@field direction_shuffle? ((uint16)[])[]
---@field dying_speed? float
---@field final_render_layer RenderLayer?
---@field ground_patch? AnimationVariations
---@field ground_patch_decay? AnimationVariations
---@field ground_patch_fade_in_delay? float
---@field ground_patch_fade_in_speed? float
---@field ground_patch_fade_out_duration? float
---@field ground_patch_fade_out_start? float
---@field ground_patch_higher? AnimationVariations
---@field ground_patch_render_layer? RenderLayer
---@field shuffle_directions_at_frame? uint8
---@field splash? AnimationVariations
---@field splash_render_layer? RenderLayer
---@field splash_speed? float
---@field underwater_layer_offset? int8
---@field underwater_patch? RotatedSprite

---A sprite set with its `SpriteSetType`, which selects the applicator that applies it.
---
---#### Examples
---```lua
---local _defines = require("__reskins-assets-api__.api.defines")
---
------@type SpriteSetDefinition<CraftingMachineSpriteSet>
---local sprites = {
---    set_type = _defines.sprite_set_type.crafting_machine_sprite_set,
---    set = { graphics_set = graphics_set },
---}
---```
---@class (exact) SpriteSetDefinition<TSet : SpriteSetBase>
---The `SpriteSetType` of `set`.
---@field set_type SpriteSetType
---The sprite data itself.
---@field set TSet
---Conversions of `set` to other `SpriteSetType`s, keyed by type. Checked before the conversions
---registered in `api.converters`.
---@field converters table<SpriteSetType, SpriteSetTransformer<TSet, any>>?

---A `SpriteSetDefinition` of any `SpriteSetType`.
---@class (exact) AnySpriteSetDefinition : SpriteSetDefinition<any>

---Applies a sprite set of type `U` to one kind of prototype. Registered with `api.applicators` and
---selected by the type of the target prototype.
---
---Corpses are not handled by applicators; `apply_sprite_set` copies the `corpse` field of the sprite
---set onto a `CorpsePrototype` directly.
---@class (exact) SpriteSetApplicator<T: EntityWithHealthPrototype, U: EntityWithHealthSpriteSet>
---The `SpriteSetType` accepted by `apply_to` and `apply_to_explosion`.
---@field set_type SpriteSetType
---Applies the given `set` to the given entity `prototype`.
---
---Applies the fields specific to this kind of prototype. The fields of `EntityWithHealthSpriteSet`
---are applied by `ApplicatorRegistry.apply_sprite_set` before this is called.
---@field apply_to fun(prototype: T, set: U)
---Applies `set` to the explosion prototype `explosion`.
---@field apply_to_explosion fun(explosion: ExplosionPrototype, set: U)

---A `SpriteSetApplicator` of any prototype and sprite set type.
---@class (exact) AnySpriteSetApplicator : SpriteSetApplicator<any, any>

---The sprite data of a `SpriteSetDefinition` of type `flying_robot_sprite_set`.
---@class (exact) FlyingRobotSpriteSet : EntityWithHealthSpriteSet
---The prototype's `idle`.
---@field idle RotatedAnimation
---The prototype's `in_motion`.
---@field in_motion RotatedAnimation
---The prototype's `shadow_idle`.
---@field shadow_idle RotatedAnimation
---The prototype's `shadow_in_motion`.
---@field shadow_in_motion RotatedAnimation

---The sprite data of a `SpriteSetDefinition` of type `turret_sprite_set`.
---@class (exact) TurretSpriteSet : EntityWithHealthSpriteSet

---@class (exact) PipeConnectionGraphics
---@field enable_working_visualisations string[]
---@field direction defines.direction

---@class (exact) FluidBoxGraphics
---@field pipe_connections PipeConnectionGraphics[]?
---@field render_layer RenderLayer?
---@field draw_only_when_connected boolean?
---@field pipe_covers Sprite4Way?
---@field pipe_covers_frozen Sprite4Way?
---@field pipe_picture Sprite4Way?
---@field pipe_picture_frozen Sprite4Way?
---@field mirrored_pipe_picture Sprite4Way?
---@field mirrored_pipe_picture_frozen Sprite4Way?
---@field secondary_draw_order int8?
---@field secondary_draw_orders FluidBoxSecondaryDrawOrders?
---@field enable_working_visualisations string[]?
