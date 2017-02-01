require 'rails_helper'

RSpec.describe RsvpConfirmationForm do
  let(:rsvp_code) { NullRsvpCode.new }
  let(:params) { { } }
  let(:subject) { described_class.new(rsvp_code: rsvp_code, params: params) }

  describe '#people' do
    let(:people) { [create(:person), create(:person)] }
    let(:rsvp_code) { create(:rsvp_code) }
    before { rsvp_code.people << people }

    it 'delegates to rsvp_code assosicated people' do
      expect(subject.people).to match_array(people)
    end
  end

  describe '#breakfast' do
    let(:rsvp_code) { create(:rsvp_code) }

    it 'delegates to rsvp_code assosicated people' do
      expect(subject.breakfast).to eql(rsvp_code.breakfast)
    end
  end

  describe '#viewable?' do
    context 'rsvp_code: persisted?: true, responded?: true' do
      let(:rsvp_code) { double(persisted?: true, responded?: true) }
      it { expect(subject.viewable?).to be true }
    end

    context 'rsvp_code: persisted?: true, responded?: false' do
      let(:rsvp_code) { double(persisted?: true, responded?: false) }
      it { expect(subject.viewable?).to be false }
    end

    context 'rsvp_code: persisted?: false, responded?: true' do
      let(:rsvp_code) { double(persisted?: false, responded?: true) }
      it { expect(subject.viewable?).to be false }
    end

    context 'rsvp_code: persisted?: false, responded?: false' do
      let(:rsvp_code) { double(persisted?: false, responded?: false) }
      it { expect(subject.viewable?).to be false }
    end
  end
end
