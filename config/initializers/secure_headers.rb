SecureHeaders::Configuration.default do |config|
  CSP = {
    default_src: %w('self'),

    img_src: %w('self' https://fanuniversecontent.net https://camo.fanuniversecontent.net),
    font_src: %w('self' https://fanuniversecontent.net https://fonts.gstatic.com),
    style_src: %w('self' https://fanuniversecontent.net https://fonts.googleapis.com),
    script_src: %w('self' https://fanuniversecontent.net),

    frame_ancestors: %w('none'),

    preserve_schemes: true,
    block_all_mixed_content: true
  }

  config.cookies = { secure: true,
                     httponly: true,
                     samesite: { lax: true } }

  if Rails.env.production?
    config.csp = CSP
  else
    config.csp = SecureHeaders::OPT_OUT
    config.csp_report_only = CSP
  end

  config.x_frame_options        = 'DENY'
  config.x_content_type_options = 'nosniff'
  config.x_xss_protection       = '1; mode=block'

  config.hsts                              = SecureHeaders::OPT_OUT
  config.x_download_options                = SecureHeaders::OPT_OUT
  config.referrer_policy                   = SecureHeaders::OPT_OUT
  config.x_permitted_cross_domain_policies = SecureHeaders::OPT_OUT
end
