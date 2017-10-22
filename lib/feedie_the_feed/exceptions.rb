require 'nesty'

module FeedieTheFeed
  # Exceptions used by other exceptions to enable nested exceptions with
  # 'nesty' gem by including Nesty::NestedError
  class Error < StandardError
    include Nesty::NestedError
  end

  # Exception used when Facebook authorisation fails with given credentials
  class FacebookAuthorisationError < Error; end

  # Exception used when the RSS or Facebook link provided isn't a valid one
  class BadUrl < Error; end
end
