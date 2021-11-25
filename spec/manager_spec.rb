# frozen_string_literal: true

require 'timeout'

RSpec.describe Manager, type: :model do
  before { Manager.instance_variable_set :@map, nil }

  context 'class methods' do
    context '.map' do
      it do
        map = Manager.send :map
        map1 = Manager.send :map
        expect(map).to be(map1)
      end
    end

    context '.get' do
      it 'must return id' do
        uuid = Manager.get :key
        expect(uuid).to be_a(String)
      end

      it 'must lock process' do
        Manager.get :key

        expect do
          Timeout.timeout(1) do
            Manager.get(:key)
          end
        end.to raise_error(Timeout::Error)
      end

      it 'don\'t must lock process with diff queue_name' do
        Manager.get :queue_name
        Manager.get :queue_name1
        Manager.get :queue_name2

        map = Manager.send :map
        expect(map.keys.count).to eq(3)
      end
    end

    context '.set .remove' do
      it do
        queue_name = %w[blue red green yellow].sample
        uuid = Manager.get queue_name
        map = Manager.send :map
        expect(map[queue_name].count).to eq(1)

        time = Manager.remove queue_name, uuid
        expect(map[queue_name].count).to eq(0)
        expect(time).to be_a(Float)
      end

      context '.remove_old_sticks' do
        it do
          queue_name = %w[blue red green yellow].sample
          Manager.get queue_name, 1
          map = Manager.send :map
          expect(map[queue_name].count).to eq(1)

          sleep 2
          Manager.send(:remove_old_sticks)
          expect(map[queue_name].count).to eq(0)
        end
      end
    end
  end
end
