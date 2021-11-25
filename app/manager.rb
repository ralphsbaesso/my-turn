# frozen_string_literal: true

class Manager
  private_class_method :new
  attr_reader :map

  class << self
    def get(queue_name, seconds = 120)
      queue = get_queue(queue_name)
      stick = Stick.new(seconds)
      queue << stick

      wait_your_turn(queue, stick.id)
      stick.id
    end

    def wait_your_turn(queue, stick_id)
      loop do
        break if queue.first&.id == stick_id

        sleep 1
      end
    end

    def remove(queue_name, uuid)
      queue = get_queue queue_name
      stick = queue.find { |stick| stick.id == uuid }
      return :not_found unless stick

      queue.delete_if { |stick| stick.id == uuid }
      Time.now - stick.created_at
    end

    def report
      return 'nothing' unless map.values.map(&:length).reduce(&:+)&.positive?

      report = []
      map.each do |key, queue|
        next if queue.size.zero?

        report << "queue_name => #{key}, size => #{queue.length}, next => #{queue.first&.id}"
      end
      report.join("\n")
    end

    private

    def get_queue(queue_name)
      queue_name = queue_name.to_s
      map[queue_name] = [] unless map[queue_name]
      map[queue_name]
    end

    def remove_old_sticks
      map.each_value do |queue|
        queue.delete_if { |stick| expired?(stick) }
      end
    end

    def expired?(stick)
      stick.expire_on < Time.now
    end

    def map
      @map ||= build_map
    end

    def build_map
      mutex.synchronize do
        @map ||= {}
      end

      @map
    end

    def mutex
      @instance_mutex ||= Mutex.new
    end
  end
end
