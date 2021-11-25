# frozen_string_literal: true

RSpec.describe Stick, type: :model do
  context 'instance methods' do
    context '#expire_on' do
      let(:tolerance) { 1 }

      it 'with nil params expire on 60 seconds' do
        stick = Stick.new(nil)
        expected = Time.now + 60
        expect(stick.expire_on.to_i).to be_within(tolerance).of(expected.to_i)
      end

      it 'with negative value' do
        stick = Stick.new(-23)
        expected = Time.now + 60
        expect(stick.expire_on.to_i).to be_within(tolerance).of(expected.to_i)
      end

      it 'with zero value' do
        stick = Stick.new(0)
        expected = Time.now + 60
        expect(stick.expire_on.to_i).to be_within(tolerance).of(expected.to_i)
      end

      it 'with string value' do
        seconds = rand(1..119)
        stick = Stick.new(seconds.to_s)
        expected = Time.now + seconds
        expect(stick.expire_on.to_i).to be_within(tolerance).of(expected.to_i)
      end

      it 'with a value greater than 120 seconds' do
        stick = Stick.new(121)
        expected = Time.now + 60
        expect(stick.expire_on.to_i).to be_within(tolerance).of(expected.to_i)
      end

      context 'with value between 1 and 120' do
        [1, 120, rand(2..119)].each do |second|
          it "second = #{second}" do
            stick = Stick.new(second)
            expected = Time.now + second
            expect(stick.expire_on.to_i).to be_within(tolerance).of(expected.to_i)
          end
        end
      end
    end
  end
end
