---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Applicators

local _defines = require("api.defines")
local Assignment = require("api.assignment")

---Applies a `set` of type `heat_pipe_sprite_set` to `prototype`.
---@param prototype HeatPipePrototype
---@param set HeatPipeSpriteSet
local function apply_sprite_set_to_heat_pipe(prototype, set)
	local set_copy = util.copy(set)

	prototype.connection_sprites = set_copy.connection_sprites
	prototype.heat_glow_sprites = set_copy.heat_glow_sprites

	Assignment.safe_assign(prototype, set, { "circuit_connector" })
end

---@type HeatPipeSpriteSetApplicator
return {
	set_type = _defines.sprite_set_type.heat_pipe_sprite_set,
	apply_to = apply_sprite_set_to_heat_pipe,
}

---Defines the sprite data in a `SpriteSetDefinition` of type `heat_pipe_sprite_set`.
---@class (exact) HeatPipeSpriteSet : EntityWithHealthSpriteSet
---See [HeatPipePrototype::connection_sprites](https://lua-api.factorio.com/latest/prototypes/HeatPipePrototype.html#connection_sprites).
---@field connection_sprites ConnectableEntityGraphics
---See [HeatPipePrototype::heat_glow_sprites](https://lua-api.factorio.com/latest/prototypes/HeatPipePrototype.html#heat_glow_sprites).
---@field heat_glow_sprites ConnectableEntityGraphics
---Set of 16 circuit connector definitions. They correspond to the following sprites in this exact order:
---[single](https://lua-api.factorio.com/latest/types/ConnectableEntityGraphics.html#single),
---[ending_up](https://lua-api.factorio.com/latest/types/ConnectableEntityGraphics.html#ending_up),
---[ending_right](https://lua-api.factorio.com/latest/types/ConnectableEntityGraphics.html#ending_right),
---[corner_right_up](https://lua-api.factorio.com/latest/types/ConnectableEntityGraphics.html#corner_right_up),
---[ending_down](https://lua-api.factorio.com/latest/types/ConnectableEntityGraphics.html#ending_down),
---[straight_vertical](https://lua-api.factorio.com/latest/types/ConnectableEntityGraphics.html#straight_vertical),
---[corner_right_down](https://lua-api.factorio.com/latest/types/ConnectableEntityGraphics.html#corner_right_down),
---[t_right](https://lua-api.factorio.com/latest/types/ConnectableEntityGraphics.html#t_right),
---[ending_left](https://lua-api.factorio.com/latest/types/ConnectableEntityGraphics.html#ending_left),
---[corner_left_up](https://lua-api.factorio.com/latest/types/ConnectableEntityGraphics.html#corner_left_up),
---[straight_horizontal](https://lua-api.factorio.com/latest/types/ConnectableEntityGraphics.html#straight_horizontal),
---[t_up](https://lua-api.factorio.com/latest/types/ConnectableEntityGraphics.html#t_up),
---[corner_left_down](https://lua-api.factorio.com/latest/types/ConnectableEntityGraphics.html#corner_left_down),
---[t_left](https://lua-api.factorio.com/latest/types/ConnectableEntityGraphics.html#t_left),
---[t_down](https://lua-api.factorio.com/latest/types/ConnectableEntityGraphics.html#t_down),
---[cross](https://lua-api.factorio.com/latest/types/ConnectableEntityGraphics.html#cross).
---
---When `nil`, the circuit connector of the prototype is not modified.
---
---See [HeatPipePrototype::circuit_connector](https://lua-api.factorio.com/latest/prototypes/HeatPipePrototype.html#circuit_connector).
---@field circuit_connector? CircuitConnectorDefinition[]

---Applies the `HeatPipeSpriteSet` to `HeatPipePrototype` instances.
---@class (exact) HeatPipeSpriteSetApplicator : SpriteSetApplicator<HeatPipePrototype, HeatPipeSpriteSet>
