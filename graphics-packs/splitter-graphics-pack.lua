local _sprites = require("__reskins-sprite-utils__.sprites")

local TransportBeltConnectableGraphicsPack = require("transport-belt-connectable-graphics-pack")

---@class SplitterGraphicsPack:TransportBeltConnectableGraphicsPack
---@field structure data.Animation4Way
---@field structure_patch data.Animation4Way
local SplitterGraphicsPack = {}
SplitterGraphicsPack.__index = SplitterGraphicsPack

-- Set up inheritance.
setmetatable(SplitterGraphicsPack, {
	__index = TransportBeltConnectableGraphicsPack,
})

---@class SplitterGraphicsParams
---@field tint data.Color?
---@field belt_sprite 1|2

---@param params SplitterGraphicsParams
---@return SplitterGraphicsPack
---@nodiscard
function SplitterGraphicsPack:configure(params)
	local remnants = self.get_corpse_animation(params.tint)

	local instance = TransportBeltConnectableGraphicsPack.configure(self, {
		tint = params.tint,
		belt_sprite = params.belt_sprite,
		remnants = remnants,
	}) --[[@as SplitterGraphicsPack]]

	instance.structure = self.get_structure(params.tint)
	instance.structure_patch = self.get_structure_patch(params.tint)

	-- Set the correct metatable for this class.
	setmetatable(instance, SplitterGraphicsPack)
	return instance
end

---@param tint data.Color?
---@return data.Animation4Way
---@nodiscard
function SplitterGraphicsPack.get_structure(tint)
	local assets_path = "__reskins-assets-base__/graphics/entity/splitter/"

	---@param direction_name string
	---@param width integer
	---@param height integer
	---@param shift data.Vector
	---@return data.Animation
	local function make_direction(direction_name, width, height, shift)
		local layers = {
			{
				filename = assets_path .. "splitter-" .. direction_name .. "-base.png",
				priority = "extra-high",
				width = width,
				height = height,
				frame_count = 32,
				line_length = 8,
				shift = shift,
				scale = 0.5,
			},
		}

		if tint then
			table.insert(layers, {
				filename = assets_path .. "splitter-" .. direction_name .. "-mask.png",
				priority = "extra-high",
				width = width,
				height = height,
				frame_count = 32,
				line_length = 8,
				shift = shift,
				tint = tint,
				scale = 0.5,
			})
			table.insert(layers, {
				filename = assets_path .. "splitter-" .. direction_name .. "-highlights.png",
				priority = "extra-high",
				width = width,
				height = height,
				frame_count = 32,
				line_length = 8,
				shift = shift,
				blend_mode = "additive-soft",
				scale = 0.5,
			})
		end

		return { layers = layers }
	end

	---@type data.Animation4Way
	return {
		north = make_direction("north", 160, 70, util.by_pixel(7, 0)),
		east = make_direction("east", 90, 84, util.by_pixel(4, 13)),
		south = make_direction("south", 164, 64, util.by_pixel(4, 0)),
		west = make_direction("west", 94, 86, util.by_pixel(5, 12)),
	}
end

---@param tint data.Color?
---@return data.Animation4Way
---@nodiscard
function SplitterGraphicsPack.get_structure_patch(tint)
	local assets_path = "__reskins-assets-base__/graphics/entity/splitter/"

	---@param direction_name string
	---@param width integer
	---@param height integer
	---@param shift data.Vector
	---@return data.Animation
	local function make_patch_direction(direction_name, width, height, shift)
		local layers = {
			{
				filename = assets_path .. "splitter-" .. direction_name .. "-top_patch-base.png",
				priority = "extra-high",
				width = width,
				height = height,
				frame_count = 32,
				line_length = 8,
				shift = shift,
				scale = 0.5,
			},
		}

		if tint then
			table.insert(layers, {
				filename = assets_path .. "splitter-" .. direction_name .. "-top_patch-mask.png",
				priority = "extra-high",
				width = width,
				height = height,
				frame_count = 32,
				line_length = 8,
				shift = shift,
				tint = tint,
				scale = 0.5,
			})
			table.insert(layers, {
				filename = assets_path .. "splitter-" .. direction_name .. "-top_patch-highlights.png",
				priority = "extra-high",
				width = width,
				height = height,
				frame_count = 32,
				line_length = 8,
				shift = shift,
				blend_mode = "additive-soft",
				scale = 0.5,
			})
		end

		return { layers = layers }
	end

	---@type data.Animation4Way
	return {
		north = util.empty_sprite(),
		east = make_patch_direction("east", 90, 104, util.by_pixel(4, -20)),
		south = util.empty_sprite(),
		west = make_patch_direction("west", 94, 96, util.by_pixel(5, -18)),
	}
end

---@param tint data.Color?
---@return data.RotatedAnimationVariations
---@nodiscard
function SplitterGraphicsPack.get_corpse_animation(tint)
	local assets_path = "__reskins-assets-base__/graphics/entity/splitter/"

	local layers = {
		{
			filename = assets_path .. "remnants/splitter-remnants-base.png",
			width = 190,
			height = 190,
			direction_count = 4,
			shift = util.by_pixel(3.5, 1.5),
			scale = 0.5,
		},
	}

	if tint then
		table.insert(layers, {
			filename = assets_path .. "remnants/splitter-remnants-mask.png",
			width = 190,
			height = 190,
			direction_count = 4,
			shift = util.by_pixel(3.5, 1.5),
			tint = tint,
			scale = 0.5,
		})
		table.insert(layers, {
			filename = assets_path .. "remnants/splitter-remnants-highlights.png",
			width = 190,
			height = 190,
			direction_count = 4,
			shift = util.by_pixel(3.5, 1.5),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	return _sprites.make_rotated_animation_variations_from_spritesheet(1, { layers = layers })
end

---Applies the graphics pack to the specified `prototype`.
---@param prototype data.SplitterPrototype
function SplitterGraphicsPack:apply_to_entity(prototype)
	TransportBeltConnectableGraphicsPack.apply_to_entity(self, prototype)
	prototype.structure = util.copy(self.structure)
	prototype.structure_patch = util.copy(self.structure_patch)
end

return SplitterGraphicsPack
