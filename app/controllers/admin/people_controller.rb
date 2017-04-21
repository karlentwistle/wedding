module Admin
  class PeopleController < Admin::ApplicationController
    class Order < Administrate::Order
      def apply(relation)
        if attribute == 'responded?'
          relation.merge(RsvpCode.order(responded: direction))
        else
          super
        end
      end
    end

    class ResourceResolver < Administrate::ResourceResolver
      def resource_class
        Person.eager_load(:rsvp_code)
      end
    end

    private

    def resource_resolver
      @_resource_resolver ||= ResourceResolver.new(controller_path)
    end

    def order
      @_order ||= Order.new(params[:order], params[:direction])
    end
  end
end
