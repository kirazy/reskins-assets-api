-- Import base Validator
---@type Validator
local Validator = require("prototypes.Validator")

---A number-specific validator that extends the base Validator with number validation methods.
---@class NumberValidator:Validator
---@field function_name string
---@field param_name string
---@field value number
local NumberValidator = {}
NumberValidator.__index = NumberValidator

-- Set up inheritance from Validator
setmetatable(NumberValidator, {
	__index = Validator,
})

---Creates a new NumberValidator instance.
---@param value number
---@param param_name string
---@param function_name string?
---@return NumberValidator
function NumberValidator.validate(value, param_name, function_name)
	-- Call base Validator constructor
	local base_instance = Validator.validate(value, param_name, function_name):is_number()
	-- Convert to NumberValidator
	setmetatable(base_instance, NumberValidator)
	return base_instance --[[@as NumberValidator]]
end

---Validates that the number is an integer.
---@return NumberValidator Self for method chaining
function NumberValidator:is_integer()
	if self.value % 1 ~= 0 then
		self:handle_invalid(string.format("must be an integer, got %s", self.value))
	end
	return self
end

---Validates that the number is within the specified range (inclusive).
---@param min number The minimum allowed value
---@param max number The maximum allowed value
---@return NumberValidator Self for method chaining
function NumberValidator:in_range(min, max)
	if self.value < min or self.value > max then
		self:handle_invalid(string.format("must be between %d and %d (inclusive), got %d", min, max, self.value))
	end
	return self
end

---Validates that the number is not zero.
---@return NumberValidator Self for method chaining
function NumberValidator:not_zero()
	if self.value == 0 then
		self:handle_invalid("must not be zero")
	end
	return self
end

---Validates that the number is positive (greater than zero).
---@return NumberValidator Self for method chaining
function NumberValidator:is_positive()
	if self.value <= 0 then
		self:handle_invalid(string.format("must be positive, got %d", self.value))
	end
	return self
end

---Validates that the number is negative (less than zero).
---@return NumberValidator Self for method chaining
function NumberValidator:is_negative()
	if self.value >= 0 then
		self:handle_invalid(string.format("must be negative, got %d", self.value))
	end
	return self
end

---Validates that the number is greater than the specified minimum.
---@param min number The minimum value (exclusive)
---@return NumberValidator Self for method chaining
function NumberValidator:greater_than(min)
	if self.value <= min then
		self:handle_invalid(string.format("must be greater than %d, got %d", min, self.value))
	end
	return self
end

---Validates that the number is less than the specified maximum.
---@param max number The maximum value (exclusive)
---@return NumberValidator Self for method chaining
function NumberValidator:less_than(max)
	if self.value >= max then
		self:handle_invalid(string.format("must be less than %d, got %d", max, self.value))
	end
	return self
end

return NumberValidator
