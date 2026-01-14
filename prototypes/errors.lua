local function get_prefix(fn_name, param_name)
	return string.format("Invalid param in %s: '%s'", fn_name, param_name)
end

local _errors = {}
function _errors.throw_if_out_of_range(fn_name, param_name, value, min, max)
	_errors.throw_if_not_number(fn_name, param_name, value)
	if value < min or value > max then
		local prefix = get_prefix(fn_name, param_name)
		error(string.format("%s must be between %d and %d inclusive, got %d", prefix, min, max, value))
	end
end
function _errors.throw_if_nil(fn_name, param_name, value)
	if value == nil then
		local prefix = get_prefix(fn_name, param_name)
		error(string.format("%s must not be nil", prefix))
	end
end

function _errors.throw_if_not_integer(fn_name, param_name, value)
	_errors.throw_if_not_number(fn_name, param_name, value)
	if value % 1 ~= 0 then
		local prefix = get_prefix(fn_name, param_name)
		error(string.format("%s must be an integer, got %s", prefix, value))
	end
end

function _errors.throw_if_not_number(fn_name, param_name, value)
	if type(value) ~= "number" then
		local prefix = get_prefix(fn_name, param_name)
		error(string.format("%s must be a number, got %s", prefix, type(value)))
	end
end
function _errors.throw_if_zero(fn_name, param_name, value)
	_errors.throw_if_not_number(fn_name, param_name, value)
	if value == 0 then
		local prefix = get_prefix(fn_name, param_name)
		error(string.format("%s must not be zero", prefix))
	end
end

return _errors
