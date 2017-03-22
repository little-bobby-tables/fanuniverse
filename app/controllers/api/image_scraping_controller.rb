# frozen_string_literal: true
module Api
  class ImageScrapingController < ApplicationController
    def scrape
      return unless user_signed_in? && params[:url].present?

      scraped = ImageMetadataScraper.scrape params[:url]

      if scraped && scraped[:thumbnail_url].present?
        scraped[:thumbnail_url] = camo scraped[:thumbnail_url]

        render json: scraped
      else
        render json: {}
      end
    end
  end
end
