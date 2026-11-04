---@using data

---@namespace Reskins.Assets

local V = require("__reskins-sprite-utils__.validation")
local AssetsCommon = require("api.validation")
local ConnectionMatching = require("api.connection-matching")
local Assignment = require("api.assignment")

---Provides methods for applying `HeatBufferGraphics` to the heat energy source and the heat buffer of a prototype.
---
---#### Examples
---```lua
---local HeatBuffers = require("__reskins-assets-api__.api.heat-buffers")
---```
---@class HeatBuffers
local _heat_buffers = {}

-- The fields of a `HeatBufferGraphics` that are applied when they are defined.
local graphics_fields = {
	"pipe_covers",
	"heat_pipe_covers",
	"heat_picture",
	"heat_glow",
}

local check_apply = V.signature("apply", {
	{ "prototype", AssetsCommon.prototype },
	{ "heat_buffer_graphics", V.array(AssetsCommon.heat_buffer_graphics) },
})

---Applies the given `heat_buffer_graphics` to the heat energy source and the heat buffer of the given `prototype`, in
---place.
---
---The heat energy source and the heat buffer are each matched to an entry of `heat_buffer_graphics` by the directions
---and positions of their connections. Each takes the graphics fields that the matching entry defines. A heat energy
---source or heat buffer that matches no entry is not modified.
---
---The energy source and the heat buffer of `prototype` are replaced with copies before they are modified.
---
---#### Parameters
---@param prototype EntityWithHealthPrototype The prototype to which the graphics are applied.
---@param heat_buffer_graphics HeatBufferGraphics[] The graphics to apply.
---
---#### Examples
---```lua
----- Apply heat pipe covers to the heat energy source of a heat exchanger.
---local HeatBuffers = require("__reskins-assets-api__.api.heat-buffers")
---
---local heat_pipe_covers = { sheet = { filename = "__my-mod__/graphics/heat-pipe-covers.png", size = 64, scale = 0.5 } }
---HeatBuffers.apply(data.raw["boiler"]["heat-exchanger"], { { pipe_covers = heat_pipe_covers } })
----- The `pipe_covers` of the energy source of the heat exchanger are `heat_pipe_covers`.
---```
---@throws When `prototype` is not a prototype.
---@throws When `heat_buffer_graphics` is not an array of `HeatBufferGraphics`.
function _heat_buffers.apply(prototype, heat_buffer_graphics)
	check_apply(prototype, heat_buffer_graphics)

	local fields = prototype --[[@as table<string, any>]]

	---@type (HeatEnergySource|HeatBuffer)[]
	local targets = {}

	if fields.energy_source and fields.energy_source.type == "heat" then
		fields.energy_source = util.copy(fields.energy_source)
		targets[#targets + 1] = fields.energy_source
	end

	if fields.heat_buffer then
		fields.heat_buffer = util.copy(fields.heat_buffer)
		targets[#targets + 1] = fields.heat_buffer
	end

	for _, target in pairs(targets) do
		local graphics = ConnectionMatching.find_graphics(heat_buffer_graphics, "connections", target.connections or {})

		if graphics then
			Assignment.safe_assign(target, graphics, graphics_fields)
		end
	end
end

return _heat_buffers
