require 'rails_helper'

RSpec.describe RsvpCode, type: :model do
  subject { build(:rsvp_code) }

  it 'has a valid factory' do
    expect(subject.valid?).to be true
  end

  describe 'validations' do
    it 'is invalid without a secret' do
      subject.secret = ''
      expect(subject.save).to be false
    end

    it 'is invalid is another rsvp code shares the same secret' do
      existing_rsvp_code = create(:rsvp_code)
      duplicate_rsvp_code = build(:rsvp_code, secret: existing_rsvp_code.secret)
      expect(duplicate_rsvp_code.save).to be false
    end
  end

  describe '#people' do
    context 'no people associated' do
      it 'is empty' do
        expect(subject.people).to be_empty
      end
    end

    context 'has people associated' do
      let(:associated_a) { create(:person) }
      let(:associated_b) { create(:person) }
      let(:not_associated) { create(:person) }

      before do
        subject.people << [associated_a, associated_b]
      end

      it 'returns associated people' do
        expect(subject.people).to match_array([associated_a, associated_b])
      end
    end
  end

  describe '#people_attending' do
    let(:people_attending) { [] }
    let(:people_not_attending) { [] }
    let(:people) { people_attending + people_not_attending }
    before do
      subject.save
      subject.people << people
    end

    context 'no people associated' do
      it 'is empty' do
        expect(subject.people_attending).to be_empty
      end
    end

    context 'no attending people' do
      let(:people_not_attending) do
        [
          create(:person, attending: false),
          create(:person, attending: false),
        ]
      end

      it 'is empty' do
        expect(subject.people_attending).to be_empty
      end
    end

    context 'some attending people some not' do
      let(:people_attending) do
        [
          create(:person, attending: true),
          create(:person, attending: true),
        ]
      end
      let(:people_not_attending) do
        [ create(:person, attending: false) ]
      end

      it 'returns only attending people' do
        expect(subject.people_attending).to match_array(people_attending)
      end
    end
  end
end
