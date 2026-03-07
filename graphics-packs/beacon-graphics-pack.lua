local _defines = require("api.defines")
local GraphicsPackBase = require("graphics-pack-base")

---@class BeaconGraphicsPack:GraphicsPackBase
---@field animation_list data.AnimationElement[]
local BeaconGraphicsPack = {}
BeaconGraphicsPack.__index = BeaconGraphicsPack

-- Set up inheritance.
setmetatable(BeaconGraphicsPack, {
	__index = GraphicsPackBase,
})

---@class BeaconGraphicsParams
---@field tint data.Color?
---@field variant "2-slots"|"4-slots"|"6-slots"

---@param params BeaconGraphicsParams
---@return BeaconGraphicsPack
---@nodiscard
function BeaconGraphicsPack:configure(params)
	local instance = GraphicsPackBase.configure(self, {
		tint = params.tint,
		remnants = self.get_corpse_animation(params.tint),
		required_assets = { [_defines.assets.base_assets] = true },
	}) --[[@as BeaconGraphicsPack]]

	instance.animation_list = self.get_animation_list(params.tint, params.variant)

	-- Set the correct metatable for this class.
	setmetatable(instance, BeaconGraphicsPack)
	return instance
end

---@param prototype data.BeaconPrototype
function BeaconGraphicsPack:apply_to_entity(prototype)
	local graphics_set = util.copy(prototype.graphics_set)
	graphics_set.animation_list = util.copy(self.animation_list)
	prototype.graphics_set = graphics_set
	self:try_apply_to_named_corpse(prototype.name .. "-remnants")
end

---@param tint data.Color?
---@param variant "2-slots"|"4-slots"|"6-slots"
---@return data.AnimationElement[]
---@nodiscard
function BeaconGraphicsPack.get_animation_list(tint, variant)
	local assets_path = _defines.assets.base_assets .. "/graphics/entity/beacon/" .. variant .. "/"
	local base_path = _defines.assets.base .. "/graphics/entity/beacon/"

	-- 1. Bottom (floor-mechanics) animation with base/mask/highlights/shadow.
	local bottom_layers = {
		{
			filename = assets_path .. "beacon-" .. variant .. "-bottom-base.png",
			width = 212,
			height = 192,
			scale = 0.5,
			shift = util.by_pixel(0.5, 1),
		},
	}

	if tint then
		table.insert(bottom_layers, {
			filename = assets_path .. "beacon-" .. variant .. "-bottom-mask.png",
			width = 212,
			height = 192,
			scale = 0.5,
			shift = util.by_pixel(0.5, 1),
			tint = tint,
		})
		table.insert(bottom_layers, {
			filename = assets_path .. "beacon-" .. variant .. "-bottom-highlights.png",
			width = 212,
			height = 192,
			scale = 0.5,
			shift = util.by_pixel(0.5, 1),
			blend_mode = "additive-soft",
		})
	end

	table.insert(bottom_layers, {
		filename = base_path .. "beacon-shadow.png",
		width = 244,
		height = 176,
		scale = 0.5,
		draw_as_shadow = true,
		shift = util.by_pixel(12.5, 0.5),
	})

	---@type data.AnimationElement[]
	local animation_list = {
		-- 1. Bottom base animation (renders on floor-mechanics layer).
		{
			render_layer = "floor-mechanics",
			animation = { layers = bottom_layers },
		},
		-- 2. Antenna top.
		{
			animation = {
				filename = assets_path .. "beacon-" .. variant .. "-top.png",
				width = 96,
				height = 140,
				scale = 0.5,
				repeat_count = 45,
				animation_speed = 0.5,
				shift = util.by_pixel(3, -19),
			},
		},
		-- 3. Light animation, tinted by active modules.
		{
			apply_tint = true,
			always_draw = false,
			animation = {
				filename = base_path .. "beacon-light.png",
				line_length = 9,
				width = 110,
				height = 186,
				frame_count = 45,
				animation_speed = 0.5,
				scale = 0.5,
				shift = util.by_pixel(0.5, -18),
				blend_mode = "additive",
			},
		},
		-- 4. Light animation, untinted (base game uses two copies).
		{
			apply_tint = false,
			always_draw = false,
			animation = {
				filename = base_path .. "beacon-light.png",
				line_length = 9,
				width = 110,
				height = 186,
				frame_count = 45,
				animation_speed = 0.5,
				scale = 0.5,
				shift = util.by_pixel(0.5, -18),
				blend_mode = "additive",
			},
		},
	}

	-- 5. Module slot overlay (only for "4-slots" and "6-slots").
	if variant == "4-slots" then
		table.insert(animation_list, {
			render_layer = "transport-belt-circuit-connector",
			animation = {
				layers = {
					{
						filename = assets_path .. "beacon-4-slots-bottom-slot-overlay.png",
						width = 212,
						height = 192,
						scale = 0.5,
						shift = util.by_pixel(0.5, 1),
					},
				},
			},
		})
	elseif variant == "6-slots" then
		local overlay_layers = {
			{
				filename = assets_path .. "beacon-6-slots-bottom-slot-overlay-base.png",
				width = 212,
				height = 192,
				scale = 0.5,
				shift = util.by_pixel(0.5, 1),
			},
		}

		if tint then
			table.insert(overlay_layers, {
				filename = assets_path .. "beacon-6-slots-bottom-slot-overlay-mask.png",
				width = 212,
				height = 192,
				scale = 0.5,
				shift = util.by_pixel(0.5, 1),
				tint = tint,
			})
			table.insert(overlay_layers, {
				filename = assets_path .. "beacon-6-slots-bottom-slot-overlay-highlights.png",
				width = 212,
				height = 192,
				scale = 0.5,
				shift = util.by_pixel(0.5, 1),
				blend_mode = "additive-soft",
			})
		end

		table.insert(animation_list, {
			render_layer = "transport-belt-circuit-connector",
			animation = { layers = overlay_layers },
		})
	end

	return animation_list
end

---@param tint data.Color?
---@return data.RotatedAnimationVariations
---@nodiscard
function BeaconGraphicsPack.get_corpse_animation(tint)
	local base_path = _defines.assets.base .. "/graphics/entity/beacon/remnants/"
	local assets_path = _defines.assets.base_assets .. "/graphics/entity/beacon/remnants/"

	---@type data.RotatedAnimation
	local animation = {
		layers = {
			{
				filename = base_path .. "beacon-remnants.png",
				direction_count = 1,
				width = 212,
				height = 206,
				shift = util.by_pixel(1, 5),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers, {
			filename = assets_path .. "beacon-remnants-mask.png",
			direction_count = 1,
			width = 212,
			height = 206,
			shift = util.by_pixel(1, 5),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers, {
			filename = assets_path .. "beacon-remnants-highlights.png",
			direction_count = 1,
			width = 212,
			height = 206,
			shift = util.by_pixel(1, 5),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	return { animation, util.copy(animation) }
end

return BeaconGraphicsPack
