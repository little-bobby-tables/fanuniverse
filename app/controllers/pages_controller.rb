class PagesController < ApplicationController
  PAGES = %w(intro)

  def show
    @page = params[:page]
    if @page.in? PAGES
      render @page
    else
      render_40x
    end
  end
end