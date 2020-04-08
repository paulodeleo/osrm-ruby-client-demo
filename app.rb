# Sample usage:
# ruby app.rb
# OSRM_ENDPOINT=http://router.project-osrm.org ruby app.rb
# OSRM_ENDPOINT=http://osrm-stg.james.delivery ruby app.rb

require 'JSON'
require 'rest-client'
require_relative './drivers/osrm_driver'
require_relative './drivers/google_maps_driver'
require_relative './geolocation_service'

# Sample service invocations:
service = GeolocationService.new
# service = GeolocationService.new(GeolocationService::DRIVERS[:osrm])
# service = GeolocationService.new(GeolocationService::DRIVERS[:google_maps])

# Better if extracted to something like a Geolocation::Parameters
location_params = {
  vehicle: :bus,
  from: {
    lat: -25.4345793,
    lon: -49.2798058
  },
  to: {
    lat: -25.4347096,
    lon: -49.289
  }
}

puts service.call(location_params)
