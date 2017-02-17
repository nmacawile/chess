require_relative "../spec_helper"

describe King do
	subject { King.new(Board.new, :white, 4, 5) }
	describe "#new" do
		it "inherits from Piece class" do
			expect( subject.class ).to be < Piece
		end
	end
	describe "#move" do
		context "when move is legal" do
			context "going up" do
				it "moves to the specified position" do
					subject.move(4, 6)
					expect( subject.board.get(4, 5) ).to be nil
					expect( subject.board.get(4, 6) ).to be subject
				end

				it "updates its position tracker" do
					subject.move(4, 6)
					expect( subject.position ).to eq([4, 6])
				end

				it "returns true" do
					expect( subject.move(4, 6) ).to be true
				end
			end
			context "going down" do
				it "moves to the specified position" do
					subject.move(4, 4)
					expect( subject.board.get(4, 5) ).to be nil
					expect( subject.board.get(4, 4) ).to be subject
				end

				it "updates its position tracker" do
					subject.move(4, 4)
					expect( subject.position ).to eq([4, 4])
				end

				it "returns true" do
					expect( subject.move(4, 4) ).to be true
				end
			end
			context "going left" do
				it "moves to the specified position" do
					subject.move(3, 5)
					expect( subject.board.get(4, 5) ).to be nil
					expect( subject.board.get(3, 5) ).to be subject
				end

				it "updates its position tracker" do
					subject.move(3, 5)
					expect( subject.position ).to eq([3, 5])
				end

				it "returns true" do
					expect( subject.move(3, 5) ).to be true
				end
			end

			context "going right" do
				it "moves to the specified position" do
					subject.move(5, 5)
					expect( subject.board.get(4, 5) ).to be nil
					expect( subject.board.get(5, 5) ).to be subject
				end

				it "updates its position tracker" do
					subject.move(5, 5)
					expect( subject.position ).to eq([5, 5])
				end

				it "returns true" do
					expect( subject.move(5, 5) ).to be true
				end
			end

			context "going upper-left" do
				it "moves to the specified position" do
					subject.move(3, 6)
					expect( subject.board.get(4, 5) ).to be nil
					expect( subject.board.get(3, 6) ).to be subject
				end

				it "updates its position tracker" do
					subject.move(3, 6)
					expect( subject.position ).to eq([3, 6])
				end

				it "returns true" do
					expect( subject.move(3, 6) ).to be true
				end
			end

			context "going upper-right" do
				it "moves to the specified position" do
					subject.move(5, 6)
					expect( subject.board.get(4, 5) ).to be nil
					expect( subject.board.get(5, 6) ).to be subject
				end

				it "updates its position tracker" do
					subject.move(5, 6)
					expect( subject.position ).to eq([5, 6])
				end

				it "returns true" do
					expect( subject.move(5, 6) ).to be true
				end
			end

			context "going lower-left" do
				it "moves to the specified position" do
					subject.move(3, 4)
					expect( subject.board.get(4, 5) ).to be nil
					expect( subject.board.get(3, 4) ).to be subject
				end

				it "updates its position tracker" do
					subject.move(3, 4)
					expect( subject.position ).to eq([3, 4])
				end

				it "returns true" do
					expect( subject.move(3, 4) ).to be true
				end
			end

			context "going lower-right" do
				it "moves to the specified position" do
					subject.move(3, 6)
					expect( subject.board.get(4, 5) ).to be nil
					expect( subject.board.get(3, 6) ).to be subject
				end

				it "updates its position tracker" do
					subject.move(3, 6)
					expect( subject.position ).to eq([3, 6])
				end

				it "returns true" do
					expect( subject.move(3, 6) ).to be true
				end
			end

			context "destination cell occupied by enemy" do
				before do
					Piece.new(subject.board, :black, 4, 6)
				end

				it "moves to the specified position" do
					subject.move(4, 6)
					expect( subject.board.get(4, 6) ).to be subject
					expect( subject.board.get(4, 5) ).to be nil
				end

				it "updates its position tracker" do
					subject.move(4, 6)
					expect( subject.position ).to eq([4, 6])
				end

				it "returns true" do
					expect( subject.move(4, 6) ).to be true
				end
			end
		end

		context "when move is illegal" do
			context "out of range" do
				before do
					subject.move(1, 1)
				end

				it "stays in its current position" do
					expect( subject.board.get(4, 5) ).to be subject
				end

				it "doesn't update its position tracker" do
					expect( subject.position ).to eq([4, 5])
				end

				it "returns false" do
					expect( subject.move(1, 1) ).to be false
				end
			end

			context "destination cell occupied by friendly" do
				before do
					Piece.new(subject.board, :white, 4, 6)
				end

				it "stays in its current position" do
					subject.move(4, 6)
					expect( subject.board.get(4, 5) ).to be subject				
				end

				it "doesn't update its position tracker" do
					subject.move(4, 6)
					expect( subject.position ).to eq([4, 5])
				end

				it "returns false" do
					expect( subject.move(4, 6) ).to be false
				end
			end
		end
	end
end