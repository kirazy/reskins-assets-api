---@using data

---@namespace Reskins.Assets

---The type name of an [EntityWithHealthPrototype](https://lua-api.factorio.com/latest/prototypes/EntityWithHealthPrototype.html).
---@alias PrototypeType string

---@alias SpriteSetTransformer<TIn : SpriteSetBase, TOut : SpriteSetBase> fun(sprite_set: TIn): TOut
---@alias AnySpriteSetTransformer SpriteSetTransformer<any, any>

---Caller-facing escape hatches for `apply_sprite_set`. Fields are optional; omitting them gets fully automatic behavior.
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

---The fields shared by sprite sets for `EntityWithHealthPrototype`-family entities — fields that
---don't vary by prototype kind, so every applicator handles them the same way.
---@class (exact) EntityWithHealthSpriteSet : SpriteSetBase
---The prototype's `integration_patch`.
---@field integration_patch Sprite4Way?
---The prototype's `integration_patch_render_layer`.
---@field integration_patch_render_layer RenderLayer?
---The entity's death-explosion art, consumed by `SpriteSetApplicator.apply_to_explosion`.
---@field dying_explosion any
---The entity's remnant art. Applied when this sprite set is applied to a `CorpsePrototype`,
---and left alone when it is applied to the entity itself.
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

---A sprite set tagged with its `SpriteSetType`, so `api.applicators` can route it to the applicator that
---knows how to paint that shape without the caller naming one explicitly.
---
---### Examples
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
---The shape identifying which applicator can consume `set`.
---@field set_type SpriteSetType
---The sprite data itself.
---@field set TSet
---Conversions to `set` in a specific `SpriteSetType`, keyed by that type, checked before the
---general registry in `api.converters`. Most sprite sets don't need this.
---@field converters table<SpriteSetType, SpriteSetTransformer<TSet, any>>?

---A `SpriteSetDefinition` with its sprite-set type erased, for code that only needs to route or
---convert a sprite set without knowing its exact shape.
---@class (exact) AnySpriteSetDefinition : SpriteSetDefinition<any>

---Paints one prototype kind with a sprite set of type `U`. Registered with `api.applicators` and
---selected by the target prototype's own type, never by inspecting the sprite set being applied.
---
---Corpse application isn't part of this interface: `apply_sprite_set` copies `U`'s `corpse` field
---onto a `CorpsePrototype` handed to it directly, the same way for every applicator.
---@class (exact) SpriteSetApplicator<T: EntityWithHealthPrototype, U: EntityWithHealthSpriteSet>
---The `SpriteSetType` this applicator's `apply_to`/`apply_to_explosion` expect.
---@field set_type SpriteSetType
---Applies `set` to the entity prototype `prototype`.
---
---Handles the fields particular to this prototype kind. The fields every `EntityWithHealthSpriteSet`
---carries are applied by `ApplicatorRegistry.apply_sprite_set` before this is called, leaving this
---the last word on them.
---@field apply_to fun(prototype: T, set: U)
---Applies `set` to the explosion prototype `explosion`.
---@field apply_to_explosion fun(explosion: ExplosionPrototype, set: U)

---A `SpriteSetApplicator` with its prototype and sprite-set types erased, for code that only needs
---to call it without knowing its exact types.
---@class (exact) AnySpriteSetApplicator : SpriteSetApplicator<any, any>

---The sprite data a `flying_robot_sprite_set`-tagged `SpriteSetDefinition` carries.
---@class (exact) FlyingRobotSpriteSet : EntityWithHealthSpriteSet
---The prototype's `idle`.
---@field idle RotatedAnimation
---The prototype's `in_motion`.
---@field in_motion RotatedAnimation
---The prototype's `shadow_idle`.
---@field shadow_idle RotatedAnimation
---The prototype's `shadow_in_motion`.
---@field shadow_in_motion RotatedAnimation

---The sprite data a `mining_drill_sprite_set`-tagged `SpriteSetDefinition` carries.
---@class (exact) MiningDrillSpriteSet : EntityWithHealthSpriteSet

---The sprite data a `turret_sprite_set`-tagged `SpriteSetDefinition` carries.
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
