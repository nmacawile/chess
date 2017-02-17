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

		it "keeps track of the kings' positions" do
			King.new(subject, :white, 1, 2)
			King.new(subject, :black, 5, 7)
			expect( subject.kings ).to include(:white => [1, 2], :black => [5, 7])			
		end
	end

	describe "#get(x, y)" do
		it "returns the piece at grid position x, y" do
			piece = double
			subject.grid[0][3] = piece
			expect( subject.get(1, 4) ).to be piece
		end
	end

	describe "#set(piece, x, y)" do
		it "sets the piece at grid position x, y" do
			piece = double
			subject.set(piece, 2, 3)
			expect( subject.get(2, 3) ).to be piece
		end
	end
end