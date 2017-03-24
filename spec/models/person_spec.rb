require 'rails_helper'

RSpec.describe Person, type: :model do
  subject { build(:person) }

  it 'has a valid factory' do
    expect(subject.valid?).to be true
  end

  describe 'invited_to_ceremony' do
    context 'no rsvp' do
      it 'returns false' do
        subject.rsvp_code = nil
        expect(subject).not_to be_invited_to_ceremony
      end
    end

    context 'rsvp' do
      context 'includes ceremony' do
        it 'returns true' do
          subject.rsvp_code = build(:rsvp_code)
          subject.rsvp_code.ceremony = true
          expect(subject).to be_invited_to_ceremony
        end
      end

      context 'no ceremony' do
        it 'returns false' do
          subject.rsvp_code = build(:rsvp_code)
          subject.rsvp_code.ceremony = false
          expect(subject).not_to be_invited_to_ceremony
        end
      end
    end
  end

  describe 'validations' do
    it 'is invalid without a full_name' do
      subject.full_name = ''
      expect(subject.save).to be false
    end
  end

  describe 'attending_ceremony=' do
    context 'person has associated food choices' do
      context 'attending_ceremony set to false' do
        it 'destroy associated food choices' do
          create(:food_choice, person: subject)

          subject.attending_ceremony = false
          subject.save
          subject.reload

          expect(subject.food_choices).to be_empty
        end
      end
    end
  end

  Food.sittings.each do |sitting, index|
    describe "##{sitting}_choice" do
      context "has picked a #{sitting}" do
        it "returns their #{sitting}" do
          subject.save
          food = create(:food, sitting: index)
          create(:food_choice, food: food, person: subject)
          expect(subject.send("#{sitting}_choice")).to eql(food)
        end
      end

      context "hasnt picked a #{sitting}" do
        it "returns nil" do
          expect(subject.send("#{sitting}_choice")).to be nil
        end
      end
    end
  end

  describe 'food_choices_attributes=' do
    it 'responds to food_choices_attributes=
      (required by rsvp food form helper)' do
      expect(subject).to respond_to(:food_choices_attributes=)
    end
  end
end
