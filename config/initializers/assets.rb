# frozen_string_literal: true

# Application assets are handled by Gulp.js. This file
# introduces a couple of helpers to integrate it into Rails.

class Assets
  def path(file)
    file = production_manifest[file] if Rails.env.production?

    "#{Settings[:asset_root]}/#{file}"
  end

  private

  def production_manifest
    @manifest ||= JSON.parse(
      File.read(Rails.root.join('public', 'assets', 'manifest.json')))
  end
end
