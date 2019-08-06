class OVHTelecomControl::HttpError < StandardError
    attr_reader :code
    attr_reader :path
    attr_reader :method
    attr_reader :parameters

    def initialize(code:, path:, method:, parameters:, message:, **)
      super(message)
      @code = code
      @path = path
      @method = method
      @parameters = parameters
    end    
end