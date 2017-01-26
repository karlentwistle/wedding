class RsvpsController < ApplicationController
  include Wicked::Wizard

  def show
    @object = RsvpCodeForm.new

    render_wizard
  end

  def update
    @object = RsvpCodeForm.new(rsvp_code_params)

    render_wizard @object
  end

  steps :enter_code, :attending

  private

  def rsvp_code_params
    params.require(:rsvp_code_form).permit(:secret)
  end
end
