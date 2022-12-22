module RequiredParams
  # Very basic auth and permissions, needs to be refined
    ParamsError = Class.new(ActionController::BadRequest)

    extend ActiveSupport::Concern

    # Check if a set of params exists and throws an error otherwise
    # Returns the params values in the same order as the arguments
    def require_params!(*args)
      args.each do |param_name| 
        message_missing = I18n.t("errors.params.missing", param_name: param_name)
        raise ParamsError.new(message_missing) unless params[param_name]
      end

      if args.length > 1
        params.values_at(*args)
      else
        params[args.first]
      end
    end

    # Check if a param validates a condition and throws an error otherwise
    # Returns the param's value
    def check_param!(param_name, &block)
      message_invalid = I18n.t("errors.params.invalid", param_name: param_name)

      if params[param_name]
        raise ParamsError.new(message_invalid) unless block.call(params[param_name])
      end

      params[param_name]
    end
end