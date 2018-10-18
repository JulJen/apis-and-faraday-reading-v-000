class SearchesController < ApplicationController
  @@client_id = 'Y2ZOIHZUWLKQX33KB1KELMOT2HJFL4TCCT1GANUO5MVPOXYR'
  @@client_secret = 'XLZH5EDNHDXQBOYWRIIQ5SOEQ5W5VV2XYWX2YVUSG4AQB1FK'

  def search
  end

  def foursquare
    begin
      # Faraday.get(url) to make a request to the API endpoint
      @resp = Faraday.get 'https://api.foursquare.com/v2/venues/search' do |req|
        req.params['client_id'] = @@client_id
        req.params['client_secret'] = @@client_secret
        req.params['v'] = '20160201'
        req.params['near'] = params[:zipcode]
        req.params['query'] = 'coffee shop'
        req.options.timeout = 5   # 0 seconds to force timeout error for testing
      end
      body_hash = JSON.parse(@resp.body)
      if @resp.success?
        @venues = body_hash["response"]["venues"]
      else
        @error = body_hash["meta"]["errorDetail"]
      end

      rescue Faraday::ConnectionFailed
        @error = "There was a timeout. Please try again."
    end
    # render the search template with the result
    render 'search'
  end

end
