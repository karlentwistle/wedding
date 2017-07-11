require 'rails_helper'

RSpec.describe RsvpFoodForm do
  let(:people_attributes) { {} }
  let(:rsvp_code) { RsvpCode.new }
  let(:params) { { people_attributes: people_attributes } }
  let(:subject) { described_class.new(rsvp_code: rsvp_code, params: params) }

  describe '#viewable?' do
    context 'no persisted rsvp_code' do
      it 'returns false' do
        expect(subject.viewable?).to be false
      end
    end

    context 'valid rsvp_code' do
      let(:rsvp_code) { create(:rsvp_code) }
      before { rsvp_code.people << people }

      context 'and people attending_ceremony' do
        let(:people) do
          [
            create(:person, attending_ceremony: true),
            create(:person, attending_ceremony: false)
          ]
        end

        it 'returns true' do
          expect(subject.viewable?).to be true
        end
      end

      context 'no people attending_ceremony' do
        let(:people) do
          [
            create(:person),
            create(:person, attending_ceremony: false)
          ]
        end

        it 'returns true' do
          expect(subject.viewable?).to be false
        end
      end
    end
  end

  describe '#people' do
    it 'returns people wrapped in person form objects' do
      person_a = Person.new
      person_b = Person.new
      people = [person_a, person_b]
      allow(rsvp_code).to receive(:people_attending_ceremony).and_return(people)

      expect(subject.people).to match_array([
        PersonFoodForm.new(person_a),
        PersonFoodForm.new(person_b),
      ])
    end
  end

  describe '#save' do
    context 'valid params' do
      let(:starter_a) { create(:food, sitting: 0) }
      let(:main_a) { create(:food, sitting: 1) }
      let(:dessert_a) { create(:food, sitting: 2) }
      let(:starter_b) { create(:food, sitting: 0) }
      let(:main_b) { create(:food, sitting: 1) }
      let(:dessert_b) { create(:food, sitting: 2) }
      let(:people) {
        [
          create(:person, attending_ceremony: true),
          create(:person, attending_ceremony: true)
        ]
      }
      let(:rsvp_code) { create(:rsvp_code) }
      let(:people_attributes) do
        {
          "0": {
            food_choices_attributes: {
              "0": {food: starter_a.id},
              "1": {food: main_a.id},
              "2": {food: dessert_a.id},
            },
            id: people[0].id,
            dietary_requirements: 'Low Cholesterol / Low Fat Meal',
          },
          "1": {
            food_choices_attributes: {
              "0": {food: starter_b.id},
              "1": {food: main_b.id},
              "2": {food: dessert_b.id},
            },
            id: people[1].id,
            dietary_requirements: '',
          },
        }
      end
      before { rsvp_code.people << people }

      it 'returns true' do
        expect(subject.save).to be true
      end

      it 'updates peoples food choices based on params' do
        subject.save
        people.each(&:reload)

        expect(people[0].starter_choice).to eql(starter_a)
        expect(people[0].main_choice).to eql(main_a)
        expect(people[0].dessert_choice).to eql(dessert_a)
        expect(people[0].dietary_requirements).to eql('Low Cholesterol / Low Fat Meal')

        expect(people[1].starter_choice).to eql(starter_b)
        expect(people[1].main_choice).to eql(main_b)
        expect(people[1].dessert_choice).to eql(dessert_b)
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

        context 'extra person' do
          let(:people) {
            [
              create(:person, attending_ceremony: true),
              create(:person, attending_ceremony: true)
            ]
          }
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

      context 'invalid food choices' do
        context 'choices left blank' do
          let(:starter) { create(:food, sitting: 0) }
          let(:people) { [ create(:person, attending_ceremony: true) ] }
          let(:rsvp_code) { create(:rsvp_code) }
          let(:people_attributes) do
            {
              "0": {
                food_choices_attributes: {
                  "0": {food: starter.id},
                  "1": {food: ''},
                },
                id: people[0].id
              }
            }
          end
          before { rsvp_code.people << people }

          it 'returns false' do
            expect(subject.save).to be false
          end

          it 'appends error to empty choice' do
            subject.save

            expect(subject.people[0].food_choices[0].errors).to be_empty
            expect(subject.people[0].food_choices[1].errors).to include(:food)
            expect(subject.people[0].food_choices[2].errors).to include(:food)
          end
        end
      end
    end
  end
end
