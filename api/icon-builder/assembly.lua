---@using data
---@using Reskins.SpriteUtils
---@using Reskins.SpriteUtils.Validation

---@namespace Reskins.Assets

local _sprite_utils = {
	icons = require("__reskins-sprite-utils__.icons"),
}
local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")
local IconComposition = require("__reskins-sprite-utils__.icon-composition")

---Provides methods for assembling icons from the state of an icon builder, and for validating the arguments of its
---methods.
---
---The module is internal to the icon builders and `IconBuilderFactory`.
---@class IconBuilderAssembly
local _assembly = {}

---The tint of a `highlights` layer. The game renders an icon layer with a tint alpha of zero additively.
---@type Color
_assembly.ADDITIVE_TINT = { 1, 1, 1, 0 }

---Defines the roles of the layers of an icon.
---
---The role of a layer is the last segment of its file name, such as the `mask` in `boiler-fire-mask.png`.
---@enum IconRole
_assembly.role = {
	---The base layer of the icon.
	base = "base",

	---The mask layer of the icon.
	mask = "mask",

	---The highlights layer of the icon.
	highlights = "highlights",
}

---Defines the options for one layer of an icon.
---@class IconLayerOptions
---The segment of the file name that selects a group of layers within the icon, such as the `fire` in
---`boiler-fire-mask.png`. Default `nil`.
---@field part? string
---The tint of the layer when no parameter tints it. The layer added by `highlights` ignores this field. Default `nil`.
---@field tint? Color
---The size of the square file of the layer, in pixels. If `nil`, the size of the icon is used.
---@field icon_size? SpriteSizeType
---The name of the parameter without which the layer is omitted, or `false` to include the layer always. If `nil`, the
---layer requires the parameter that tints it, unless it is a base layer added by `base` or `tinted`, or is the first
---layer of the icon.
---@field requires? string|false

---Defines a rule that checks several parameters of an icon together.
---@class IconParamsRule
---The name of the parameter against which a failure is reported. If `nil`, a failure is reported against the parameters
---as a whole.
---@field field? string
---The names of the parameters passed to `check`, in order.
---@field fields string[]
---A function that receives the values of the parameters named by `fields`, in order, and returns `true` if they are
---valid together; otherwise, `false` and an optional error message that replaces `message`.
---@field check fun(...): boolean, string?
---The requirement that the parameters must satisfy, as a phrase that follows "must be", such as
---`"a supported combination"`. The message is used when `check` returns no error message. Default `"valid"`.
---@field message? string

---Defines one layer of an icon, as recorded by a builder.
---@class IconBuilderLayer
---The role of the layer, which is the last segment of its file name. The field is `nil` for the layer of a flat icon.
---@field role? string
---The segment of the file name before the role, if any.
---@field part? string
---The name of the parameter that tints the layer. The field is `nil` when no parameter tints the layer.
---@field tint_param? string
---The tint of the layer when no parameter tints it.
---@field tint? Color
---The size of the square file of the layer, in pixels. The field is `nil` when the layer uses the size of the icon.
---@field icon_size? SpriteSizeType
---The name of the parameter that the layer requires, or `false` when the layer is always included. The field is `nil`
---when the layer takes the default described by `IconLayerOptions.requires`.
---@field requires? string|false

---Defines a selection of the layers of an icon by part, or by part and role.
---@class IconLayerSelector
---The part of the selected layers.
---@field part string
---The role of the selected layer. If `nil`, every layer of `part` is selected.
---@field role? IconRole|string

---Defines a selection of the layers of an icon, as recorded by a builder.
---@class IconBuilderSelector
---The role of the selected layers. The field is `nil` when every layer of `part` is selected.
---@field role? string
---The part of the selected layers. The field is `nil` when the layers with no part are selected.
---@field part? string

---Defines a parameter that selects the artwork of an icon, as recorded by a builder.
---@class IconBuilderKey
---The name of the parameter.
---@field name string
---The validator for the values of the parameter.
---@field validator Validator<any>
---The layers for which the value of the parameter is appended to the file name. The field is `nil` when the value is
---appended for every layer.
---@field layers? IconBuilderSelector[]

---Defines the state of an icon builder.
---@class IconBuilderState
---The path of the folder containing the artwork.
---@field folder string
---The name of the icon.
---@field name string
---The stem of the file names. The field is `nil` when the name of the icon is used as the stem.
---@field stem? string
---When `true`, indicates that the icon has one layer, taken from a single file.
---@field flat boolean
---The name of the type-specific icon defaults.
---@field defaults_type? IconDefaultsType
---The size of the square files of the layers, in pixels, if set.
---@field icon_size? SpriteSizeType
---The layers of the icon, in draw order.
---@field layers IconBuilderLayer[]
---The parameters that select the artwork, in the order in which their values are appended to the file name.
---@field keys IconBuilderKey[]

---A validator that checks that a value is an icon name.
_assembly.IconName = Common.non_empty_string:describe_as("an icon name")

---A validator that checks that a value is an icon role.
_assembly.Role = Common.non_empty_string:describe_as("an icon role")

---A validator that checks that a value is a parameter name.
_assembly.ParamName = Common.non_empty_string:describe_as("a parameter name")

---A validator that checks that a value is an `IconLayerOptions` object with no unknown fields.
---@type StructValidator<IconLayerOptions>
_assembly.LayerOptions = V.struct({
	part = Common.non_empty_string:optional(),
	tint = Common.color:optional(),
	icon_size = Common.sprite_size:optional(),
	requires = V.any_of(Common.non_empty_string, V.literal(false)):optional(),
})
	:strict()
	:describe_as("an IconLayerOptions")

---A validator that checks that a value is an `IconParamsRule` object with no unknown fields.
---@type StructValidator<IconParamsRule>
_assembly.ParamsRule = V.struct({
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

---Validates the arguments of `base`.
_assembly.check_base = V.signature("base", {
	{ "options", _assembly.LayerOptions:optional() },
})

---Validates the arguments of `mask`.
_assembly.check_mask = V.signature("mask", {
	{ "options", _assembly.LayerOptions:optional() },
})

---Validates the arguments of `highlights`.
_assembly.check_highlights = V.signature("highlights", {
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

---A validator that checks that a value is a role, or an `IconLayerSelector` object with no unknown fields.
_assembly.LayerSelector = V.any_of(
	_assembly.Role,
	V.struct({
		part = Common.non_empty_string,
		role = _assembly.Role:optional(),
	})
		:strict()
		:describe_as("an IconLayerSelector")
):describe_as("an icon role or an IconLayerSelector")

---Validates the arguments of `keyed`.
_assembly.check_keyed = V.signature("keyed", {
	{ "name", _assembly.ParamName },
	{ "validator", V.table():describe_as("a validator") },
	{ "layers", V.array(_assembly.LayerSelector):not_empty():optional() },
})

---Creates a copy of the given `state`.
---@param state IconBuilderState The state to copy.
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

---Creates a layer with the given `role`, `tint_param`, and `tint`, and the fields of the given `options`.
---@param role? string The role of the layer, or `nil` for the layer of a flat icon.
---@param tint_param? string The name of the parameter that tints the layer.
---@param tint? Color The tint of the layer. If given, `options.tint` is ignored.
---@param options? IconLayerOptions The options for the layer.
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

---Creates an instance of the given `class` with the state of the given builder and the given `layers` appended.
---@param builder { state: IconBuilderState } The builder from which the state is copied.
---@param layers IconBuilderLayer[] The layers to append.
---@param class table The class of the new instance.
---@return any
---@nodiscard
function _assembly.with_layers(builder, layers, class)
	local state = _assembly.copy_state(builder.state)
	for _, layer in pairs(layers) do
		state.layers[#state.layers + 1] = layer
	end

	return setmetatable({ state = state }, class)
end

---Creates an instance of the given `class` with the state of the given builder and a key appended.
---@param builder { state: IconBuilderState } The builder from which the state is copied.
---@param name string The name of the parameter.
---@param validator Validator<any> The validator for the values of the parameter.
---@param layers? (string|IconLayerSelector)[] The layers for which the value of the parameter is appended to the file name. If `nil`, the value is appended for every layer.
---@param class table The class of the new instance.
---@return any
---@nodiscard
function _assembly.with_key(builder, name, validator, layers, class)
	local state = _assembly.copy_state(builder.state)

	---@type IconBuilderSelector[]?
	local selectors
	if layers then
		selectors = {}
		for index, layer in pairs(layers) do
			if type(layer) == "string" then
				selectors[index] = { role = layer }
			else
				selectors[index] = { role = layer.role, part = layer.part }
			end
		end
	end

	state.keys[#state.keys + 1] = { name = name, validator = validator, layers = selectors }

	return setmetatable({ state = state }, class)
end

---Creates a `base` layer, tinted by the `base_tint` parameter when one is given.
---
---The layer is always included, unless `options.requires` names a parameter.
---@param options? IconLayerOptions The options for the layer.
---@return IconBuilderLayer
---@nodiscard
function _assembly.base_layer(options)
	local layer = _assembly.new_layer(_assembly.role.base, "base_tint", nil, options)
	if layer.requires == nil then
		layer.requires = false
	end

	return layer
end

---Creates the `base`, `mask`, and `highlights` layers of the given `part`, with the base layer tinted by the
---`base_tint` parameter and the mask layer tinted by the `tint` parameter.
---@param part string The segment of the file name that selects the layers.
---@return IconBuilderLayer[]
---@nodiscard
function _assembly.tinted_layers(part)
	return {
		_assembly.base_layer({ part = part }),
		_assembly.new_layer(_assembly.role.mask, "tint", nil, { part = part }),
		_assembly.new_layer(_assembly.role.highlights, nil, _assembly.ADDITIVE_TINT, { part = part, requires = "tint" }),
	}
end

---Creates the `mask` and `highlights` layers of the given `part`, with the mask layer tinted by the parameter named
---`tint_param`.
---@param part string The segment of the file name that selects the layers.
---@param tint_param string The name of the parameter that tints the mask layer.
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

---Indicates whether the given `selector` selects the given `layer`.
---@param selector IconBuilderSelector
---@param layer IconBuilderLayer
---@return boolean
---@nodiscard
local function is_selected(selector, layer)
	return layer.part == selector.part and (selector.role == nil or layer.role == selector.role)
end

---Indicates whether the value of the given `key` is appended to the file name of the given `layer`.
---@param key IconBuilderKey
---@param layer IconBuilderLayer
---@return boolean
---@nodiscard
local function is_keyed(key, layer)
	if not key.layers then
		return true
	end

	for _, selector in pairs(key.layers) do
		if is_selected(selector, layer) then
			return true
		end
	end

	return false
end

---Gets a description of the given `selector` for error messages.
---@param selector IconBuilderSelector
---@return string
---@nodiscard
local function describe_selector(selector)
	if not selector.part then
		return string.format("the role '%s'", selector.role)
	elseif not selector.role then
		return string.format("the part '%s'", selector.part)
	end

	return string.format("the role '%s' of the part '%s'", selector.role, selector.part)
end

---Gets the file name of the given `layer` for the given `params`.
---@param state IconBuilderState
---@param layer IconBuilderLayer
---@param params table<string, any>
---@return FileName
---@nodiscard
local function resolve_file_name(state, layer, params)
	local stem = state.stem or state.name
	for _, key in pairs(state.keys) do
		if is_keyed(key, layer) then
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

---Indicates whether the given `layer` is included for the given `params`.
---@param layer IconBuilderLayer
---@param index integer
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

---Creates the icon described by the given `state` for the given `params`.
---@param state IconBuilderState The state of the builder.
---@param params table<string, any> The parameters given to the creator.
---@return SafeIconData[]
---@nodiscard
function _assembly.assemble(state, params)
	---@type IconData[]
	local icon_data = {}

	for index, layer in pairs(state.layers) do
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

	if not icon_data[1] then
		error(string.format("The icon '%s' has no layers for the given parameters.", state.name), 3)
	end

	return _sprite_utils.icons.add_missing_icons_defaults(icon_data, state.defaults_type)
end

---Creates the validation rule that applies the given `rules` to the parameters of a creator.
---@param rules IconParamsRule[]
---@param fields table<string, Validator<any>>
---@return ValidationRule<table>
---@nodiscard
local function rules_rule(rules, fields)
	return {
		id = "icon-builder.rules",
		describe = "consistent",
		check = function(value, ctx)
			-- Skip the rules when a parameter has the wrong type. The struct validator reports that error.
			for name, validator in pairs(fields) do
				if not validator:is_valid(value[name]) then
					return true
				end
			end

			local errors = {}
			for _, rule in pairs(rules) do
				local args = {}
				for order, name in pairs(rule.fields) do
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

---Creates a composition with the given `icon_data` in the canvas group, with the icon defaults type of the given
---`state`.
---@param icon_data SafeIconData[] The icon to add.
---@param state IconBuilderState The state from which the icon was created.
---@return IconComposition
---@nodiscard
function _assembly.as_composition(icon_data, state)
	return IconComposition:from_icons(icon_data, nil, state.defaults_type)
end

---Creates a function that returns the icon described by the given `state`.
---
---Each key of the given `state` is a required parameter of the creator, and each parameter that tints a layer is
---optional.
---@param state IconBuilderState The state of the builder.
---@param creator_name? string The name of the creator in error messages. If `nil`, the name of the icon is used.
---@param rules? IconParamsRule[] The rules that check several parameters together.
---@param optional boolean When `true`, indicates that the creator can be called without parameters.
---@param finish? fun(icon_data: SafeIconData[], state: IconBuilderState): any The function that converts the icon to the result of the creator. If `nil`, the creator returns the icon.
---@return fun(params?: table<string, any>): any
---@nodiscard
function _assembly.make_creator(state, creator_name, rules, optional, finish)
	local name = creator_name or state.name

	if not state.layers[1] then
		error(string.format("The icon '%s' has no layers.", state.name), 3)
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

	for _, key in pairs(state.keys) do
		declare(key.name, key.validator)
	end

	-- Declare each tint parameter once, since several layers can share it. A key with the name of a tint parameter is an
	-- error.
	---@type table<string, true>
	local tint_params = {}
	for _, layer in pairs(state.layers) do
		if layer.tint_param and not tint_params[layer.tint_param] then
			tint_params[layer.tint_param] = true
			declare(layer.tint_param, Common.color:optional())
		end
	end

	for _, key in pairs(state.keys) do
		for _, selector in pairs(key.layers or {}) do
			local found = false
			for _, layer in pairs(state.layers) do
				if is_selected(selector, layer) then
					found = true
					break
				end
			end

			if not found then
				error(
					string.format(
						"The key '%s' of the icon '%s' selects %s, which no layer of the icon has.",
						key.name,
						state.name,
						describe_selector(selector)
					),
					3
				)
			end
		end
	end

	for index, rule in pairs(rules or {}) do
		for _, field in pairs(rule.fields) do
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

	local struct = V.struct(fields):strict():describe_as("the parameters of the icon")
	if rules and rules[1] then
		struct = struct:extend(rules_rule(rules, fields))
	end
	if optional then
		struct = struct:optional() --[[@as StructValidator<any>]]
	end

	local check = V.signature(name, {
		{ "params", struct },
	})

	return function(params)
		check(params)

		local icon_data = _assembly.assemble(state, params or {})
		if finish then
			return finish(icon_data, state)
		end

		return icon_data
	end
end

return _assembly
