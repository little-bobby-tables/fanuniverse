class Api::ImageScrapingController < ApplicationController
  def scrape
    return unless user_signed_in? && params[:url].present?

    scraped = ImageMetadataScraper.scrape params[:url]
    render json: scraped || {}
  end
end
