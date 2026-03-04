-- Import base Validator
local Validator = require("prototypes.Validator")

---A dictionary-specific validator that extends the base Validator with table/object validation methods.
---@class DictValidator:Validator
---@field function_name string
---@field param_name string
---@field value table
local DictValidator = {}
DictValidator.__index = DictValidator

-- Set up inheritance from Validator
setmetatable(DictValidator, {
	__index = Validator,
})

---Creates a new DictValidator instance.
---@param value table
---@param param_name string
---@param function_name string?
---@return DictValidator
---@nodiscard
function DictValidator.validate(value, param_name, function_name)
	-- Call base Validator constructor
	local base_instance = Validator.validate(value, param_name, function_name)
	-- Convert to DictValidator
	setmetatable(base_instance, DictValidator)
	return base_instance --[[@as DictValidator]]
end

---Validates that the dictionary has a specific key.
---@param key any The key to check for
---@return DictValidator Self for method chaining
function DictValidator:has_key(key)
	if self.value[key] == nil then
		self:handle_invalid(string.format("must have key '%s'", tostring(key)))
	end
	return self
end

---Validates that the dictionary has all the specified keys.
---@param keys any[] The keys to check for
---@return DictValidator Self for method chaining
function DictValidator:has_keys(keys)
	for _, key in ipairs(keys) do
		if self.value[key] == nil then
			self:handle_invalid(string.format("must have key '%s'", tostring(key)))
		end
	end
	return self
end

---Validates that the dictionary doesn't have a specific key.
---@param key any The key to check for absence
---@return DictValidator Self for method chaining
function DictValidator:not_has_key(key)
	if self.value[key] ~= nil then
		self:handle_invalid(string.format("must not have key '%s'", tostring(key)))
	end
	return self
end

---Validates that the dictionary is not empty.
---@return DictValidator Self for method chaining
function DictValidator:not_empty()
	if next(self.value) == nil then
		self:handle_invalid("must not be empty")
	end
	return self
end

---Validates that the dictionary is empty.
---@return DictValidator Self for method chaining
function DictValidator:is_empty()
	if next(self.value) ~= nil then
		self:handle_invalid("must be empty")
	end
	return self
end

---Validates each value in the dictionary using a validator function.
---@param value_validator fun(value: any, key: any): boolean A function that validates each value
---@param error_message string? Custom error message template (default: "value at key '%s' is invalid")
---@return DictValidator Self for method chaining
function DictValidator:each_value(value_validator, error_message)
	error_message = error_message or "value at key '%s' is invalid"

	for key, value in pairs(self.value) do
		if not value_validator(value, key) then
			self:handle_invalid(string.format(error_message, tostring(key)))
		end
	end
	return self
end

---Validates each key in the dictionary using a validator function.
---@param key_validator fun(key: any, value: any): boolean A function that validates each key
---@param error_message string? Custom error message template (default: "key '%s' is invalid")
---@return DictValidator Self for method chaining
function DictValidator:each_key(key_validator, error_message)
	error_message = error_message or "key '%s' is invalid"

	for key, value in pairs(self.value) do
		if not key_validator(key, value) then
			self:handle_invalid(string.format(error_message, tostring(key)))
		end
	end
	return self
end

---Validates that all values are of a specific type.
---@param expected_type string The expected type name
---@return DictValidator Self for method chaining
function DictValidator:all_values_of_type(expected_type)
	for key, value in pairs(self.value) do
		if type(value) ~= expected_type then
			self:handle_invalid(
				string.format("value at key '%s' must be a %s, got %s", tostring(key), expected_type, type(value))
			)
		end
	end
	return self
end

---Validates that all keys are of a specific type.
---@param expected_type string The expected type name
---@return DictValidator Self for method chaining
function DictValidator:all_keys_of_type(expected_type)
	for key, _ in pairs(self.value) do
		if type(key) ~= expected_type then
			self:handle_invalid(string.format("key '%s' must be a %s, got %s", tostring(key), expected_type, type(key)))
		end
	end
	return self
end

---Validates that all key-value pairs satisfy a predicate function.
---@param predicate fun(value: any, key: any): boolean A function that tests each key-value pair
---@param error_message string? Custom error message (default: "not all key-value pairs satisfy the condition")
---@return DictValidator Self for method chaining
function DictValidator:all_pairs(predicate, error_message)
	error_message = error_message or "not all key-value pairs satisfy the condition"

	for key, value in pairs(self.value) do
		if not predicate(value, key) then
			self:handle_invalid(string.format("%s (failed at key '%s')", error_message, tostring(key)))
		end
	end
	return self
end

---Validates that all values satisfy a predicate function.
---@param predicate fun(value: any, key: any): boolean A function that tests each value
---@param error_message string? Custom error message (default: "not all values satisfy the condition")
---@return DictValidator Self for method chaining
function DictValidator:all_values(predicate, error_message)
	error_message = error_message or "not all values satisfy the condition"

	for key, value in pairs(self.value) do
		if not predicate(value, key) then
			self:handle_invalid(string.format("%s (failed at key '%s')", error_message, tostring(key)))
		end
	end
	return self
end

---Validates that all keys satisfy a predicate function.
---@param predicate fun(key: any, value: any): boolean A function that tests each key
---@param error_message string? Custom error message (default: "not all keys satisfy the condition")
---@return DictValidator Self for method chaining
function DictValidator:all_keys(predicate, error_message)
	error_message = error_message or "not all keys satisfy the condition"

	for key, value in pairs(self.value) do
		if not predicate(key, value) then
			self:handle_invalid(string.format("%s (failed at key '%s')", error_message, tostring(key)))
		end
	end
	return self
end

---Validates that at least one key-value pair satisfies a predicate function.
---@param predicate fun(value: any, key: any): boolean A function that tests each key-value pair
---@param error_message string? Custom error message (default: "no key-value pairs satisfy the condition")
---@return DictValidator Self for method chaining
function DictValidator:any_pairs(predicate, error_message)
	error_message = error_message or "no key-value pairs satisfy the condition"

	for key, value in pairs(self.value) do
		if predicate(value, key) then
			return self -- Found at least one
		end
	end

	self:handle_invalid(error_message)
	return self
end

---Validates that at least one value satisfies a predicate function.
---@param predicate fun(value: any, key: any): boolean A function that tests each value
---@param error_message string? Custom error message (default: "no values satisfy the condition")
---@return DictValidator Self for method chaining
function DictValidator:any_values(predicate, error_message)
	error_message = error_message or "no values satisfy the condition"

	for key, value in pairs(self.value) do
		if predicate(value, key) then
			return self -- Found at least one
		end
	end

	self:handle_invalid(error_message)
	return self
end

---Validates that no key-value pairs satisfy a predicate function.
---@param predicate fun(value: any, key: any): boolean A function that tests each key-value pair
---@param error_message string? Custom error message (default: "some key-value pairs satisfy the condition when none should")
---@return DictValidator Self for method chaining
function DictValidator:none_pairs(predicate, error_message)
	error_message = error_message or "some key-value pairs satisfy the condition when none should"

	for key, value in pairs(self.value) do
		if predicate(value, key) then
			self:handle_invalid(string.format("%s (failed at key '%s')", error_message, tostring(key)))
		end
	end
	return self
end

---Validates that exactly N key-value pairs satisfy a predicate function.
---@param predicate fun(value: any, key: any): boolean A function that tests each key-value pair
---@param expected_count integer The expected number of pairs that should satisfy the predicate
---@param error_message string? Custom error message template (default: "expected %d pairs to satisfy condition, got %d")
---@return DictValidator Self for method chaining
function DictValidator:count_pairs(predicate, expected_count, error_message)
	error_message = error_message or "expected %d pairs to satisfy condition, got %d"

	local actual_count = 0
	for key, value in pairs(self.value) do
		if predicate(value, key) then
			actual_count = actual_count + 1
		end
	end

	if actual_count ~= expected_count then
		self:handle_invalid(string.format(error_message, expected_count, actual_count))
	end
	return self
end

return DictValidator
