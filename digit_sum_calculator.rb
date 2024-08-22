class DigitSumCalculator
  class InvalidArgumentTypeError < StandardError; end

  INVALID_INPUT_ERROR_MESSAGE = 'Please provide an Integer value as the parameter'

  private_class_method :new
  def initialize(number)
    @number = number
  end

  class << self
    def calculate(input)
      check_input_type(input)
      new(input.abs).calculate
    end

    private

    def check_input_type(input)
      raise InvalidArgumentTypeError, INVALID_INPUT_ERROR_MESSAGE unless input.is_a? Integer
    end
  end

  def calculate
    return @number if @number < 10

    @number = @number.to_s.split('').map(&:to_i).sum
    calculate
  end
end

binding.irb if ENV['INTERACTIVE'] == 'true'
