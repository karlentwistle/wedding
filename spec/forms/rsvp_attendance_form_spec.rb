require 'rails_helper'

RSpec.describe RsvpAttendanceForm do
  let(:people_attributes) { {} }
  let(:rsvp_code) { NullRsvpCode.new }
  let(:params) { { people_attributes: people_attributes } }
  let(:subject) { described_class.new(rsvp_code: rsvp_code, params: params) }

  context 'no persisted rsvp_code' do
    it 'returns false' do
      expect(subject.viewable?).to be false
    end
  end

  describe '#ceremony' do
    let(:rsvp_code) { create(:rsvp_code) }

    it 'delegates to rsvp_code assosicated people' do
      expect(subject.ceremony).to eql(rsvp_code.ceremony)
    end
  end

  describe '#reception' do
    let(:rsvp_code) { create(:rsvp_code) }

    it 'delegates to rsvp_code assosicated people' do
      expect(subject.reception).to eql(rsvp_code.reception)
    end
  end

  describe '#people' do
    let(:people) { [create(:person), create(:person)] }
    let(:rsvp_code) { create(:rsvp_code) }
    before { rsvp_code.people << people }

    it 'delegates to rsvp_code assosicated people' do
      expect(subject.people).to match_array(people)
    end
  end

  describe '#save' do
    context 'valid params' do
      let(:people) { [create(:person), create(:person)] }
      let(:rsvp_code) { create(:rsvp_code) }
      let(:people_attributes) do
        {
          "0": { attending_ceremony: "0", attending_reception: "1", id: people[0].id },
          "1": { attending_ceremony: "1", attending_reception: "0", id: people[1].id },
        }
      end
      before { rsvp_code.people << people }

      it 'returns true' do
        expect(subject.save).to be true
      end

      it 'updates peoples attending_ceremony based on params' do
        subject.save
        people.each(&:reload)

        expect(people[0].attending_ceremony).to be false
        expect(people[1].attending_ceremony).to be true
      end

      it 'updates peoples attending_reception based on params' do
        subject.save
        people.each(&:reload)

        expect(people[0].attending_reception).to be true
        expect(people[1].attending_reception).to be false
      end
    end

    context 'invalid params' do
      context 'invalid people_attributes' do
        context 'not found in database' do
          let(:people_attributes) do
            { "0": { id: 666 } }
          end

          it 'raises ActiveRecord::RecordNotFound' do
            expect {
              subject.save
            }.to raise_error(ActiveRecord::RecordNotFound)
          end
        end

        context 'person missing' do
          let(:people) { [create(:person), create(:person)] }
          let(:rsvp_code) { create(:rsvp_code) }
          before { rsvp_code.people << people.sample }

          it 'returns false' do
            expect(subject.save).to be false
          end

          it 'appends error to base' do
            subject.save
            expect(subject.errors[:base]).to include('a person is missing')
          end
        end

        context 'extra person' do
          let(:people) { [create(:person), create(:person)] }
          let(:rsvp_code) { create(:rsvp_code) }
          let(:people_attributes) do
            {
              "0": { id: people[0].id },
              "1": { id: people[1].id },
            }
          end
          before { rsvp_code.people << people.sample }

          it 'raises ActiveRecord::RecordNotFound' do
            expect {
              subject.save
            }.to raise_error(ActiveRecord::RecordNotFound)
          end
        end
      end
    end
  end
end
