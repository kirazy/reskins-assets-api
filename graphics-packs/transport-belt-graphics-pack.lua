local _sprites = require("__reskins-sprite-utils__.sprites")

local TransportBeltConnectableGraphicsPack = require("transport-belt-connectable-graphics-pack")

---@class TransportBeltGraphicsPack:TransportBeltConnectableGraphicsPack
local TransportBeltGraphicsPack = {}
TransportBeltGraphicsPack.__index = TransportBeltGraphicsPack

-- Set up inheritance.
setmetatable(TransportBeltGraphicsPack, {
	__index = TransportBeltConnectableGraphicsPack,
})

---@class TransportBeltGraphicsParams
---@field tint data.Color?
---@field belt_sprite 1|2

---@param params TransportBeltGraphicsParams
---@return TransportBeltGraphicsPack
---@nodiscard
function TransportBeltGraphicsPack:configure(params)
	local remnants = self.get_corpse_animation(params.tint)

	local instance = TransportBeltConnectableGraphicsPack.configure(self, {
		tint = params.tint,
		belt_sprite = params.belt_sprite,
		remnants = remnants,
	}) --[[@as TransportBeltGraphicsPack]]

	-- Set the correct metatable for this class.
	setmetatable(instance, TransportBeltGraphicsPack)
	return instance
end

---@param tint data.Color?
---@return data.RotatedAnimationVariations
---@nodiscard
function TransportBeltGraphicsPack.get_corpse_animation(tint)
	local assets_path = "__reskins-assets-base__/graphics/entity/transport-belt/"

	local layers = {
		{
			filename = assets_path .. "remnants/transport-belt-remnants-base.png",
			width = 106,
			height = 102,
			direction_count = 4,
			shift = util.by_pixel(1, -0.5),
			scale = 0.5,
		},
	}

	if tint then
		table.insert(layers, {
			filename = assets_path .. "remnants/transport-belt-remnants-mask.png",
			width = 106,
			height = 102,
			direction_count = 4,
			shift = util.by_pixel(1, -0.5),
			tint = tint,
			scale = 0.5,
		})
		table.insert(layers, {
			filename = assets_path .. "remnants/transport-belt-remnants-highlights.png",
			width = 106,
			height = 102,
			direction_count = 4,
			shift = util.by_pixel(1, -0.5),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	return _sprites.make_rotated_animation_variations_from_spritesheet(2, { layers = layers })
end

---Applies the graphics pack to the specified `prototype`.
---@param prototype data.TransportBeltPrototype
function TransportBeltGraphicsPack:apply_to_entity(prototype)
	TransportBeltConnectableGraphicsPack.apply_to_entity(self, prototype)
end

return TransportBeltGraphicsPack
