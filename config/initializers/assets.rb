# frozen_string_literal: true

# Application assets are handled by Gulp.js. This file
# introduces a couple of helpers to integrate it into Rails.

class Assets
  def path(name)
    if Rails.env.development? || Rails.env.test?
      "/assets/#{name}"
    else
      "#{Settings[:asset_root]}/assets/#{manifest[name]}"
    end
  end

  private

  def manifest
    @manifest ||= JSON.parse(manifest_file)
  end

  def manifest_file
    File.read(Rails.root.join('public', 'assets', 'manifest.json'))
  end
end
