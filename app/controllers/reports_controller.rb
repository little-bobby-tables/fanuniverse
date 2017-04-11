class ReportsController < ApplicationController
  before_action :load_reportable, only: [:new, :create]

  def index
    authorize! :manage, Report

    @reports = paginate Report.where(resolved: false)
  end

  def new
    authorize! :report, @reportable

    @report = Report.new
  end

  def create
    authorize! :report, @reportable

    @report = Report.new(new_report_params)

    if @report.save
      redirect_to root_path, notice: 'Report was successfully created.'
    else
      render :new
    end
  end

  private

  def load_reportable
    type = Report::REPORTABLE.detect { |type| params[:reportable_type] == type }
    render_40x and return unless type

    @reportable = type.constantize.find(params[:reportable_id])
  end

  def new_report_params
    params.require(:report).permit(:body).merge(
      reportable_type: @reportable.model_name.name,
      reportable_id: @reportable.id,
      reported_by: current_user
    )
  end
end
