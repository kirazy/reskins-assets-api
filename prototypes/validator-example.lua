-- Example usage of the centralized error handling system

local StringValidator = require("string-validator")
local NumberValidator = require("number-validator")
local Validator = require("validator")

-- Example function that validates parameters
local function example_function(name, age)
	-- Validate with default behavior (throws errors)
	StringValidator.validate(name, "name"):not_empty():min_length(2)
	NumberValidator.validate(age, "age"):is_positive():is_integer()

	print("Validation passed for:", name, age)
end

-- Example with error behavior configuration
local function example_with_logging()
	-- Switch to logging mode instead of throwing
	Validator.set_error_behavior("log")

	-- This will log errors instead of throwing
	StringValidator.validate("", "username"):not_empty() -- Will log but not throw
	NumberValidator.validate(-5, "count"):is_positive() -- Will log but not throw

	print("Continuing after validation errors were logged...")

	-- Switch back to throwing mode
	Validator.set_error_behavior("throw")

	-- This will throw an error as normal
	-- StringValidator.validate("", "required_field"):not_empty() -- Would throw
end

-- Example usage:
-- example_function("Alice", 25)  -- Passes validation
-- example_function("", 25)      -- Throws error: "example_function(): parameter 'name': must not be empty"
-- example_with_logging()        -- Logs errors but continues execution

return {
	example_function = example_function,
	example_with_logging = example_with_logging,
}
