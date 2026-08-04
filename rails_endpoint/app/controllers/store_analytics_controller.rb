class StoreAnalyticsController < ApplicationController
  def show
    analytics = StoreAnalyticsService.new(store_analytics_params).call
    render json: analytics
  rescue ArgumentError => e
    render json: { error: e.message }, status: :unprocessable_entity
  rescue RuntimeError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  protected

  def store_analytics_params
    params.require(:store_id)
    params.require(:months)

    params.permit(:store_id, :months, :category_id, :channel)
  end
end
