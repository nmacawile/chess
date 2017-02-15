require_relative "spec_helper"

describe Board do

	subject { Board.new }

	describe "#new" do
		it "creates a board object" do
			is_expected.to be_an_instance_of Board
		end

		it "the board has an 8 by 8 grid" do
			expect( subject.grid.size ).to eq 8
			expect( subject.grid.last.size ).to eq 8
		end
	end

	describe "#at(x, y)" do
		it "gives access to grid position x, y" do
			piece = double
			subject.grid[0][3] = piece
			expect( subject.at(1, 4) ).to be piece
		end
	end
end