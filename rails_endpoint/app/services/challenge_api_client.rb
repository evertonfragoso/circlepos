require "net/http"
require "json"

class ChallengeApiClient
  BASE_URL = "https://challenge.circlepos.com"
  BASE_PATH = "/api/challenge"

  def initialize(store_id:, months:, category_id: nil, channel: nil)
    @store_id     = store_id
    @months       = months.to_i
    @category_id  = category_id
    @channel      = channel
  end

  def monthly_comparison
    get "/monthly-comparison", {
      store_id:     store_id,
      months:       months,
      category_id:  category_id,
      channel:      channel
    }
  end

  def segments
    get "/segments", {
      store_id:     store_id,
      months:       months,
      category_id:  category_id,
      channel:      channel,
      group_by:     "channel"
    }
  end

  private

  attr_reader :store_id, :months, :category_id, :channel

  def get(endpoint, params)
    uri = URI("#{BASE_URL}#{BASE_PATH}#{endpoint}")
    uri.query = URI.encode_www_form params

    response = Net::HTTP.get_response uri

    raise "Challenge API failure" unless response.is_a? Net::HTTPSuccess

    JSON.parse response.body
  end
end
