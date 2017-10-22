# This class extends String with some helper methods, like truncate.
class String
  # Mimics core functionality of RoR String's truncate method, by cutting
  # a string to a certain length, while adding '...' to the end and making
  # sure it won't cut in the middle of a word, just on a space.
  #
  #   The original RoR truncate method can be found here: goo.gl/unjyZm
  #   Copyright (c) 2005-2017 David Heinemeier Hansson
  #   MIT licence: https://github.com/rails/rails/blob/master/MIT-LICENSE
  #   (pls, don't sue me)
  #
  # @param truncate_at [Integer] The desired length to cut the string to
  # @return [self] The truncated string
  def truncate(truncate_at)
    return dup unless length > truncate_at

    omission = '...'
    length_with_room_for_omission = truncate_at - omission.length
    stop = rindex(' ', length_with_room_for_omission) ||
           length_with_room_for_omission

    "#{self[0, stop]}#{omission}"
  end
end
