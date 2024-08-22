require 'faker'
require_relative '../digit_sum_calculator'

RSpec.describe DigitSumCalculator do
  describe '.new' do
    it 'cannot be instantiated from ouside' do
      expect { described_class.new(10) }.to raise_error(NoMethodError)
    end
  end

  describe '.calculate' do
    context 'with non Integer input' do
      it 'raises an invalid argument type error' do
        expect { described_class.calculate('Hello world!') }
          .to raise_error(described_class::InvalidArgumentTypeError)
          .with_message(described_class::INVALID_INPUT_ERROR_MESSAGE)
      end
    end

    context 'with Integer input' do
      shared_examples_for 'a call with correct input' do
        it 'initializes the class with the absolute value of the input and calls calculate on the instance' do
          mock_instance = double(calculate: true)
          expect(described_class)
            .to receive(:new).with(expected_input)
            .and_return(mock_instance)

          described_class.calculate(input)

          expect(mock_instance).to have_received(:calculate)
        end
      end

      context 'when the input is a positive Integer' do
        let(:input) { Faker::Number.number }
        let(:expected_input) { input }
        include_examples 'a call with correct input'
      end

      context 'when the input is a negative Integer' do
        let(:input) { -1 * Faker::Number.number }
        let(:expected_input) { input.abs }
        include_examples 'a call with correct input'
      end
    end
  end

  describe '#calculate' do
    let(:subject) { described_class.send(:new, number) }

    context 'when the number is less than 10' do
      let(:number) { Faker::Number.digit }

      it 'returns the number' do
        expect(subject).to receive(:calculate).once.and_call_original
        expect(subject.calculate).to eq(number)
      end
    end

    context 'when the number is greater than 10' do
      context 'and the initial digit sum less than 10' do
        # 16 => 1 + 6 = 7
        let(:number) { 16 }
        let(:expected_digit_sum) { 7 }

        it 'returns the digit sum' do
          expect(subject).to receive(:calculate).twice.and_call_original
          expect(subject.calculate).to eq(expected_digit_sum)
        end
      end

      context 'and the initial digit sum is greater than 10' do
        # 942 => 9 + 4 + 2 = 15 => 1 + 5 = 6
        let(:number) { 942 }
        let(:expected_digit_sum) { 6 }

        it 'keeps calculating the digit sum until it is less than 10' do
          expect(subject).to receive(:calculate).thrice.and_call_original
          expect(subject.calculate).to eq(expected_digit_sum)
        end
      end
    end
  end
end
