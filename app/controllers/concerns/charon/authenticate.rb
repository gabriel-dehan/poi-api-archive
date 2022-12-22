module Charon
  # Layer over middleware Charon defined in lib/middlewares
  # Very basic auth and permissions, needs to be refined
  module Authenticate
    NotAuthorized = Class.new(StandardError)

    extend ActiveSupport::Concern

    included do
      before_action :helpers_initialize
      # before_action :is_internal, only: [:index]

      helper_method :current_application
      helper_method :has_internal_access?
      helper_method :has_public_access?
      helper_method :has_private_access?
    end

    class_methods do
      # :public or :private
      def access_level(level, opts = {})
        needs_private_access_defined = _process_action_callbacks.select {|f| f.filter == :needs_private_access! }[0]

        if level == :public
          # If access_level(:private) was defined we skip it
          send(:skip_before_action, :needs_private_access!, opts) if needs_private_access_defined
          send(:before_action, :needs_public_access!, opts)
        elsif level == :private
          # Here we don't need to skip public because if you have private access you have public access
          send(:before_action, :needs_private_access!, opts)
        else
          raise ArgumentError, "Incorrect access level."
        end
      end

      # true or false
      def internal_only(internal, opts = {})
        needs_internal_access_defined = _process_action_callbacks.select {|f| f.filter == :needs_internal_access! }[0]

        if internal
          send(:before_action, :needs_internal_access!, opts)
        elsif needs_internal_access_defined # is not supposed to be internal and the internal check is already defined, we skip it
          send(:skip_before_action, :needs_internal_access!, opts)
        end
      end
    end

    def needs_internal_access!
      raise NotAuthorized, "This is an internal endpoint, the provided API Key doesn't have the necessary rights. You need a specific Poi Internal API Token to access it." unless has_internal_access?
    end

    def needs_private_access!
      raise NotAuthorized, "This is a private endpoint, the provided API Key doesn't have the necessary rights. Have you tried authenticating your requests with your Private key?" unless has_private_access?
    end

    def needs_public_access!
      raise NotAuthorized, "This is a public endpoint, the provided API Key you use doesn't have the necessary rights. Have you tried authenticating your requests with your Public key?" unless has_public_access?
    end

    def current_application
      @current_application
    end

    def has_internal_access?
      @has_internal_access
    end

    def is_sandbox?
      @is_sandbox
    end
    alias_method :sandbox?, :is_sandbox?

    def has_public_access?
      @has_public_access
    end

    def has_private_access?
      @has_private_access
    end

    def helpers_initialize
      service = session['charon.passenger']

      @has_internal_access ||= service[:type] == :internal
      @is_sandbox ||= service[:in_sandbox]
      @has_public_access ||= service[:has_public_access]
      @has_private_access ||= service[:has_private_access]

      if service[:type] == :external
        @current_application ||= Application.find(service[:app_id])
      end

    end
  end
end