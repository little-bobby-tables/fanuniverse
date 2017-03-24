# frozen_string_literal: true

# Applies custom CSP directives to public error pages (50x).
module ActionDispatch
  class PublicExceptions
    def call(env)
      request      = ActionDispatch::Request.new(env)
      status       = request.path_info[1..-1].to_i
      content_type = request.formats.first
      body         = { status: status,
                       error: Rack::Utils::HTTP_STATUS_CODES.fetch(status, Rack::Utils::HTTP_STATUS_CODES[500]) }

      SecureHeaders.use_content_security_policy_named_append(request, :error_page)
      render(status, content_type, body)
    end
  end
end
