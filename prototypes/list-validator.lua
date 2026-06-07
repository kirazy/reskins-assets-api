-- Import base Validator
local Validator = require("validator")

---A list-specific validator that extends the base Validator with array validation methods.
---@class ListValidator:Validator
---@field function_name string
---@field param_name string
---@field value table
local ListValidator = {}
ListValidator.__index = ListValidator

-- Set up inheritance from Validator
setmetatable(ListValidator, {
	__index = Validator,
})

---Creates a new ListValidator instance.
---@param value any[]
---@param param_name string
---@param function_name string?
---@return ListValidator
---@nodiscard
function ListValidator.validate(value, param_name, function_name)
	-- Call base Validator constructor
	local base_instance = Validator.validate(value, param_name, function_name)
	-- Convert to ListValidator
	setmetatable(base_instance, ListValidator)
	return base_instance --[[@as ListValidator]]
end

---Validates that the list has a minimum length.
---@param min_len integer The minimum length
---@return ListValidator Self for method chaining
function ListValidator:min_length(min_len)
	local len = #self.value
	if len < min_len then
		self:handle_invalid(string.format("must have at least %d elements, got %d", min_len, len))
	end
	return self
end

---Validates that the list has a maximum length.
---@param max_len integer The maximum length
---@return ListValidator Self for method chaining
function ListValidator:max_length(max_len)
	local len = #self.value
	if len > max_len then
		self:handle_invalid(string.format("must have at most %d elements, got %d", max_len, len))
	end
	return self
end

---Validates that the list length is within the specified range.
---@param min_len integer The minimum length
---@param max_len integer The maximum length
---@return ListValidator Self for method chaining
function ListValidator:length_in_range(min_len, max_len)
	local len = #self.value
	if len < min_len or len > max_len then
		self:handle_invalid(string.format("length must be between %d and %d elements, got %d", min_len, max_len, len))
	end
	return self
end

---Validates that the list contains a specific value.
---@param expected_value any The value to check for
---@return ListValidator Self for method chaining
function ListValidator:contains(expected_value)
	for _, value in pairs(self.value) do
		if value == expected_value then
			return self
		end
	end
	self:handle_invalid(string.format("must contain value '%s'", tostring(expected_value)))
	return self
end

---Validates that the list is not empty.
---@return ListValidator Self for method chaining
function ListValidator:not_empty()
	if #self.value == 0 then
		self:handle_invalid("must not be empty")
	end
	return self
end

---Validates that the list is empty.
---@return ListValidator Self for method chaining
function ListValidator:is_empty()
	if #self.value > 0 then
		self:handle_invalid(string.format("must be empty, got %d elements", #self.value))
	end
	return self
end

---Validates each element in the list using a validator function.
---@param element_validator fun(value: any, key: any): boolean A function that validates each element
---@param error_message string? Custom error message template (default: "element at key '%s' is invalid")
---@return ListValidator Self for method chaining
function ListValidator:each(element_validator, error_message)
	error_message = error_message or "element at key '%s' is invalid"

	for key, value in pairs(self.value) do
		if not element_validator(value, key) then
			self:handle_invalid(string.format(error_message, tostring(key)))
		end
	end
	return self
end

---Validates that all elements satisfy a predicate function.
---@param predicate fun(value: any, key: any): boolean A function that tests each element
---@param error_message string? Custom error message (default: "not all elements satisfy the condition")
---@return ListValidator Self for method chaining
function ListValidator:all(predicate, error_message)
	error_message = error_message or "not all elements satisfy the condition"

	for key, value in pairs(self.value) do
		if not predicate(value, key) then
			self:handle_invalid(string.format("%s (failed at key '%s')", error_message, tostring(key)))
		end
	end
	return self
end

---Validates that at least one element satisfies a predicate function.
---@param predicate fun(value: any, key: any): boolean A function that tests each element
---@param error_message string? Custom error message (default: "no elements satisfy the condition")
---@return ListValidator Self for method chaining
function ListValidator:any(predicate, error_message)
	error_message = error_message or "no elements satisfy the condition"

	for key, value in pairs(self.value) do
		if predicate(value, key) then
			return self -- Found at least one
		end
	end

	self:handle_invalid(error_message)
	return self
end

---Validates that no elements satisfy a predicate function.
---@param predicate fun(value: any, key: any): boolean A function that tests each element
---@param error_message string? Custom error message (default: "some elements satisfy the condition when none should")
---@return ListValidator Self for method chaining
function ListValidator:none(predicate, error_message)
	error_message = error_message or "some elements satisfy the condition when none should"

	for key, value in pairs(self.value) do
		if predicate(value, key) then
			self:handle_invalid(string.format("%s (failed at key '%s')", error_message, tostring(key)))
		end
	end
	return self
end

---Validates that exactly N elements satisfy a predicate function.
---@param predicate fun(value: any, index: integer): boolean A function that tests each element
---@param expected_count integer The expected number of elements that should satisfy the predicate
---@param error_message string? Custom error message template (default: "expected %d elements to satisfy condition, got %d")
---@return ListValidator Self for method chaining
function ListValidator:count(predicate, expected_count, error_message)
	error_message = error_message or "expected %d elements to satisfy condition, got %d"

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

---Validates that the list is sorted according to a comparison function.
---@param compare_fn fun(a: any, b: any): boolean? Optional comparison function (default: a <= b)
---@param error_message string? Custom error message (default: "list is not sorted")
---@return ListValidator Self for method chaining
function ListValidator:is_sorted(compare_fn, error_message)
	compare_fn = compare_fn or function(a, b)
		return a <= b
	end
	error_message = error_message or "list is not sorted"

	-- Collect all keys and sort them to ensure proper ordering
	local keys = {}
	for key, _ in pairs(self.value) do
		table.insert(keys, key)
	end
	table.sort(keys)

	-- Check if values are sorted according to the sorted keys
	for i = 2, #keys do
		local prev_key, curr_key = keys[i - 1], keys[i]
		if not compare_fn(self.value[prev_key], self.value[curr_key]) then
			self:handle_invalid(
				string.format(
					"%s (failed between keys '%s' and '%s')",
					error_message,
					tostring(prev_key),
					tostring(curr_key)
				)
			)
		end
	end
	return self
end

---Validates that all elements are of a specific type.
---@param expected_type string The expected type name
---@return ListValidator Self for method chaining
function ListValidator:all_of_type(expected_type)
	for key, value in pairs(self.value) do
		if type(value) ~= expected_type then
			self:handle_invalid(
				string.format("element at key '%s' must be a %s, got %s", tostring(key), expected_type, type(value))
			)
		end
	end
	return self
end

return ListValidator
