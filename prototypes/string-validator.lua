-- Import base Validator
local Validator = require("prototypes.Validator")

---A string-specific validator that extends the base Validator with string validation methods.
---@class StringValidator:Validator
---@field function_name string
---@field param_name string
---@field value string
local StringValidator = {}
StringValidator.__index = StringValidator

-- Set up inheritance from Validator
setmetatable(StringValidator, {
	__index = Validator,
})

---Creates a new StringValidator instance.
---@param value string
---@param param_name string
---@param function_name string?
---@return StringValidator
function StringValidator.validate(value, param_name, function_name)
	-- Call base Validator constructor
	local base_instance = Validator.validate(value, param_name, function_name):is_string()
	-- Convert to StringValidator
	setmetatable(base_instance, StringValidator)
	return base_instance --[[@as StringValidator]]
end

---Validates that the string has a minimum length.
---@param min_len integer The minimum length
---@return StringValidator Self for method chaining
function StringValidator:min_length(min_len)
	if #self.value < min_len then
		self:handle_invalid(string.format("must be at least %d characters long, got %d", min_len, #self.value))
	end
	return self
end

---Validates that the string has a maximum length.
---@param max_len integer The maximum length
---@return StringValidator Self for method chaining
function StringValidator:max_length(max_len)
	if #self.value > max_len then
		self:handle_invalid(string.format("must be at most %d characters long, got %d", max_len, #self.value))
	end
	return self
end

---Validates that the string length is within the specified range.
---@param min_len integer The minimum length
---@param max_len integer The maximum length
---@return StringValidator Self for method chaining
function StringValidator:length_in_range(min_len, max_len)
	local len = #self.value
	if len < min_len or len > max_len then
		self:handle_invalid(string.format("length must be between %d and %d characters, got %d", min_len, max_len, len))
	end
	return self
end

---Validates that the string matches a pattern.
---@param pattern string The Lua pattern to match
---@return StringValidator Self for method chaining
function StringValidator:matches_pattern(pattern)
	if not string.match(self.value, pattern) then
		self:handle_invalid(string.format("must match pattern '%s', got '%s'", pattern, self.value))
	end
	return self
end

---Validates that the string starts with a prefix.
---@param prefix_str string The prefix to check for
---@return StringValidator Self for method chaining
function StringValidator:starts_with(prefix_str)
	if not string.find(self.value, "^" .. prefix_str) then
		self:handle_invalid(string.format("must start with '%s', got '%s'", prefix_str, self.value))
	end
	return self
end

---Validates that the string ends with a suffix.
---@param suffix_str string The suffix to check for
---@return StringValidator Self for method chaining
function StringValidator:ends_with(suffix_str)
	if not string.find(self.value, suffix_str .. "$") then
		self:handle_invalid(string.format("must end with '%s', got '%s'", suffix_str, self.value))
	end
	return self
end

---Validates that the string contains a substring.
---@param substring string The substring to check for
---@return StringValidator Self for method chaining
function StringValidator:contains(substring)
	if not string.find(self.value, substring, 1, true) then
		self:handle_invalid(string.format("must contain '%s', got '%s'", substring, self.value))
	end
	return self
end

---Validates that the string is not empty.
---@return StringValidator Self for method chaining
function StringValidator:not_empty()
	if self.value == "" then
		self:handle_invalid("must not be empty")
	end
	return self
end

---Validates that the string is empty.
---@return StringValidator Self for method chaining
function StringValidator:is_empty()
	if self.value ~= "" then
		self:handle_invalid(string.format("must be empty, got '%s'", self.value))
	end
	return self
end

---Validates that the value is a member of the collection.
---@param values string[]
---@return StringValidator Self for method chaining
function StringValidator:is_one_of(values)
	for _, v in pairs(values) do
		if self.value == v then
			return self
		end
	end

	self:handle_invalid(string.format("must be one of %s, got '%s'", serpent.line(values), self.value))
	return self
end

return StringValidator
