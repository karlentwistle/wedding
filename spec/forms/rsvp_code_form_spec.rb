require 'rails_helper'

RSpec.describe RsvpCodeForm do
  describe '#secret' do
    subject { RsvpCodeForm.new(params: {secret: secret}) }
    let(:secret) { build(:rsvp_code).secret }

    it 'is accessible' do
      expect(subject.secret).to eql(secret)
    end
  end

  describe '#save' do
    subject { RsvpCodeForm.new(params: params) }
    context 'valid params' do
      before { create(:rsvp_code, secret: '1234') }
      let(:params) { {secret: '1234'} }

      it 'returns true' do
        expect(subject.save).to be true
      end
    end

    context 'invalid params' do
      context 'invalid secret' do
        context 'not found in database' do
          let(:params) { {secret: 'not_found'} }

          it 'returns false' do
            expect(subject.save).to be false
          end

          it 'contains error' do
            subject.save
            expect(subject.errors[:secret]).to include(
              'unfortunately your code wasn\'t found'
            )
          end
        end

        context 'empty' do
          let(:params) { {secret: ''} }

          it 'returns false' do
            expect(subject.save).to be false
          end

          it 'contains error' do
            subject.save
            expect(subject.errors[:secret]).to include(
              I18n.t('errors.messages.blank')
            )
          end
        end
      end
    end
  end

  describe '#cookie_payload' do
    context 'params contains no secret' do
      it 'returns { rsvp_code_secret: nil }' do
        expect(subject.cookie_payload).to eql(
          { rsvp_code_secret: nil }
        )
      end
    end

    context 'params contains secret' do
      let(:params) { {secret: '1234'} }

      it 'returns { rsvp_code_secret: secret }' do
        expect(subject.cookie_payload).to eql(
          { rsvp_code_secret: nil }
        )
      end
    end
  end
end
