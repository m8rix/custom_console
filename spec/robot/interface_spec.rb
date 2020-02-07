# frozen_string_literal: true

require 'tty-prompt'

RSpec.describe Robot::Interface do
  let(:tty_prompt) { TTY::TestPrompt.new(interrupt: :exit, active_color: :bright_black, prefix: 'robot >') }

  let(:command_handler) { Robot::Command.new(grid_width: 5, grid_height: 5) }

  let(:interface) { Robot::Interface.new(tty_prompt, command_handler) }

  subject { tty_prompt.output.string }

  def green(text)
    "\e[32m#{text}\e[0m\n"
  end

  def red(text)
    "\e[31m#{text}\e[0m\n"
  end

  context "responding to given commands" do
    let(:command_sequence) { [] }

    context "when robot is not placed" do
      before { command_sequence.each { |command| interface.input(command) } }

      context "place inside the grid" do
        let(:command_sequence) { ["PLACE 0,0,NORTH"] }

        it { is_expected.to eq green("ok") }
      end

      context "place outside the grid" do
        let(:command_sequence) { ["PLACE 5,5,NORTH"] }

        it { is_expected.to eq red("I am a robot not a drone. I require solid ground.") }
      end

      context "place with invalid direction" do
        let(:command_sequence) { ["PLACE 0,0,UP"] }

        it { is_expected.to eq red("I do not understand the direction 'UP'.") }
      end

      context "moving the robot once" do
        let(:command_sequence) { ["MOVE"] }

        it { is_expected.to eq red("Please put me on the table first!") }
      end

      context "turn left" do
        let(:command_sequence) { ["LEFT"] }

        it { is_expected.to eq red("Please put me on the table first!") }
      end

      context "turn right" do
        let(:command_sequence) { ["RIGHT"] }

        it { is_expected.to eq red("Please put me on the table first!") }
      end

      context "report location and orientation" do
        let(:command_sequence) { ["REPORT"] }

        it { is_expected.to eq red("Please put me on the table first!") }
      end

      context "responding to unknown command" do
        let(:command_sequence) { ["BLARG"] }

        it { is_expected.to eq red("Unknown command: 'blarg', type 'HELP' to see all valid commands") }
      end
    end

    context "with robot placed on grid" do
      let(:initial_orientation) { "NORTH" }

      before { command_handler.place(0, 0, initial_orientation) }

      before { command_sequence.each { |command| interface.input(command) } }

      context "moving the robot once" do
        let(:command_sequence) { ["MOVE"] }

        it { is_expected.to eq green("ok") }
      end

      context "moving the robot multiple times" do
        let(:command_sequence) { ["MOVE", "MOVE", "MOVE", "MOVE", "MOVE"] }

        it { is_expected.to eq (
          green("ok") +
          green("ok") +
          green("ok") +
          green("ok") +
          red("I am a robot not a drone. I require solid ground.")
        )}
      end

      context "moving the robot outside the grid" do
        let(:initial_orientation) { "SOUTH" }

        let(:command_sequence) { ["MOVE"] }

        it { is_expected.to eq red("I am a robot not a drone. I require solid ground.") }
      end

      context "report location and orientation" do
        let(:initial_orientation) { "NORTH" }

        let(:command_sequence) { ["REPORT"] }

        it { is_expected.to eq green("0,0,#{initial_orientation}") }
      end

      context "turn left" do
        let(:initial_orientation) { "NORTH" }

        let(:command_sequence) { ["LEFT", "REPORT"] }

        it { is_expected.to eq (
          green("ok") +
          green("0,0,WEST")
        )}
      end

      context "turn right" do
        let(:initial_orientation) { "NORTH" }

        let(:command_sequence) { ["RIGHT", "REPORT"] }

        it { is_expected.to eq (
          green("ok") +
          green("0,0,EAST")
        )}
      end

      context "re-place inside the grid" do
        let(:initial_orientation) { "NORTH" }

        let(:command_sequence) { ["PLACE 3,2,EAST", "REPORT"] }

        it { is_expected.to eq (
          green("ok") +
          green("3,2,EAST")
        )}
      end
    end
  end

  context "help command" do
    before { interface.input('help') }

    it { is_expected.to eq (
      File.read("#{File.dirname(__FILE__)}/../../cmd.help")
    )}
  end

  context "code challenge scenarios" do
    before { command_sequence.each { |command| interface.input(command) } }

    context "scenario one" do
      let(:command_sequence) { ["PLACE 0,0,NORTH","MOVE","REPORT"] }

      it { is_expected.to eq (
        green("ok") +
        green("ok") +
        green("0,1,NORTH")
      )}
    end

    context "scenario two" do
      let(:command_sequence) { ["PLACE 0,0,NORTH","LEFT","REPORT"] }

      it { is_expected.to eq (
        green("ok") +
        green("ok") +
        green("0,0,WEST")
      )}
    end

    context "scenario three" do
      let(:command_sequence) { ["PLACE 1,2,EAST","MOVE","MOVE","LEFT","MOVE","REPORT"] }

      it { is_expected.to eq (
        green("ok") +
        green("ok") +
        green("ok") +
        green("ok") +
        green("ok") +
        green("3,3,NORTH")
      )}
    end
  end
end
