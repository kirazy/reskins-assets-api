local _defines = require("api.defines")

local GraphicsPackBase = require("graphics-packs.abstractions.graphics-pack-base")

---@class Reskins.Abstractions.TransportBeltConnectableGraphicsPack:Reskins.Abstractions.GraphicsPackBase
---@field belt_animation_set data.TransportBeltAnimationSet
local TransportBeltConnectableGraphicsPack = {}
TransportBeltConnectableGraphicsPack.__index = TransportBeltConnectableGraphicsPack

-- Set up inheritance.
setmetatable(TransportBeltConnectableGraphicsPack, {
	__index = GraphicsPackBase,
})

---@class Reskins.Abstractions.TransportBeltConnectableGraphicsParams:Reskins.Abstractions.GraphicsParams
---@field belt_sprite Reskins.Defines.BeltSprites

---@param params Reskins.Abstractions.TransportBeltConnectableGraphicsParams
---@return Reskins.Abstractions.TransportBeltConnectableGraphicsPack
---@nodiscard
function TransportBeltConnectableGraphicsPack:configure(params)
	local belt_animation_set = self.get_belt_animation_set(params.tint, params.belt_sprite)

	local instance = GraphicsPackBase.configure(self, {
		tint = params.tint,
		scale = params.scale,
		scale_factor = params.scale_factor,
		remnants = params.remnants,
		required_assets = { [_defines.assets.base_assets] = true },
		nominal_width = params.nominal_width,
		nominal_height = params.nominal_height,
	}) --[[@as Reskins.Abstractions.TransportBeltConnectableGraphicsPack]]

	instance.belt_animation_set = belt_animation_set

	-- Set the correct metatable for this class.
	setmetatable(instance, TransportBeltConnectableGraphicsPack)
	return instance
end

---Builds the full `data.TransportBeltAnimationSet` for the given `tint` and `belt_sprite`.
---@param tint data.Color?
---@param belt_sprite Reskins.Defines.BeltSprites
---@return data.TransportBeltAnimationSet
---@nodiscard
function TransportBeltConnectableGraphicsPack.get_belt_animation_set(tint, belt_sprite)
	local assets_path = _defines.assets.base_assets .. "/graphics/entity/transport-belt/"

	local frame_counts = {
		[_defines.belt_sprites.standard] = 16,
		[_defines.belt_sprites.fast] = 32,
		[_defines.belt_sprites.turbo] = 64,
	}
	local frame_count = frame_counts[belt_sprite]

	---@type data.RotatedAnimation
	local animation_set = {
		layers = {
			{
				filename = assets_path .. "transport-belt-" .. belt_sprite .. "-base.png",
				priority = "extra-high",
				width = 128,
				height = 128,
				frame_count = frame_count,
				direction_count = 20,
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation_set.layers, {
			filename = assets_path .. "transport-belt-" .. belt_sprite .. "-mask.png",
			priority = "extra-high",
			width = 128,
			height = 128,
			frame_count = frame_count,
			direction_count = 20,
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation_set.layers, {
			filename = assets_path .. "transport-belt-" .. belt_sprite .. "-highlights.png",
			priority = "extra-high",
			width = 128,
			height = 128,
			frame_count = frame_count,
			direction_count = 20,
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	return { animation_set = animation_set }
end

---Applies the graphics pack to the specified `prototype`.
---@param prototype data.TransportBeltConnectablePrototype
function TransportBeltConnectableGraphicsPack:apply_to_entity(prototype)
	prototype.belt_animation_set = util.copy(self.belt_animation_set)
end

return TransportBeltConnectableGraphicsPack
