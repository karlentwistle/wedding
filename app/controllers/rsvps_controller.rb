class RsvpsController < ApplicationController
  include Wicked::Wizard
  rescue_from ActiveRecord::RecordNotFound, with: :redirect_to_first_step

  def show
    @object = form_class.new(cookies: cookies)
    render_wizard
  end

  def update
    @object = form_class.new(cookies: cookies, params: whitelisted_params)
    set_cookies
    render_wizard @object
  end

  steps :enter_code, :attendance, :confirmation

  private

  NULL_STEP = {
    klass: RsvpNullStepForm,
    params: -> (_) { {} }
  }

  STEP_MAP = Hash.new(NULL_STEP).tap do |h|
    h[:enter_code] = {
      klass: RsvpCodeForm,
      params: -> (params) {
        params.require(:rsvp_code_form).permit(:secret)
      }
    }
    h[:attendance] = {
      klass: RsvpAttendanceForm,
      params: -> (params) {
        params.require(:rsvp_attendance_form).permit(
          people_attributes: [:attending, :id]
        )
      }
    }
    h[:confirmation] = {
      klass: RsvpConfirmationForm,
      params: -> (_) { {} }
    }
  end

  def form_class
    STEP_MAP[step][:klass]
  end

  def whitelisted_params
    STEP_MAP[step][:params].call(params)
  end

  def set_cookies
    @object.cookie_payload.each do |key, value|
      cookies[key] = value
    end
  end

  def redirect_to_first_step
    redirect_to(rsvps_path)
  end
end
