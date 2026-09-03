---@using data
---@using Reskins.SpriteUtils
---@using Reskins.SpriteUtils.Validation

---@namespace Reskins.Assets

local _sprite_utils = {
	icons = require("__reskins-sprite-utils__.icons"),
}
local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")

---Assembles icons from the state of an icon builder, and validates the arguments of its methods.
---
---This module is internal to the icon builder classes.
---@class IconBuilderAssembly
local _assembly = {}

---A tint with an alpha of zero, which the game renders additively.
---@type Color
_assembly.ADDITIVE_TINT = { 1, 1, 1, 0 }

---Represents the roles of a layer of an icon.
---
---A role is the trailing segment of the file name of a layer.
---@enum IconRole
_assembly.role = {
	---The body of the icon.
	base = "base",

	---The body of the icon, drawn in the color of the icon.
	mask = "mask",

	---The highlights of the icon, rendered additively over the body.
	highlights = "highlights",
}

---Controls how one layer of an icon is drawn.
---@class IconLayerOptions
---The file name segment selecting a group of layers within the icon, such as the `fire` in
---`boiler-fire-mask.png`. Default `nil`.
---@field part string?
---The color of the layer, used when no parameter of the creator supplies one. Default `nil`.
---@field tint Color?
---The size of the artwork of the layer, in pixels. Defaults to the size of the catalog.
---@field icon_size SpriteSizeType?
---The name of the parameter the layer is drawn for. The layer is omitted when the creator is
---called without that parameter; `false` draws the layer always. Defaults to the parameter the
---layer takes its color from, except for `base` layers and the first layer of the icon, which are
---always drawn.
---@field requires (string|false)?

---A rule that checks several parameters of a creator together.
---@class IconParamsRule
---The name of the parameter the failure is reported against. If `nil`, the failure is reported
---against the parameters as a whole.
---@field field string?
---The names of the parameters passed to `check`, in order.
---@field fields string[]
---A function that receives the parameters named by `fields`, in order, and returns `true` if they
---are valid together; otherwise, `false` and an optional message that replaces `message`.
---@field check fun(...): boolean, string?
---What the parameters must satisfy, phrased to follow `must be`. Used when `check` returns no
---message.
---@field message string?

---One layer of an icon, as recorded by a builder.
---@class IconBuilderLayer
---The trailing segment of the file name; `nil` for a flat file.
---@field role string?
---The segment of the file name between the stem and the role.
---@field part string?
---The name of the parameter supplying the tint; `nil` when no parameter tints the layer.
---@field tint_param string?
---The tint used when no parameter supplies one.
---@field tint Color?
---The size of the artwork of the layer, in pixels. `nil` to use the size of the icon.
---@field icon_size SpriteSizeType?
---The name of the parameter the layer is drawn for, `false` to draw it always, or `nil` to apply
---the default.
---@field requires (string|false)?

---One parameter selecting the artwork of an icon, as recorded by a builder.
---@class IconBuilderKey
---The name of the parameter.
---@field name string
---The validator accepting the values of the parameter.
---@field validator Validator<any>
---The roles the key is written into; `nil` for every role.
---@field roles table<string, true>?

---The state of an icon builder.
---@class IconBuilderState
---The mod-relative folder containing the artwork.
---@field folder string
---The name of the icon.
---@field name string
---The file name stem of the layers. `nil` to use the name of the icon.
---@field stem string?
---Whether the icon is drawn from a single file.
---@field flat boolean
---The name of the type-specific icon defaults.
---@field defaults_type IconDefaultsType?
---The size of the artwork, in pixels.
---@field icon_size SpriteSizeType?
---The layers of the icon, in drawing order.
---@field layers IconBuilderLayer[]
---The parameters selecting the artwork, in order.
---@field keys IconBuilderKey[]

-- Validators

---A validator that checks that a value is an icon name.
_assembly.IconName = Common.non_empty_string:describe_as("an icon name")

---A validator that checks that a value is an icon role.
_assembly.Role = Common.non_empty_string:describe_as("an icon role")

---A validator that checks that a value is a parameter name.
_assembly.ParamName = Common.non_empty_string:describe_as("a parameter name")

---A validator that checks that a value is an `IconLayerOptions` object with no unknown fields.
---@type ShapeValidator<IconLayerOptions>
_assembly.LayerOptions = V.shape({
	part = Common.non_empty_string:optional(),
	tint = Common.color:optional(),
	icon_size = Common.sprite_size:optional(),
	requires = V.any_of(Common.non_empty_string, V.literal(false)):optional(),
})
	:strict()
	:describe_as("an IconLayerOptions")

---A validator that checks that a value is an `IconParamsRule` object with no unknown fields.
---@type ShapeValidator<IconParamsRule>
_assembly.ParamsRule = V.shape({
	field = Common.non_empty_string:optional(),
	fields = V.array(Common.non_empty_string):not_empty(),
	check = V.func(),
	message = V.string():optional(),
})
	:strict()
	:describe_as("an IconParamsRule")

---A validator that checks that a value is an array of `IconParamsRule` objects.
_assembly.ParamsRules = V.array(_assembly.ParamsRule)

---Validates the arguments of `build`.
_assembly.check_build = V.signature("build", {
	{ "creator_name", Common.non_empty_string:optional() },
	{ "rules", _assembly.ParamsRules:optional() },
})

---Validates the arguments of `base`, `mask`, and `highlights`.
_assembly.check_layer_options = V.signature("icon_builder_layer", {
	{ "options", _assembly.LayerOptions:optional() },
})

---Validates the arguments of `layer`.
_assembly.check_layer = V.signature("layer", {
	{ "role", _assembly.Role },
	{ "options", _assembly.LayerOptions:optional() },
})

---Validates the arguments of `tinted_layer`.
_assembly.check_tinted_layer = V.signature("tinted_layer", {
	{ "role", _assembly.Role },
	{ "name", _assembly.ParamName },
	{ "options", _assembly.LayerOptions:optional() },
})

---Validates the arguments of `tinted`.
_assembly.check_tinted = V.signature("tinted", {
	{ "part", Common.non_empty_string },
})

---Validates the arguments of `tinted_part`.
_assembly.check_tinted_part = V.signature("tinted_part", {
	{ "part", Common.non_empty_string },
	{ "name", _assembly.ParamName },
})

---Validates the arguments of `keyed`.
_assembly.check_keyed = V.signature("keyed", {
	{ "name", _assembly.ParamName },
	{ "validator", V.table():describe_as("a validator") },
	{ "roles", V.array(_assembly.Role):not_empty():optional() },
})

-- State

---Creates a copy of the given state.
---@param state IconBuilderState
---@return IconBuilderState
---@nodiscard
function _assembly.copy_state(state)
	---@type IconBuilderState
	return {
		folder = state.folder,
		name = state.name,
		stem = state.stem,
		flat = state.flat,
		defaults_type = state.defaults_type,
		icon_size = state.icon_size,
		layers = util.copy(state.layers),
		keys = util.copy(state.keys),
	}
end

---Creates a layer from the given fields.
---@param role string?
---@param tint_param string?
---@param tint Color?
---@param options IconLayerOptions?
---@return IconBuilderLayer
---@nodiscard
function _assembly.new_layer(role, tint_param, tint, options)
	options = options or {}

	---@type IconBuilderLayer
	return {
		role = role,
		part = options.part,
		tint_param = tint_param,
		tint = tint or options.tint,
		icon_size = options.icon_size,
		requires = options.requires,
	}
end

---Creates an instance of the given `class` with the state of the given builder and the given
---layers appended.
---@param builder { state: IconBuilderState }
---@param layers IconBuilderLayer[]
---@param class table
---@return any
---@nodiscard
function _assembly.with_layers(builder, layers, class)
	local state = _assembly.copy_state(builder.state)
	for _, layer in ipairs(layers) do
		state.layers[#state.layers + 1] = layer
	end

	return setmetatable({ state = state }, class)
end

---Creates an instance of the given `class` with the state of the given builder and a key
---appended.
---@param builder { state: IconBuilderState }
---@param name string
---@param validator Validator<any>
---@param roles string[]?
---@param class table
---@return any
---@nodiscard
function _assembly.with_key(builder, name, validator, roles, class)
	local state = _assembly.copy_state(builder.state)

	---@type table<string, true>?
	local role_set
	if roles then
		role_set = {}
		for _, role in ipairs(roles) do
			role_set[role] = true
		end
	end

	state.keys[#state.keys + 1] = { name = name, validator = validator, roles = role_set }

	return setmetatable({ state = state }, class)
end

---Creates a `base` layer, tinted by `base_tint` and drawn whether or not one is given.
---@param options IconLayerOptions?
---@return IconBuilderLayer
---@nodiscard
function _assembly.base_layer(options)
	local layer = _assembly.new_layer(_assembly.role.base, "base_tint", nil, options)
	if layer.requires == nil then
		layer.requires = false
	end

	return layer
end

---Creates the base, mask, and highlights layers of the given `part`, tinted like the body of the
---icon.
---@param part string
---@return IconBuilderLayer[]
---@nodiscard
function _assembly.tinted_layers(part)
	return {
		_assembly.base_layer({ part = part }),
		_assembly.new_layer(_assembly.role.mask, "tint", nil, { part = part }),
		_assembly.new_layer(_assembly.role.highlights, nil, _assembly.ADDITIVE_TINT, { part = part, requires = "tint" }),
	}
end

---Creates the layers of a mask and highlights pair for the given `part`.
---@param part string
---@param tint_param string
---@return IconBuilderLayer[]
---@nodiscard
function _assembly.tinted_part_layers(part, tint_param)
	return {
		_assembly.new_layer(_assembly.role.mask, tint_param, nil, { part = part }),
		_assembly.new_layer(
			_assembly.role.highlights,
			nil,
			_assembly.ADDITIVE_TINT,
			{ part = part, requires = tint_param }
		),
	}
end

-- Assembly

---Gets the file name of the given layer.
---@param state IconBuilderState
---@param layer IconBuilderLayer
---@param params table<string, any>
---@return FileName
---@nodiscard
local function resolve_file_name(state, layer, params)
	local stem = state.stem or state.name
	for _, key in ipairs(state.keys) do
		if not key.roles or (layer.role and key.roles[layer.role]) then
			stem = stem .. "-" .. tostring(params[key.name])
		end
	end

	if state.flat then
		return state.folder .. "/" .. stem .. ".png"
	end

	local segments = { stem }
	if layer.part then
		segments[#segments + 1] = layer.part
	end
	segments[#segments + 1] = layer.role

	return state.folder .. "/" .. state.name .. "/" .. table.concat(segments, "-") .. ".png"
end

---Indicates whether the given layer is drawn for the given parameters.
---@param layer IconBuilderLayer
---@param index integer The position of the layer among the layers of the icon.
---@param params table<string, any>
---@return boolean
---@nodiscard
local function is_drawn(layer, index, params)
	local requires = layer.requires
	if requires == nil then
		requires = index > 1 and layer.tint_param or false
	end

	return not requires or params[requires] ~= nil
end

---Assembles the icon described by the given state for the given parameters.
---@param state IconBuilderState
---@param params table<string, any>
---@return SafeIconData[]
---@nodiscard
function _assembly.assemble(state, params)
	---@type IconData[]
	local icon_data = {}

	for index, layer in ipairs(state.layers) do
		if is_drawn(layer, index, params) then
			local tint = layer.tint
			if layer.tint_param and params[layer.tint_param] ~= nil then
				tint = params[layer.tint_param]
			end

			icon_data[#icon_data + 1] = {
				icon = resolve_file_name(state, layer, params),
				icon_size = layer.icon_size or state.icon_size,
				tint = tint,
			}
		end
	end

	assert(icon_data[1], string.format("The icon '%s' draws no layers for the given parameters.", state.name))

	return _sprite_utils.icons.add_missing_icons_defaults(icon_data, state.defaults_type)
end

---Creates the validation rule that applies the given parameter rules.
---@param rules IconParamsRule[]
---@param fields table<string, Validator<any>>
---@return ValidationRule<table>
---@nodiscard
local function rules_rule(rules, fields)
	return {
		id = "icon-builder.rules",
		describe = "consistent",
		check = function(value, ctx)
			-- A rule spanning parameters cannot handle a parameter of the wrong type; those are
			-- reported by the shape.
			for name, validator in pairs(fields) do
				if not validator:is_valid(value[name]) then
					return true
				end
			end

			local errors = {}
			for _, rule in ipairs(rules) do
				local args = {}
				for order, name in ipairs(rule.fields) do
					args[order] = value[name]
				end

				local ok, message = rule.check(table.unpack(args, 1, #rule.fields))
				if not ok then
					errors[#errors + 1] = {
						path = rule.field and (ctx.path .. "." .. rule.field) or ctx.path,
						message = message or string.format("must be %s", rule.message or "valid"),
					}
				end
			end

			if #errors == 0 then
				return true
			end

			return false, errors
		end,
	}
end

---Creates the function that draws the icon described by the given state.
---
---The parameters of the creator are the keys of the state, which are required, and the tint
---parameters of its layers, which are optional. A parameter name used twice is an error.
---@param state IconBuilderState
---@param creator_name string? Defaults to the name of the icon.
---@param rules IconParamsRule[]?
---@param optional boolean Whether the creator may be called without parameters.
---@return fun(params?: table<string, any>): SafeIconData[]
---@nodiscard
function _assembly.make_creator(state, creator_name, rules, optional)
	local name = creator_name or state.name

	if not state.layers[1] then
		error(string.format("The icon '%s' draws no layers.", state.name), 3)
	end

	---@type table<string, Validator<any>>
	local fields = {}

	---@param param_name string
	---@param validator Validator<any>
	local function declare(param_name, validator)
		if fields[param_name] then
			error(string.format("The icon '%s' declares the parameter '%s' twice.", state.name, param_name), 4)
		end

		fields[param_name] = validator
	end

	for _, key in ipairs(state.keys) do
		declare(key.name, key.validator)
	end

	-- Several layers may share one tint parameter; a key may not share its name with one.
	---@type table<string, true>
	local tint_params = {}
	for _, layer in ipairs(state.layers) do
		if layer.tint_param and not tint_params[layer.tint_param] then
			tint_params[layer.tint_param] = true
			declare(layer.tint_param, Common.color:optional())
		end
	end

	for index, rule in ipairs(rules or {}) do
		for _, field in ipairs(rule.fields) do
			if not fields[field] then
				error(
					string.format(
						"Rule %d of the icon '%s' names '%s', which is not one of its parameters.",
						index,
						state.name,
						field
					),
					3
				)
			end
		end

		if rule.field and not fields[rule.field] then
			error(
				string.format(
					"Rule %d of the icon '%s' reports against '%s', which is not one of its parameters.",
					index,
					state.name,
					rule.field
				),
				3
			)
		end
	end

	local shape = V.shape(fields):strict():describe_as("the parameters of the icon")
	if rules and rules[1] then
		shape = shape:extend(rules_rule(rules, fields))
	end
	if optional then
		shape = shape:optional()
	end

	local check = V.signature(name, {
		{ "params", shape },
	})

	return function(params)
		check(params)

		return _assembly.assemble(state, params or {})
	end
end

return _assembly
