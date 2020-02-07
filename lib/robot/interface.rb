# frozen_string_literal: true

# Interface for processing user input,
# sending cammands to be handled by app,
# and translating user friendly errors

module Robot
  class Interface
    attr_reader :prompt, :command_handler

    def initialize(tty_prompt, command_handler)
      @prompt = tty_prompt

      @prompt.on(:keyescape) do
        prompt.ok("Goodbye!")
        exit
      end

      @command_handler = command_handler
    end

    def input(capture)
      return if capture.nil?

      command, options = capture.split(' ')

      command.downcase!

      return send(command) if %w[exit help].include?(command)

      raise Robot::UnknownCommand, command unless command_handler.accept?(command)

      command_resoponse = command_handler.send(command, *[*options&.split(',')])

      prompt.ok(command_resoponse)

    rescue Robot::Error => e
      prompt_error(e)
    end

    private

    def prompt_error(e)
      case e
      when Robot::NotPlaced
        prompt.error(
          "Please put me on the table first!"
        )

      when Robot::UnknownDirection
        prompt.error(
          "I do not understand the direction '#{e.message}'."
        )

      when Robot::OutOfRange
        prompt.error(
          "I am a robot not a drone. I require solid ground."
        )

      when Robot::UnknownCommand
        prompt.error(
          "Unknown command: '#{e.message}', type 'HELP' to see all valid commands"
        )

      else raise e
      end
    end

    def help
      prompt.say(
        File.read("#{File.dirname(__FILE__)}/../../cmd.help")
      )
    end
  end
end
