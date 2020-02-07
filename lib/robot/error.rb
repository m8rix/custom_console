module Robot
  class Error < StandardError; end

  class NotPlaced < Error; end

  class UnknownDirection < Error; end

  class OutOfRange < Error; end

  class UnknownCommand < Error; end
end
