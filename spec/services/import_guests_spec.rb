require 'rails_helper'

RSpec.describe GuestImporter, type: :model do
  let(:guest_list_path) do
    File.expand_path("../../support/fixtures/guest_list.csv", __FILE__)
  end

  describe '#perform' do
    context 'Ceremony and Reception guests' do
      it 'creates guests with rsvp' do
        described_class.new(guest_list_path).perform

        rsvp = RsvpCode.find_by(
          secret: 'HKE2',
          breakfast: true,
          reception: true
        )

        expect(rsvp).to be_present
        expect(rsvp.people).to match [
          an_object_having_attributes(full_name: 'Hannah Sergeant'),
          an_object_having_attributes(full_name: 'Karl Entwistle')
        ]
      end
    end

    context 'Reception only guests' do
      it 'creates guests with rsvp' do
        described_class.new(guest_list_path).perform

        rsvp = RsvpCode.find_by(
          secret: 'RT62',
          breakfast: false,
          reception: true
        )

        expect(rsvp).to be_present
        expect(rsvp.people).to match [
          an_object_having_attributes(full_name: 'Abigail Anderson'),
        ]
      end
    end

    context 'Ceremony only guests' do
      it 'creates guests with rsvp' do
        described_class.new(guest_list_path).perform

        rsvp = RsvpCode.find_by(
          secret: 'MCRR',
          breakfast: true,
          reception: false
        )

        expect(rsvp).to be_present
        expect(rsvp.people).to match [
          an_object_having_attributes(full_name: 'Miss Cassidy Roberts'),
          an_object_having_attributes(full_name: 'Miss Willie Von'),
          an_object_having_attributes(full_name: 'Eulalia Nader'),
          an_object_having_attributes(full_name: 'Dr. Krista Bartoletti'),
          an_object_having_attributes(full_name: 'Mathew Goodwin'),
          an_object_having_attributes(full_name: 'Jessyca Kub'),
          an_object_having_attributes(full_name: 'Mattie Weissnat'),
          an_object_having_attributes(full_name: 'Jevon Gaylord'),
        ]
      end
    end
  end
end

