# frozen_string_literal: true

class App
  class << self
    def root
      Dir.pwd
    end

    def logger
      @logger ||= build_logger
    end

    def env
      @env ||= ENV['APP_ENV'] || 'development'
    end

    def start_loop
      Thread.new do
        loop do
          sleep seconds_sleep
          logger.info Manager.report
          Manager.send(:remove_old_sticks)
        end
      end
    end

    private

    def build_logger
      @logger = Logger.new("#{root}/log/#{env}.log")
    end

    def seconds_sleep
      @seconds_sleep ||= ENV['SLEEP_BY_SECONDS'] || 1
    end
  end
end

App.start_loop if ENV['APP_START_LOOP'].to_i.positive?
