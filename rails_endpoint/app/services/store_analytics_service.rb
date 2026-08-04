class StoreAnalyticsService
  ALLOWED_MONTHS = [12, 24, 36].freeze

  def initialize(args)
    @store_id     = args[:store_id]
    @months       = args[:months].to_i
    @category_id  = args[:category_id]
    @channel      = args[:channel]
  end

  def call
    validate!

    monthly_data  = client.monthly_comparison
    segments      = client.segments

    {
      contract:         monthly_data["contract"],
      store_id:         monthly_data["store_id"],
      store_name:       monthly_data["store_name"],
      filters_applied:  monthly_data["filters_applied"],
      summary:          monthly_data["summary"],
      months:           format_months(monthly_data["months"]),
      segments:         format_segments(segments)
    }
  end

  private

  attr_reader :store_id, :months, :category_id, :channel

  def client
    @client ||= ChallengeApiClient.new(
      store_id:     store_id,
      months:       months,
      category_id:  category_id,
      channel:      channel
    )
  end

  def validate!
    raise ArgumentError, "store_id is required" if store_id.blank?
    raise ArgumentError, "invalid months" unless ALLOWED_MONTHS.include?(months)
  end

  def format_months(months)
    months.map do |month|
      {
        month:                  month["month"],
        sales:                  month["current_year_sales_ex_tax"],
        gross_profit:           month["current_year_gross_profit_ex_tax"],
        sales_delta_pct:        month["delta_sales_pct"],
        gross_profit_delta_pct: month["delta_gross_profit_pct"],
        orders:                 month["orders"],
        returns:                month["returns"]
      }
    end
  end

  def format_segments(data)
    data["segments"].map do |segment|
      {
        id:                         segment["segment_id"],
        label:                      segment["label"],
        current_year_sales:         segment["current_year_sales_ex_tax"],
        current_year_gross_profit:  segment["current_year_gross_profit_ex_tax"],
        sales_delta_pct:            segment["delta_sales_pct"],
        gross_profit_delta_pct:     segment["delta_gross_profit_pct"],
        orders:                     segment["orders"],
        returns:                    segment["returns"]
      }
    end
  end
end
