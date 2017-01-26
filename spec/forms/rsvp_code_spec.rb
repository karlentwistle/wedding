require 'rails_helper'

RSpec.describe RsvpCodeForm do
  describe '#save' do
    subject { RsvpCodeForm.new(params) }
    context 'valid params' do
      before { create(:rsvp_code, secret: '1234') }
      let(:params) { {secret: '1234'} }

      it 'returns true' do
        expect(subject.save).to be true
      end
    end

    context 'invalid params' do
      let(:params) { {secret: 'not_found'} }

      it 'returns false' do
        expect(subject.save).to be false
      end
    end
  end
end
