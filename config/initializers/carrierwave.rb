# frozen_string_literal: true
CarrierWave.configure do |c|
  c.root = Rails.root.join Settings[:carrierwave_root_path]
  c.permissions = 0o644
end
