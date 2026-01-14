-- THIS MODULE IS EXTREMELY WIP AND SUBJECT TO CHANGE.
-- The type signatures are not stable.

---Creates a new icon with the specified `tint`, `shift`, and `scale`.
---
---*@param* `tint` — The color of the mask layer of the created icon; optional.
---
---*@param* `shift` — A shift to apply to every layer of the created icon; optional.
---
---*@param* `scale` — A scaling factor to apply to every layer of the created icon; optional.
---
---@alias TintedIconCreator fun(tint: data.Color?, shift: data.Vector?, scale: double?): data.IconData[]

---Creates a new icon with the specified `shift`, and `scale`.
---
---*@param* `shift` — A shift to apply to the created icon; optional.
---
---*@param* `scale` — A scaling factor to apply to the created icon; optional.
---
---@alias IconCreator fun(shift: data.Vector?, scale: double?): data.IconData[]

---@class PipeConnectionGraphics
---@field enable_working_visualisations string[]
---@field direction defines.direction

---@class FluidBoxGraphics
---@field pipe_connections PipeConnectionGraphics[]?
---@field render_layer data.RenderLayer?
---@field draw_only_when_connected boolean?
---@field pipe_covers data.Sprite4Way?
---@field pipe_covers_frozen data.Sprite4Way?
---@field pipe_picture data.Sprite4Way?
---@field pipe_picture_frozen data.Sprite4Way?
---@field mirrored_pipe_picture data.Sprite4Way?
---@field mirrored_pipe_picture_frozen data.Sprite4Way?
---@field secondary_draw_order int8?
---@field secondary_draw_orders data.FluidBoxSecondaryDrawOrders?
---@field enable_working_visualisations string[]?

---The base type for graphics packs.
---@class EntityGraphicsPack
---The icon for entities using the graphics pack.
---@field icons data.IconData[]
---The list of assets mods that are required to be enabled for the graphics set to be loaded successfully.
---
---The values of this array are exact mod names that can be used to validate a mod is present.
---@field required_assets Reskins.Defines.Assets[]
---The tint that was used to color the graphics, if provided.
---
---When `nil`, the entities and icons will not include the tintable layers.
---@field tint data.Color?
---The destroyed variant of the graphics, if applicable. Suitable for use with Corpse prototypes.
---@field remnants data.RotatedAnimationVariations?
---Indicates if the asset mods required to use the graphics pack are active.
---@field has_required_asset_mods fun(self: EntityGraphicsPack): boolean

---@class AsteroidGraphicsPack:EntityGraphicsPack
---@field graphics_set data.AsteroidGraphicsSet
---@field apply_to_entity fun(prototype: data.AsteroidPrototype)
---@field apply_to_corpse fun(corpse: data.CorpsePrototype)

---@class BeaconGraphicsPack:EntityGraphicsPack
---@field graphics_set data.BeaconGraphicsSet
---@field apply_to_entity fun(prototype: data.BeaconPrototype)
---@field apply_to_corpse fun(corpse: data.CorpsePrototype)

---@class BeamGraphicsPack:EntityGraphicsPack
---@field graphics_set data.BeamGraphicsSet
---@field apply_to_entity fun(prototype: data.BeamPrototype)
---@field apply_to_corpse fun(corpse: data.CorpsePrototype)

---@alias CargoBayConnectablePrototype
---| data.CargoBayPrototype
---| data.CargoLandingPadPrototype
---| data.SpacePlatformHubPrototype

---@class CargoBayConnectableGraphicsPack:EntityGraphicsPack
---@field graphics_set data.CargoBayConnectableGraphicsSet
---@field platform_graphics_set data.CargoBayConnectableGraphicsSet
---@field apply_to_entity fun(prototype: CargoBayConnectablePrototype)
---@field apply_to_corpse fun(corpse: CargoBayConnectablePrototype)

---@class EnemySpawnerGraphicsPack:EntityGraphicsPack
---@field graphics_set data.EnemySpawnerGraphicsSet
---@field apply_to_entity fun(prototype: data.EnemySpawnerPrototype)
---@field apply_to_corpse fun(corpse: data.CorpsePrototype)

---@class FusionGeneratorGraphicsPack:EntityGraphicsPack
---@field graphics_set data.FusionGeneratorGraphicsSet
---@field apply_to_entity fun(prototype: data.FusionGeneratorPrototype)
---@field apply_to_corpse fun(corpse: data.CorpsePrototype)

---@class FusionReactorGraphicsPack:EntityGraphicsPack
---@field graphics_set data.FusionReactorGraphicsSet
---@field apply_to_entity fun(prototype: data.FusionReactorPrototype)
---@field apply_to_corpse fun(corpse: data.CorpsePrototype)

---@class LightningGraphicsPack:EntityGraphicsPack
---@field graphics_set data.LightningGraphicsSet
---@field apply_to_entity fun(prototype: data.LightningPrototype)
---@field apply_to_corpse fun(corpse: data.CorpsePrototype)

---@class MiningDrillGraphicsPack:EntityGraphicsPack
---@field graphics_set data.MiningDrillGraphicsSet
---@field apply_to_entity fun(prototype: data.MiningDrillPrototype)
---@field apply_to_corpse fun(corpse: data.CorpsePrototype)

---@class OffshorePumpGraphicsPack:EntityGraphicsPack
---@field graphics_set data.OffshorePumpGraphicsSet
---@field apply_to_entity fun(prototype: data.OffshorePumpPrototype)
---@field apply_to_corpse fun(corpse: data.CorpsePrototype)

---@class RailFenceGraphicsPack:EntityGraphicsPack
---@field graphics_set data.RailFenceGraphicsSet
---@field apply_to_entity fun(prototype: data.RailPrototype)
---@field apply_to_corpse fun(corpse: data.CorpsePrototype)

---@class SpiderTorsoGraphicsPack:EntityGraphicsPack
---@field graphics_set data.SpiderTorsoGraphicsSet
---@field apply_to_entity fun(prototype: data.SpiderUnitPrototype)
---@field apply_to_corpse fun(corpse: data.CorpsePrototype)

---@class SpiderVehicleGraphicsPack:EntityGraphicsPack
---@field graphics_set data.SpiderVehicleGraphicsSet
---@field apply_to_entity fun(prototype: data.SpiderVehiclePrototype)
---@field apply_to_corpse fun(corpse: data.CorpsePrototype)

---@class ThrusterGraphicsPack:EntityGraphicsPack
---@field graphics_set data.ThrusterGraphicsSet
---@field apply_to_entity fun(prototype: data.ThrusterPrototype)
---@field apply_to_corpse fun(corpse: data.CorpsePrototype)

---@class TurretGraphicsPack:EntityGraphicsPack
---@field graphics_set data.TurretGraphicsSet
---@field apply_to_entity fun(prototype: data.TurretPrototype)
---@field apply_to_corpse fun(corpse: data.CorpsePrototype)
