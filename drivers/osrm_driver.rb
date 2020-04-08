class OsrmDriver
  ENDPOINT = ENV['OSRM_ENDPOINT'] #|| 'http://router.project-osrm.org'
  ENDPOINT_TIMEOUT = 0.3 # In seconds
  VALID_VEHICLES = {
    car: 'car',
    bike: 'bike', # Currently not working with demo server?
    motorcycle: 'driving' # Same as "car" for demo server
  }

  attr_accessor :endpoint, :origin_lat, :origin_lon, :destiny_lat,
    :destiniy_lon, :vehicle, :response

  def initialize(params)
    @params = params
    validate_endpoint
    validate_params
    puts "Hello from OsrmDriver, everything OK"

    parse_params(params)
  end

  def call
    puts "I will call #{@endpoint}"
    get_response
    parse_response
  end

  private

  def validate_endpoint
    raise RuntimeError, 'No OSRM_ENDPOINT env var defined' unless ENDPOINT
  end

  def validate_params
    unless @params.dig(:vehicle)
      raise ArgumentError, 'Missing "vehicle" parameter'
    end

    unless VALID_VEHICLES.dig(@params.dig(:vehicle))
      raise ArgumentError, '"vehicle" parameter is not valid'
    end
    # ...
  end

  def parse_params(params)
    @endpoint = params[:endpoint] || ENDPOINT
    @vehicle = VALID_VEHICLES.dig(params[:vehicle])
    @origin_lat = params[:from][:lat]
    @origin_lon = params[:from][:lon]
    @destiny_lat = params[:to][:lat]
    @destiny_lon = params[:to][:lon]
  end

  def url
    "#{@endpoint}/route/v1/#{@vehicle}/#{@origin_lon},#{@origin_lat};" \
    "#{@destiny_lon},#{@destiny_lat}"
  end

  def get_response
    begin
      Timeout::timeout(ENDPOINT_TIMEOUT) { # RestClient timeout not working?
        response = RestClient.get(url)
        @response = JSON.parse(response.body, symbolize_names: true)
      }
    rescue Timeout::Error, RestClient::RequestTimeout => exception
      @response = nil
    end
  end

  def parse_response
    return empty_response_for_timeouts if @response.nil?
    {
      distance: parse_distance,
      duration: parse_duration
    }
  end

  def empty_response_for_timeouts
    {
      distance: 0,
      duration: 0
    }
  end

  def parse_distance
    @response.dig(:routes, 0, :distance)
  end

  def parse_duration
    @response.dig(:routes, 0, :duration)
  end

end