-- THIS MODULE IS EXTREMELY WIP AND SUBJECT TO CHANGE.
-- The type signatures are not stable.

---@using data

---@namespace Reskins.Assets

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
