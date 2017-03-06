require 'rails_helper'

RSpec.describe RsvpConfirmationForm do
  let(:rsvp_code) { create(:rsvp_code) }
  let(:params) { { } }
  let(:subject) { described_class.new(rsvp_code: rsvp_code, params: params) }

  describe '#people' do
    let(:people) { [create(:person), create(:person)] }
    before { rsvp_code.people << people }

    it 'delegates to rsvp_code' do
      expect(subject.people).to match_array(people)
    end
  end

  describe '#breakfast' do
    it 'delegates to rsvp_code' do
      expect(subject.breakfast).to eql(rsvp_code.breakfast)
    end
  end

  describe '#respondable?' do
    it 'delegates to rsvp_code' do
      expect(subject.respondable?).to eql(rsvp_code.respondable?)
    end
  end

  describe '#viewable?' do
    context 'rsvp_code: persisted?: true, confirmable?: true' do
      let(:rsvp_code) { double(persisted?: true, confirmable?: true) }
      it { expect(subject.viewable?).to be true }
    end

    context 'rsvp_code: persisted?: true, confirmable?: false' do
      let(:rsvp_code) { double(persisted?: true, confirmable?: false) }
      it { expect(subject.viewable?).to be false }
    end

    context 'rsvp_code: persisted?: false, confirmable?: true' do
      let(:rsvp_code) { double(persisted?: false, confirmable?: true) }
      it { expect(subject.viewable?).to be false }
    end

    context 'rsvp_code: persisted?: false, confirmable?: false' do
      let(:rsvp_code) { double(persisted?: false, confirmable?: false) }
      it { expect(subject.viewable?).to be false }
    end
  end

  describe '#save' do
    let(:rsvp_code) { spy('rsvp_code') }

    it 'closes rsvp' do
      subject.save
      expect(rsvp_code).to have_received(:close).once
    end
  end
end
