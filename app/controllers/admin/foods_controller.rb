module Admin
  class FoodsController < Admin::ApplicationController
    private

    def order
      if params[:order] && params[:direction]
        super
      else
        @_order ||= Administrate::Order.new(:sitting, :asc)
      end
    end
  end
end
