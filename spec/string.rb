require 'feedie_the_feed'

# rubocop:disable Metrics/BlockLength
describe String do
  context 'When testing the String class' do
    it "should truncate the string to the given length and add '...' " \
      "in the end, and in a fashion that it won't be in a middle of a word, " \
      "just on a space (if possible), or return the string if it's length" \
      'already lower than required, when we call the truncate(truncate_at)' \
      'method' do

      # This method is used to validate the behaviour of the truncate method
      def validates?(initial_string, truncate_at, expected_string)
        return true if initial_string.length <= truncate_at

        if expected_string.length <= truncate_at &&
           expected_string =~ /.*\.\.\.\z/
          true
        else
          false
        end
      end

      # https://stackoverflow.com/a/88341/5861424
      # Generate random string
      #
      # Symbols range
      range = [('a'..'z'), ('A'..'Z')].map(&:to_a).flatten
      # Add some spaces to the range
      10.times { |_n| range << ' ' }
      # Finally generate the string
      initial_string_rand = (0...50).map { range[rand(range.length)] }.join
      truncate_at_rand = rand(1..70)
      expected_string_rand = initial_string_rand.truncate(truncate_at_rand)
      expect(
        validates?(initial_string_rand, truncate_at_rand, expected_string_rand)
      ).to eq true

      initial_string1 = 'abc'
      truncate_at1 = 5
      # 'abc'
      expected_string1 = initial_string1.truncate(truncate_at1)
      expect(
        validates?(initial_string1, truncate_at1, expected_string1)
      ).to eq true

      initial_string2 = 'abcdefghijklmnop'
      truncate_at2 = 5
      # 'ab...'
      expected_string2 = initial_string2.truncate(truncate_at2)
      expect(
        validates?(initial_string2, truncate_at2, expected_string2)
      ).to eq true

      initial_string3 = '1 2 3 4 5'
      truncate_at3 = 5
      # '1...'
      expected_string3 = initial_string3.truncate(truncate_at3)
      expect(
        validates?(initial_string3, truncate_at3, expected_string3)
      ).to eq true
    end
  end
end
