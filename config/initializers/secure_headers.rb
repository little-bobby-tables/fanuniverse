SecureHeaders::Configuration.default do |config|
  config.cookies = {
    secure: true,
    httponly: true,
    samesite: { lax: true }
  }

  config.csp = {
    default_src: %w('self'),

    img_src: %w('self' https://fanuniversecontent.net https://camo.fanuniversecontent.net),
    font_src: %w('self' https://fanuniversecontent.net https://fonts.gstatic.com),
    style_src: %w('self' https://fanuniversecontent.net https://fonts.googleapis.com),
    script_src: %w('self' https://fanuniversecontent.net),

    frame_ancestors: %w('none'),

    preserve_schemes: true,
    block_all_mixed_content: true
  }

  config.x_frame_options        = 'DENY'
  config.x_content_type_options = 'nosniff'
  config.x_xss_protection       = '1; mode=block'

  config.hsts                              = SecureHeaders::OPT_OUT
  config.x_download_options                = SecureHeaders::OPT_OUT
  config.referrer_policy                   = SecureHeaders::OPT_OUT
  config.x_permitted_cross_domain_policies = SecureHeaders::OPT_OUT
end

SecureHeaders::Configuration.named_append :error_page do
  { style_src:  %w('unsafe-inline') }
end
