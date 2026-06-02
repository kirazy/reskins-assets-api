local _sprites = require("__reskins-sprite-utils__.sprites")

local TransportBeltConnectableGraphicsPack =
	require("graphics-packs.abstractions.transport-belt-connectable-graphics-pack")

---@class UndergroundBeltGraphicsPack:Reskins.Abstractions.TransportBeltConnectableGraphicsPack
---@field structure table
local UndergroundBeltGraphicsPack = {}
UndergroundBeltGraphicsPack.__index = UndergroundBeltGraphicsPack

-- Set up inheritance.
setmetatable(UndergroundBeltGraphicsPack, {
	__index = TransportBeltConnectableGraphicsPack,
})

---@class UndergroundBeltGraphicsParams
---@field tint data.Color?
---@field belt_sprite 1|2

---@param params UndergroundBeltGraphicsParams
---@return UndergroundBeltGraphicsPack
---@nodiscard
function UndergroundBeltGraphicsPack:configure(params)
	local remnants = self.get_corpse_animation(params.tint)

	local instance = TransportBeltConnectableGraphicsPack.configure(self, {
		tint = params.tint,
		belt_sprite = params.belt_sprite,
		remnants = remnants,
	}) --[[@as UndergroundBeltGraphicsPack]]

	instance.structure = self.get_structure(params.tint)

	-- Set the correct metatable for this class.
	setmetatable(instance, UndergroundBeltGraphicsPack)
	return instance
end

---@param tint data.Color?
---@return table
---@nodiscard
function UndergroundBeltGraphicsPack.get_structure(tint)
	local assets_path = "__reskins-assets-base__/graphics/entity/underground-belt/"

	-- Builds one direction entry. The base layer uses no -base suffix: underground-belt-structure.png.
	-- y_offset selects the row in the spritesheet (each row is 192px tall).
	---@param y_offset integer
	---@return table
	local function make_direction(y_offset)
		local sheets = {
			{
				filename = assets_path .. "underground-belt-structure.png",
				priority = "extra-high",
				width = 192,
				height = 192,
				y = y_offset,
				scale = 0.5,
			},
		}

		if tint then
			table.insert(sheets, {
				filename = assets_path .. "underground-belt-structure-mask.png",
				priority = "extra-high",
				width = 192,
				height = 192,
				y = y_offset,
				tint = tint,
				scale = 0.5,
			})
			table.insert(sheets, {
				filename = assets_path .. "underground-belt-structure-highlights.png",
				priority = "extra-high",
				width = 192,
				height = 192,
				y = y_offset,
				blend_mode = "additive-soft",
				scale = 0.5,
			})
		end

		return { sheets = sheets }
	end

	return {
		direction_out = make_direction(0),
		direction_in = make_direction(192),
		direction_out_side_loading = make_direction(384),
		direction_in_side_loading = make_direction(576),
		back_patch = {
			sheet = {
				filename = "__base__/graphics/entity/express-underground-belt/express-underground-belt-structure-back-patch.png",
				priority = "extra-high",
				width = 192,
				height = 192,
				scale = 0.5,
			},
		},
		front_patch = {
			sheet = {
				filename = "__base__/graphics/entity/express-underground-belt/express-underground-belt-structure-front-patch.png",
				priority = "extra-high",
				width = 192,
				height = 192,
				scale = 0.5,
			},
		},
	}
end

---@param tint data.Color?
---@return data.RotatedAnimationVariations
---@nodiscard
function UndergroundBeltGraphicsPack.get_corpse_animation(tint)
	local assets_path = "__reskins-assets-base__/graphics/entity/underground-belt/"

	local layers = {
		{
			filename = assets_path .. "remnants/underground-belt-remnants-base.png",
			width = 156,
			height = 144,
			direction_count = 8,
			shift = util.by_pixel(10.5, 3),
			scale = 0.5,
		},
	}

	if tint then
		table.insert(layers, {
			filename = assets_path .. "remnants/underground-belt-remnants-mask.png",
			width = 156,
			height = 144,
			direction_count = 8,
			shift = util.by_pixel(10.5, 3),
			tint = tint,
			scale = 0.5,
		})
		table.insert(layers, {
			filename = assets_path .. "remnants/underground-belt-remnants-highlights.png",
			width = 156,
			height = 144,
			direction_count = 8,
			shift = util.by_pixel(10.5, 3),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	return _sprites.make_rotated_animation_variations_from_spritesheet(1, { layers = layers })
end

---Applies the graphics pack to the specified `prototype`.
---@param prototype data.UndergroundBeltPrototype
function UndergroundBeltGraphicsPack:apply_to_entity(prototype)
	TransportBeltConnectableGraphicsPack.apply_to_entity(self, prototype)
	prototype.structure = util.copy(self.structure)
end

return UndergroundBeltGraphicsPack
