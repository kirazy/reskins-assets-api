-- THIS MODULE IS EXTREMELY WIP AND SUBJECT TO CHANGE.
-- The type signatures are not stable.

---@using data

---@namespace Reskins.Assets

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
---The entity's remnant art, consumed by `SpriteSetApplicator.apply_to_corpse`.
---@field corpse any
---The prototype's `water_reflection`.
---@field water_reflection WaterReflectionDefinition?

---A sprite set tagged with its `SpriteSetType`, so `api.apply` can route it to the applicator that
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

---Paints one prototype kind with a sprite set of type `U`. Registered with `api.apply` and
---selected by the target prototype's own type, never by inspecting the sprite set being applied.
---@class (exact) SpriteSetApplicator<T: EntityWithHealthPrototype, U: EntityWithHealthSpriteSet>
---The `SpriteSetType` this applicator's `apply_to`/`apply_to_corpse`/`apply_to_explosion` expect.
---@field set_type SpriteSetType
---Applies `set` to the entity prototype `prototype`.
---@field apply_to fun(prototype: T, set: U)
---Applies `set` to the corpse prototype `corpse`.
---@field apply_to_corpse fun(corpse: CorpsePrototype, set: U)
---Applies `set` to the explosion prototype `explosion`.
---@field apply_to_explosion fun(explosion: ExplosionPrototype, set: U)

---A `SpriteSetApplicator` with its prototype and sprite-set types erased, for code that only needs
---to call it without knowing its exact types.
---@class (exact) AnySpriteSetApplicator : SpriteSetApplicator<any, any>

---
--- Provisional sprite-set shapes
---
--- A sprite set's shape belongs to the applicator that consumes it — `BoilerSpriteSet` lives in
--- `api/applicators/boiler.lua`. The shapes below have no applicator yet, and more than one
--- producer builds each of them, so they can't be declared in a producer file without two
--- producers declaring the same class. They live here until their applicator exists, then move to
--- it. A shape only one producer builds is declared in that producer instead.
---

---Built by the transport belt, splitter, and underground belt producers.
---@class (exact) TransportBeltSpriteSet : EntityWithHealthSpriteSet
---The prototype's `belt_animation_set`.
---@field belt_animation_set TransportBeltAnimationSet
---The prototype's `structure`, for a splitter or an underground belt.
---@field structure Animation4Way?
---The prototype's `structure_patch`, for a splitter.
---@field structure_patch Animation4Way?

---Built by the big pole, medium pole, and substation producers.
---@class (exact) ElectricPoleSpriteSet : EntityWithHealthSpriteSet
---The prototype's `pictures`.
---@field pictures RotatedSprite
---The corpse prototype's `animation_overlay`, drawn over `corpse`.
---@field corpse_overlay any

---Built by the steam engine and steam turbine producers.
---
---Note: this shape is Factorio 2.0 specific and changes significantly with Factorio 2.1.
---@class (exact) GeneratorSpriteSet : EntityWithHealthSpriteSet
---The prototype's `horizontal_animation`.
---@field horizontal_animation Animation
---The prototype's `vertical_animation`.
---@field vertical_animation Animation

---Built by the inserter and inserter-preset producers.
---@class (exact) InserterSpriteSet : EntityWithHealthSpriteSet
---The prototype's `hand_base_picture`.
---@field hand_base_picture Sprite
---The prototype's `hand_base_shadow`.
---@field hand_base_shadow Sprite
---The prototype's `hand_open_picture`.
---@field hand_open_picture Sprite
---The prototype's `hand_closed_picture`.
---@field hand_closed_picture Sprite
---The prototype's `hand_open_shadow`.
---@field hand_open_shadow Sprite
---The prototype's `hand_closed_shadow`.
---@field hand_closed_shadow Sprite
---The prototype's `platform_picture`.
---@field platform_picture Sprite4Way

---Built by the construction, logistic and combat robot producers.
---@class (exact) FlyingRobotSpriteSet : EntityWithHealthSpriteSet
---The prototype's `idle`.
---@field idle RotatedAnimation
---The prototype's `in_motion`.
---@field in_motion RotatedAnimation
---The prototype's `shadow_idle`.
---@field shadow_idle RotatedAnimation
---The prototype's `shadow_in_motion`.
---@field shadow_in_motion RotatedAnimation

---Built by the logistic robot producers.
---@class (exact) LogisticRobotSpriteSet : FlyingRobotSpriteSet
---The prototype's `in_motion_with_cargo`, for a logistic robot.
---@field in_motion_with_cargo RotatedAnimation?
---The prototype's `shadow_in_motion_with_cargo`, for a logistic robot.
---@field shadow_in_motion_with_cargo RotatedAnimation?
---The prototype's `idle_with_cargo`, for a logistic robot.
---@field idle_with_cargo RotatedAnimation?
---The prototype's `shadow_idle_with_cargo`, for a logistic robot.
---@field shadow_idle_with_cargo RotatedAnimation?

---Built by the construction robot producers.
---@class (exact) ConstructionRobotSpriteSet : FlyingRobotSpriteSet
---The prototype's `working`, for a construction robot.
---@field working RotatedAnimation?
---The prototype's `shadow_working`, for a construction robot.
---@field shadow_working RotatedAnimation?

---Built by the electric mining drill and pumpjack producers. Both are placeholders that carry no
---sprites yet, so this shape adds nothing to the common fields.
---@class (exact) MiningDrillSpriteSet : EntityWithHealthSpriteSet

---Built by the gun turret, laser turret, plasma turret, and sniper turret producers. All four are
---placeholders that carry no sprites yet, so this shape adds nothing to the common fields.
---@class (exact) TurretSpriteSet : EntityWithHealthSpriteSet

---Creates a new icon with the specified `tint`, `shift`, and `scale`.
---
---*@param* `tint` — The color of the mask layer of the created icon; optional.
---
---*@param* `shift` — A shift to apply to every layer of the created icon; optional.
---
---*@param* `scale` — A scaling factor to apply to every layer of the created icon; optional.
---
---@alias TintedIconCreator fun(tint: Color?, shift: Vector?, scale: double?): IconData[]

---Creates a new icon with the specified `shift`, and `scale`.
---
---*@param* `shift` — A shift to apply to the created icon; optional.
---
---*@param* `scale` — A scaling factor to apply to the created icon; optional.
---
---@alias IconCreator fun(shift: Vector?, scale: double?): IconData[]

---Creates a new icon with the specified `shift`, and `scale`.
---
---*@param* `pipe_material` — The pipe material of the created icon.
---
---*@param* `shift` — A shift to apply to the created icon; optional.
---
---*@param* `scale` — A scaling factor to apply to the created icon; optional.
---
---@alias PipeIconCreator fun(pipe_material: PipeMaterial, shift: Vector?, scale: double?): IconData[]

---@alias RequiredAssets {[AssetsSource]: true}

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
