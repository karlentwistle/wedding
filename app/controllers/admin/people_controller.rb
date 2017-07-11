module Admin
  class PeopleController < Admin::ApplicationController

    def index
      @statistics = PersonStatistics.new
      super
    end

    def export
      send_data CeremonyExport.new.perform, filename: "people-#{Date.today}.csv"
    end

    private

    def scoped_resource
      resource_class.eager_load(:rsvp_code)
    end

    class Order < Administrate::Order
      def apply(relation)
        if attribute == 'responded?'
          relation.merge(RsvpCode.order(responded: direction))
        else
          super
        end
      end
    end

    def order
      if params[:order] && params[:direction]
        @_order ||= Administrate::Order.new(params[:order], params[:direction])
      else
        @_order ||= Administrate::Order.new(:full_name, :asc)
      end
    end
  end
end
