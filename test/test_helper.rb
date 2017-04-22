# frozen_string_literal: true
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require 'sidekiq/testing'

Minitest.after_run do
  Sidekiq::Queues.clear_all
  FileUtils.rm_r Rails.root.join('public', 'test') rescue nil
end

class ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods
end

class ActionController::TestCase
  include Devise::Test::ControllerHelpers

  def json_response
    ActiveSupport::JSON.decode @response.body
  end
end

def prepare
  indexed_models = Rails.root.join('app', 'indexes')
                        .entries.reject(&:directory?)
                        .map { |e| e.basename('.rb').to_s.split('_').first.capitalize.constantize }

  indexed_models.each do |m|
    m.index_name "test_#{m.model_name.plural}"
    m.__elasticsearch__.create_index! force: true
  end
end

def refresh_index(model)
  model.__elasticsearch__.refresh_index!
end

prepare

module ActiveJob::TestHelper
  def perform_enqueued_jobs!
    jobs = enqueued_jobs
    self.enqueued_jobs = []

    jobs.map(&method(:instantiate_job)).each(&:perform_now)

    perform_enqueued_jobs! if enqueued_jobs.any?
  end
end
