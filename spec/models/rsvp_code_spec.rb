require 'rails_helper'

RSpec.describe RsvpCode, type: :model do
  subject { build(:rsvp_code) }

  it 'has a valid factory' do
    expect(subject.valid?).to be true
  end

  describe '.find_by' do
    context 'secret' do
      it 'finds secrets case insensitively' do
        create(:rsvp_code, secret: 'iLluMiNAti')
        expect(
          described_class.find_by(secret: 'illuminati')
        ).to be_present
      end
    end
  end

  describe '#close' do
    before { subject.save }

    it 'sets responded to true' do
      subject.close
      subject.reload
      expect(subject).to be_responded
    end
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

    it 'is invalid without a true of false value for breakfast' do
      subject.breakfast = ''
      expect(subject.save).to be false
    end

    it 'is invalid without a true of false value for reception' do
      subject.reception  = ''
      expect(subject.save).to be false
    end

    it 'is invalid if breakfast and reception are false' do
      subject.reception  = false
      subject.breakfast  = false
      expect(subject.save).to be false
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

  describe 'confirmable?' do
    context 'no people associated' do
      it { expect(subject.responded?).to be false }
    end

    context 'people associated' do
      context 'breakfast' do
        subject { create(:rsvp_code, breakfast: true, reception: true) }
        let(:people) { [create(:person), create(:person)] }
        before { subject.people << people }

        context 'no people responded' do
          it { expect(subject).not_to be_confirmable }
        end

        context 'some people responded' do
          before do
            people.first.update_attributes(
              attending_breakfast: true,
              attending_reception: false
            )
          end

          it { expect(subject).not_to be_confirmable }
        end

        context 'all people responded' do
          before do
            people.each do |person|
              person.update_attributes(
                attending_breakfast: true,
                attending_reception: false
              )
            end
          end

          it { expect(subject).to be_confirmable }
        end
      end

      context 'reception' do
        subject { create(:rsvp_code, breakfast: false, reception: true) }
        let(:people) { [create(:person), create(:person)] }
        before { subject.people << people }

        context 'no people responded' do
          it { expect(subject).not_to be_confirmable }
        end

        context 'some people responded' do
          before do
            people.first.update_attributes(
              attending_reception: false
            )
          end

          it { expect(subject).not_to be_confirmable }
        end

        context 'all people responded' do
          before do
            people.each do |person|
              person.update_attributes(
                attending_reception: false
              )
            end
          end

          it { expect(subject).to be_confirmable }
        end
      end

    end
  end

  describe '#people_attending_breakfast' do
    let(:people_attending_breakfast) { [] }
    let(:people_not_attending_breakfast) { [] }
    let(:people) { people_attending_breakfast + people_not_attending_breakfast }
    before do
      subject.save
      subject.people << people
    end

    context 'no people associated' do
      it 'is empty' do
        expect(subject.people_attending_breakfast).to be_empty
      end
    end

    context 'no attending_breakfast people' do
      let(:people_not_attending_breakfast) do
        [
          create(:person, attending_breakfast: false),
          create(:person, attending_breakfast: false),
        ]
      end

      it 'is empty' do
        expect(subject.people_attending_breakfast).to be_empty
      end
    end

    context 'some attending_breakfast people some not' do
      let(:people_attending_breakfast) do
        [
          create(:person, attending_breakfast: true),
          create(:person, attending_breakfast: true),
        ]
      end
      let(:people_not_attending_breakfast) do
        [ create(:person, attending_breakfast: false) ]
      end

      it 'returns only attending_breakfast people' do
        expect(subject.people_attending_breakfast).to match_array(people_attending_breakfast)
      end
    end
  end
end
