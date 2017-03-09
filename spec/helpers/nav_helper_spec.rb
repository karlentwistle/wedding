require "rails_helper"

RSpec.describe FoodHelper, :type => :helper do
  describe 'nav_link' do
    context 'link_path doesnt match current_page' do
      it 'returns markup for nav-link' do
        expect(
          helper.nav_link('mha', '/foo')
        ).to eql(
          normal_nav_link('mha', '/foo')
        )
      end
    end

    context 'link_path matches current_page' do
      it 'returns markup for nav-link with nav-link--current' do
        allow(helper).to receive(:current_page?).with('/').and_return(true)

        expect(
          helper.nav_link('mha', '/')
        ).to eql(
          current_nav_link('mha', '/')
        )
      end
    end

    context 'override' do
      context 'current controller name equals override' do
        it 'returns markup for nav-link--current' do
          allow(helper).to receive(:controller).and_return(double(controller_name: 'rsvps'))

          expect(
            helper.nav_link('mha', '/rsvp/foo', 'rsvps')
          ).to eql(
            current_nav_link('mha', '/rsvp/foo')
          )
        end
      end

      context 'current controller name doesnt equal override' do
        it 'returns markup for nav-link' do
          expect(
            helper.nav_link('mha', '/foo', 'rsvps')
          ).to eql(
            normal_nav_link('mha', '/foo')
          )
        end
      end
    end
  end

  def normal_nav_link(link_text, link_path)
    "<li class=\"nav-link\"><a href=\"#{link_path}\">#{link_text}</a></li>"
  end

  def current_nav_link(link_text, link_path)
    "<li class=\"nav-link nav-link--current\"><a href=\"#{link_path}\">#{link_text}</a></li>"
  end
end
