require_relative "../spec_helper"

describe Piece do
	before :all do 
		@board = Board.new
	end

	subject { Piece.new(@board, 1, 1) }

	describe "#new" do
		it "creates a new piece" do
			is_expected.to be_an_instance_of Piece
		end

		it "places it in the specified position" do
			expect( subject.board.get(1, 1) ).to be subject
		end
	end

	describe "#move(a, b)" do		
		it "moves to the specified position" do
			subject.move(1, 3)
			expect( subject.board.get(1, 3) ).to be subject
			expect( subject.board.get(1, 1) ).to be nil
		end
	end
end