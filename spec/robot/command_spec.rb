# frozen_string_literal: true

RSpec.describe Robot::Command do
  NORTH = "NORTH"
  SOUTH = "SOUTH"
  EAST = "EAST"
  WEST = "WEST"

  let(:object) { Robot::Command.new(grid_width: 5, grid_height: 5) }

  describe "ensure coordinates 0,0 are in SOUTH WEST most corner" do
    subject { object.move }

    context "when there is nothing further SOUTH than 0,0" do
      before { object.place(0, 0, SOUTH) }

      it { expect { subject }.to raise_error(Robot::OutOfRange) }
    end

    context "when there is nothing further WEST than 0,0" do
      before { object.place(0, 0, WEST) }

      it { expect { subject }.to raise_error(Robot::OutOfRange) }
    end
  end

  describe ".accept?" do
    let(:command) { "" }

    subject { object.accept?(command) }

    context "valid commands" do
      context "place" do
        let(:command) { "place" }

        it { is_expected.to be_truthy }
      end

      context "move" do
        let(:command) { "move" }

        it { is_expected.to be_truthy }
      end

      context "left" do
        let(:command) { "left" }

        it { is_expected.to be_truthy }
      end

      context "right" do
        let(:command) { "right" }

        it { is_expected.to be_truthy }
      end

      context "report" do
        let(:command) { "report" }

        it { is_expected.to be_truthy }
      end
    end

    context "invalid commands" do
      context "blarg" do
        let(:command) { "blarg" }

        it { is_expected.to be_falsey }
      end

      context "help" do
        let(:command) { "help" }

        it { is_expected.to be_falsey }
      end

      context "exit" do
        let(:command) { "exit" }

        it { is_expected.to be_falsey }
      end
    end
  end

  describe ".place" do
    let(:args) { [] }

    subject { object.place(*args) }

    context "valid placement commands" do
      context "PLACE 0,0,NORTH" do
        let(:args) { [0, 0, NORTH] }

        it { is_expected.to eq "ok" }
      end

      context "PLACE 1,2,SOUTH" do
        let(:args) { [1, 2, SOUTH] }

        it { is_expected.to eq "ok" }
      end

      context "PLACE 3,4,EAST" do
        let(:args) { [3, 4, EAST] }

        it { is_expected.to eq "ok" }
      end

      context "PLACE 0,4,WEST" do
        let(:args) { [0, 4, WEST] }

        it { is_expected.to eq "ok" }
      end
    end

    context "invalid placement commands" do
      context "PLACE 0,0,UP" do
        let(:args) { [0, 0, "UP"] }

        it { expect { subject }.to raise_error(Robot::UnknownDirection) }
      end

      context "PLACE 0,5,SOUTH" do
        let(:args) { [0, 5, SOUTH] }

        it { expect { subject }.to raise_error(Robot::OutOfRange) }
      end

      context "PLACE 5,0,EAST" do
        let(:args) { [5, 0, EAST] }

        it { expect { subject }.to raise_error(Robot::OutOfRange) }
      end

      context "PLACE 5,5,WEST" do
        let(:args) { [5, 5, WEST] }

        it { expect { subject }.to raise_error(Robot::OutOfRange) }
      end
    end
  end

  describe ".move" do
    subject { object.move }

    context "when robot is not placed" do
      it { expect { subject }.to raise_error(Robot::NotPlaced) }
    end

    context "when no more room on grid to move" do
      before { object.place(0, 0, SOUTH) }

      it { expect { subject }.to raise_error(Robot::OutOfRange) }
    end

    context "when robot has somewhere to move" do
      before { object.place(0, 0, NORTH) }

      it { is_expected.to eq "ok" }
    end
  end

  describe ".left" do
    subject { object.left }

    context "when robot is not placed" do
      it { expect { subject }.to raise_error(Robot::NotPlaced) }
    end

    context "when robot is placed" do
      before { object.place(0, 0, NORTH) }

      it { is_expected.to eq "ok" }

      it { expect { subject }.to change(object, :current_direction).from('n').to('w') }
    end
  end

  describe ".right" do
    subject { object.right }

    context "when robot is not placed" do
      it { expect { subject }.to raise_error(Robot::NotPlaced) }
    end

    context "when robot is placed" do
      before { object.place(0, 0, NORTH) }

      it { is_expected.to eq "ok" }

      it { expect { subject }.to change(object, :current_direction).from('n').to('e') }
    end
  end

  describe ".report" do
    subject { object.report }

    context "when robot is not placed" do
      it { expect { subject }.to raise_error(Robot::NotPlaced) }
    end

    context "when robot is placed" do
      before { object.place(0, 0, NORTH) }

      it { is_expected.to eq "0,0,NORTH" }
    end
  end
end
