class RsvpsController < ApplicationController
  include Wicked::Wizard
  rescue_from ActiveRecord::RecordNotFound, with: :redirect_to_first_step

  def show
    @object = form_class.new(cookies: cookies)

    if @object.viewable?
      render_wizard
    else
      redirect_to(rsvp_path(previous_step))
    end
  end

  def update
    @object = form_class.new(cookies: cookies, params: whitelisted_params)
    set_cookies
    render_wizard @object
  end

  steps :enter_code, :attendance, :food, :confirmation

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
          people_attributes: [:attending_breakfast, :id]
        )
      }
    }
    h[:food] = {
      klass: RsvpFoodForm,
      params: -> (params) {
        params.require(:rsvp_food_form).permit(
          people_attributes: [
            :id,
            food_choices_attributes: [:food, :id],
          ]
        )
      }
    }
    h[:confirmation] = {
      klass: RsvpConfirmationForm,
      params: -> (_) { {} }
    }
  end

  def process_resource!(resource)
    if resource && resource.save
      if resource.finish_early?
        @skip_to ||= :confirmation
      else
        @skip_to ||= @next_step
      end
    else
      @skip_to = nil
    end
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
