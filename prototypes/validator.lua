---A validator object that provides chainable parameter validation methods.
---@class Validator
---@field function_name string The function name for error messages
---@field param_name string The parameter name for error messages
---@field value any The value being validated
local Validator = {}
Validator.__index = Validator

-- Configuration for error handling behavior
-- "throw" = throw errors (default), "log" = log errors without throwing
---@type "throw"|"log"
Validator.error_behavior = "throw"

-- Registry for validator classes to check in get_error_level
---@type table<string, table>
Validator._validator_classes = {}

---Gets the name of the calling function using debug information.
---@param level integer? Stack level to inspect (default: 3 for typical usage)
---@return string Function name or "<unknown>" if not available
---@private
function Validator.get_calling_function_name(level)
	level = level or 3 -- Default: validate() -> get_calling_function_name() -> actual caller
	local info = debug and debug.getinfo(level, "n")
	return (info and info.name) or "<unknown>"
end

---Creates a new Validator instance for the specified value, parameter, and function.
---@param value any The value to validate
---@param param_name string The name of the parameter being validated
---@param function_name string? The name of the function being validated (auto-detected if not provided)
---@return Validator
function Validator.validate(value, param_name, function_name)
	-- Handle overloaded call where function_name is not provided - auto-detect it
	if function_name == nil then
		-- Called as validate(value, param_name) - auto-detect function name
		local auto_fn_name = Validator.get_calling_function_name()
		local instance = {
			function_name = auto_fn_name,
			param_name = param_name,
			value = value,
		} --[[@as Validator]]
		setmetatable(instance, Validator)
		return instance
	else
		-- Called as validate(value, param_name, function_name) - explicit function name
		local instance = {
			function_name = function_name,
			param_name = param_name,
			value = value,
		} --[[@as Validator]]
		setmetatable(instance, Validator)
		return instance
	end
end

---Gets the error message prefix for this validator.
---@return string
---@protected
function Validator:get_prefix()
	return string.format("%s(): parameter '%s'", self.function_name, self.param_name)
end

---Finds the appropriate error level to point to the original caller, not internal Validator methods.
---@return integer The stack level for error reporting
---@protected
function Validator:get_error_level()
	local level = 2
	while true do
		local info = debug and debug.getinfo(level, "f")
		if not info then
			-- Fallback if we can't get debug info
			return 2
		end

		-- Check if this frame belongs to any registered validator method
		local is_validator_method = false

		-- Check base Validator methods
		for name, method in pairs(Validator) do
			if info.func == method then
				is_validator_method = true
				break
			end
		end

		-- Simple check for validator methods by checking if method exists on Validator
		if not is_validator_method then
			local method_name = info.name
			if
				method_name and (Validator[method_name] or (getmetatable(self) and getmetatable(self).__index[method_name]))
			then
				is_validator_method = true
			end
		end

		-- If this frame is not a validator method, this is our target
		if not is_validator_method then
			return level
		end

		level = level + 1
	end
end

---Sets the error behavior for all validators.
---@param behavior "throw"|"log" Whether to throw errors or just log them
function Validator.set_error_behavior(behavior)
	Validator.error_behavior = behavior
end

---Handles invalid values according to the configured error behavior.
---@param message string The error message to display
---@protected
function Validator:handle_invalid(message)
	local full_message = string.format("%s: %s", self:get_prefix(), message)

	if Validator.error_behavior == "log" then
		-- Just log the error without throwing
		log(full_message)
	else
		-- Default behavior: throw the error
		error(full_message, self:get_error_level())
	end
end

---Validates that the value is not nil.
---@return Validator Self for method chaining
function Validator:not_nil()
	if self.value == nil then
		self:handle_invalid("must not be nil")
	end
	return self
end

---Validates that the value is of the specified type.
---@param expected_type string The expected type name
---@return Validator Self for method chaining
function Validator:is_type(expected_type)
	local actual_type = type(self.value)
	if actual_type ~= expected_type then
		self:handle_invalid(string.format("must be a %s, got %s", expected_type, actual_type))
	end
	return self
end

---Validates that the value is a string.
---@return Validator Self for method chaining
function Validator:is_string()
	return self:is_type("string")
end

---Validates that the value is a number.
---@return Validator Self for method chaining
function Validator:is_number()
	return self:is_type("number")
end

---Validates that the value is a table.
---@return Validator Self for method chaining
function Validator:is_table()
	return self:is_type("table")
end

---Validates that the value is a boolean.
---@return Validator Self for method chaining
function Validator:is_boolean()
	return self:is_type("boolean")
end

return Validator
