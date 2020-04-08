class GoogleMapsDriver
  def initialize(params)
    @params = params
  end

  def call
    puts 'Hello from fake google maps driver.'

    # TODO: real implementation
    {
      distance: 0,
      duration: 0
    }
  end

end