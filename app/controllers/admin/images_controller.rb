# frozen_string_literal: true
module Admin
  class ImagesController < ApplicationController
    before_action :load_source_and_target, only: [:merge, :commit_merge]

    def merge
    end

    def commit_merge
      ImageMergingJob.perform_later @source.id, @target.id
      redirect_to admin_dashboard_path, notice:
        "##{@source.id} will be merged into ##{@target.id} shortly."
    end

    private

    def load_source_and_target
      @source = Image.find(params[:source])
      @target = Image.find(params[:target])
    end
  end
end
