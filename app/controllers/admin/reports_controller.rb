# frozen_string_literal: true
module Admin
  class ReportsController < ApplicationController
    before_action :load_report, only: [:resolve]

    def index
      @reports = paginate Report.unresolved
    end

    def resolve
      @report.resolve by: current_user

      redirect_to admin_reports_path, notice: 'Report was successfully resolved.'
    end

    private

    def load_report
      @report = Report.find params[:id]
    end
  end
end
