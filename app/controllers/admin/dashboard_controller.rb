# frozen_string_literal: true
module Admin
  class DashboardController < ApplicationController
    def show
      @unresolved_reports = Report.unresolved.count
    end
  end
end
