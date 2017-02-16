require_relative "../spec_helper"

describe Piece do
	before :all do 
		@board = Board.new
	end

	subject { Piece.new(@board, :white, 1, 1) }

	describe "#new" do
		it "creates a new piece" do
			is_expected.to be_an_instance_of Piece
		end

		it "places it in the specified position" do
			expect( subject.board.get(1, 1) ).to be subject
		end
	end

	describe "#friendly?(a, b)" do
		context "when piece at a, b is a friendly" do
			it "returns true" do
				Piece.new(@board, :white, 2, 2)
				expect( subject.friendly?(2, 2) ).to be true
			end
		end

		context "when piece at a, b is an enemy" do
			it "returns false" do
				Piece.new(@board, :black, 3, 3)
				expect( subject.friendly?(3, 3) ).to be false
			end
		end

		context "when a, b is an empty cell" do
			it "returns false" do
				expect( subject.friendly?(4, 4) ).to be false
			end
		end

	end

	describe "#move(a, b)" do
		context "when move is legal" do
			before do
				subject.move(1, 3)
			end

			it "moves to the specified position" do
				expect( subject.board.get(1, 3) ).to be subject
				expect( subject.board.get(1, 1) ).to be nil
			end

			it "updates its position tracker" do
				expect( subject.position ).to eq([1, 3])
			end

			it "returns true" do
				expect( subject.move(1, 3) ).to be true
			end
		end

		context "when move is illegal" do
			before do
				subject.move(10, 3)
			end

			it "stays in its current position" do
				expect( subject.board.get(1, 1) ).to be subject
			end

			it "doesn't update its position tracker" do
				expect( subject.position ).to eq([1, 1])
			end

			it "returns false" do
				expect( subject.move(10, 3) ).to be false
			end
		end
	end
end