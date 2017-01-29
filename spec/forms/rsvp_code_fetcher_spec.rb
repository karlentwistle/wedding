require 'rails_helper'

RSpec.describe RsvpCodeFetcher do
  let(:klass) do
    Class.new(Struct.new(:cookies)) do
      include RsvpCodeFetcher
      public :rsvp_code
    end
  end

  context 'rsvp code found corresponding to cookies rsvp_code_secret' do
    let(:rsvp_code) { create(:rsvp_code) }
    let(:cookies) { { rsvp_code_secret: rsvp_code.secret } }

    it 'returns rsvp code' do
      expect(klass.new(cookies).rsvp_code).to eql(rsvp_code)
    end

    it 'memoizes rsvp_code' do
      expect(RsvpCode).to receive(:find_by!)
        .with(secret: rsvp_code.secret)
        .once
        .and_return('foo')

      subject = klass.new(cookies)

      2.times { subject.rsvp_code }
    end
  end

  context 'rsvp code not found' do
    let(:cookies) { { rsvp_code_secret: '1234' } }

    it 'raises ActiveRecord::RecordNotFound' do
      expect {
        klass.new(cookies).rsvp_code
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
