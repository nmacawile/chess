require_relative "../spec_helper"

describe Knight do

	subject { Knight.new(Board.new, :white, 4, 5) }

	describe "#new" do
		it "inherits from Piece class" do
			expect( subject.class ).to be < Piece
		end
	end

	describe "#move(a, b)" do
		context "legal moves" do
			it "moves around in an L-shaped path" do 
				subject.move(2, 6)
				expect( subject.board.get(2, 6) ).to be subject
			end

			it "moves around in an L-shaped path" do
				subject.move(2, 4)
				expect( subject.board.get(2, 4) ).to be subject
			end

			it "moves around in an L-shaped path" do
				subject.move(3, 3)
				expect( subject.board.get(3, 3) ).to be subject
			end

			it "moves around in an L-shaped path" do
				subject.move(3, 7)
				expect( subject.board.get(3, 7) ).to be subject
			end

			it "moves around in an L-shaped path" do
				subject.move(5, 3)
				expect( subject.board.get(5, 3) ).to be subject
			end

			it "moves around in an L-shaped path" do
				subject.move(5, 7)
				expect( subject.board.get(5, 7) ).to be subject
			end

			it "moves around in an L-shaped path" do
				subject.move(6, 4)
				expect( subject.board.get(6, 4) ).to be subject
			end

			it "moves around in an L-shaped path" do
				subject.move(6, 6)
				expect( subject.board.get(6, 6) ).to be subject
			end

			context "destination cell occupied by enemy" do
				before do
					Piece.new(subject.board, :black, 2, 6)
				end

				it "moves to the specified position" do
					subject.move(2, 6)
					expect( subject.board.get(2, 6) ).to be subject
					expect( subject.board.get(4, 5) ).to be nil
				end

				it "updates its position tracker" do
					subject.move(2, 6)
					expect( subject.position ).to eq([2, 6])
				end

				it "returns true" do
					expect( subject.move(2, 6) ).to be true
				end
			end
		end

		context "illegal moves" do
			context "out of path" do 
				before do
					subject.move(4, 7)
				end

				it "stays in its current position" do
					expect( subject.board.get(4, 5) ).to be subject
				end

				it "doesn't update its position tracker" do
					expect( subject.position ).to eq([4, 5])
				end

				it "returns false" do
					expect( subject.move(4, 7) ).to be false
				end
			end

			context "destination cell occupied by friendly" do
				before do
					Piece.new(subject.board, :white, 5, 7)
				end

				it "stays in its current position" do
					subject.move(5, 7)
					expect( subject.board.get(4, 5) ).to be subject
				end

				it "doesn't update its position tracker" do
					subject.move(5, 7)
					expect( subject.position ).to eq([4, 5])
				end

				it "returns false" do
					expect( subject.move(5, 7) ).to be false
				end
			end	
		end
	end
end