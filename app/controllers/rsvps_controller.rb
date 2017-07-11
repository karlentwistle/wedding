class RsvpsController < ApplicationController
  include Wicked::Wizard
  rescue_from Wicked::Wizard::InvalidStepError, with: :not_found

  prepend_before_action :set_steps

  def show
    @object = form_class.new(rsvp_code: rsvp_code)
    if @object.viewable?
      render_wizard
    elsif @object.skip_to_end?
      redirect_to(rsvp_path(:confirmation))
    else
      redirect_to(rsvp_path(previous_step))
    end
  end

  def update
    @object = form_class.new(
      rsvp_code: rsvp_code,
      params: whitelisted_params
    )
    set_cookies
    render_wizard @object
  end

  private

  helper_method :steps, :previous_step?

  def set_steps
    if rsvp_code.ceremony
      self.steps = [:enter_code, :attendance, :food, :confirmation]
    else
      self.steps = [:enter_code, :attendance, :confirmation]
    end
  end

  def rsvp_code
    @rsvp_code ||= RsvpCode.find_by(
      secret: cookies[:rsvp_code_secret]
    ) || RsvpCode.new
  end

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
          people_attributes: [
            :attending_reception,
            :attending_ceremony,
            :id,
          ]
        )
      }
    }
    h[:food] = {
      klass: RsvpFoodForm,
      params: -> (params) {
        params.require(:rsvp_food_form).permit(
          people_attributes: [
            :id,
            :dietary_requirements,
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
      if resource.skip_to_end?
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

  def redirect_to_finish_wizard(*args)
    flash[:success] = t('rsvp.flash.success')
    super
  end

end
