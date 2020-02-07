# frozen_string_literal: true

module Robot
  class Command
    attr_reader :width, :height, :current_x, :current_y, :orientations

    def initialize(grid_width: 5, grid_height: 5)
      @width, @height = [grid_width, grid_height]
      @orientations = %w[n e s w]
    end

    def accept?(command)
      %w[place move left right report].include?(command)
    end

    def place(xpos, ypos, facing)
      raise Robot::OutOfRange unless valid_coordinates?(xpos.to_i, ypos.to_i)

      turn(facing)
      @current_x = xpos
      @current_y = ypos
      "ok"
    end

    def move
      raise Robot::NotPlaced unless placed?

      place(*coordinates_ahead, current_direction)
    end

    def left
      raise Robot::NotPlaced unless placed?

      orientations.rotate!(-1)
      "ok"
    end

    def right
      raise Robot::NotPlaced unless placed?

      orientations.rotate!(1)
      "ok"
    end

    def report
      raise Robot::NotPlaced unless placed?

      translate = { "n" => "NORTH", "s" => "SOUTH", "e" => "EAST", "w" => "WEST" }
      "#{current_x},#{current_y},#{translate[current_direction]}"
    end

    def current_direction
      orientations[0]
    end

    private

    def placed?
      !!@current_x && !!@current_y
    end

    def turn(facing)
      raise Robot::UnknownDirection, facing unless orientations.include?(facing.downcase[0])

      orientations.rotate!(1) until current_direction == facing.downcase[0]
    end

    def valid_coordinates?(x, y)
      return false if x < 0 || x > (width - 1)
      return false if y < 0 || y > (height - 1)
      true
    end

    def coordinates_ahead
      case current_direction
      when "n" then [current_x.to_i, current_y.to_i + 1]
      when "s" then [current_x.to_i, current_y.to_i - 1]
      when "e" then [current_x.to_i + 1, current_y.to_i]
      when "w" then [current_x.to_i - 1, current_y.to_i]
      end
    end
  end
end
