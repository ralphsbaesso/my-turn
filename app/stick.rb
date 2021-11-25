# frozen_string_literal: true

require 'securerandom'

class Stick
  attr_reader :id, :expire_on, :created_at

  def initialize(seconds)
    @expire_on = build_expire_on(seconds)
    @id = SecureRandom.uuid
    @created_at = Time.now
  end

  private

  def build_expire_on(seconds)
    seconds = seconds.to_i
    plus = seconds.between?(1, 120) ? seconds : 60
    Time.now + plus
  end
end
