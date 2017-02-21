require_relative "../spec_helper"

describe Queen do

	subject { Queen.new(Board.new, :white, 4, 5) }

	describe "#new" do
		it "inherits from Piece class" do
			expect( subject.class ).to be < Piece
		end
	end

end