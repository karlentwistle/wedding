require 'rails_helper'
require_relative '../../lib/fake_collection_proxy'

RSpec.describe FakeCollectionProxy do
  let(:collection) { (1..2).to_a }

  describe '#find' do
    context 'not found' do
      it 'raises ActiveRecord::RecordNotFound' do
        expect{
          described_class[*collection].find {|item| item == 0}
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'found' do
      it 'behaves like Array' do
        subject = described_class[*collection].find {|item| item == 1}
        expected = Array[*collection].find {|item| item == 1}

        expect(subject).to eql(expected)
      end
    end
  end
end
