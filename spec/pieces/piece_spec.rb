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
end