class GeolocationService
  DRIVERS = {
    osrm: OsrmDriver,
    google_maps: GoogleMapsDriver
  }

  VEHICLE_OPTIONS = [:car, :bike, :motorcycle]

  attr_accessor :driver, :params, :external_response

  def initialize(driver = nil)
    @driver = driver || GeolocationService::DRIVERS.dig(:osrm)
  end

  def call(params)
    @params = params
    validate_params

    driver_instance = @driver.new(@params)

    begin
      @driver_response = driver_instance.call
    rescue Exception => exception
      treat_unexpected_driver_exception(exception)
    end

    test_incomplete_driver = false # For demonstrations purposes
    if test_incomplete_driver
      @driver_response
    else
      validate_driver_response
      parse_driver_response
    end
  end

  private

  def validate_params
    validate_lat_param
    validate_vehicle_param
    # ...
  end

  def validate_lat_param
    param = @params.dig(:from, :lat)
    raise ArgumentError, 'Missing "from.lat" parameter' unless params
    unless param.is_a?(Float)
      raise ArgumentError, 'Parameter "from.lat" must be a float'
    end
  end

  def validate_vehicle_param
    param = @params.dig(:vehicle)
    raise ArgumentError, 'Missing "vehicle" parameter' unless param
    unless VEHICLE_OPTIONS.include?(param)
      raise ArgumentError, '"vehicle" parameter is not valid'
    end
  end

  def validate_driver_response
    unless @driver_response && @driver_response.dig(:distance) && @driver_response.dig(:duration)
      raise RuntimeError, "Invalid response from #{@driver}: #{@driver_response}"
    end
  end

  def treat_unexpected_driver_exception(exception)
    # ... logs the exception details to something like newrelic then ...
    raise RuntimeError, "Unexpected error calling #{driver}: #{exception}"
  end

  def parse_driver_response
    {
      forecast: {
        distance: @driver_response.dig(:distance),
        duration: @driver_response.dig(:duration)
      }
    }
  end

end