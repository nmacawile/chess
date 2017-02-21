require_relative "../spec_helper"

describe Queen do

	subject { Queen.new(Board.new, :white, 4, 5) }

	describe "#new" do
		it "inherits from Piece class" do
			expect( subject.class ).to be < Piece
		end
	end

	describe "#move(a, b)" do
		context "when move is legal" do
			context "diagonally" do
				context "going upper-left" do
					it "moves to the specified position" do
						subject.move(1, 8)
						expect( subject.board.get(4, 5) ).to be nil
						expect( subject.board.get(1, 8) ).to be subject
					end

					it "updates its position tracker" do
						subject.move(1, 8)
						expect( subject.position ).to eq([1, 8])
					end

					it "returns true" do
						expect( subject.move(1, 8) ).to be true
					end
				end

				context "going upper-right" do
					it "moves to the specified position" do
						subject.move(7, 8)
						expect( subject.board.get(4, 5) ).to be nil
						expect( subject.board.get(7, 8) ).to be subject
					end

					it "updates its position tracker" do
						subject.move(7, 8)
						expect( subject.position ).to eq([7, 8])
					end

					it "returns true" do
						expect( subject.move(7, 8) ).to be true
					end
				end

				context "going lower-left" do
					it "moves to the specified position" do
						subject.move(1, 2)
						expect( subject.board.get(4, 5) ).to be nil
						expect( subject.board.get(1, 2) ).to be subject
					end

					it "updates its position tracker" do
						subject.move(1, 2)
						expect( subject.position ).to eq([1, 2])
					end

					it "returns true" do
						expect( subject.move(1, 2) ).to be true
					end
				end

				context "going lower-right" do
					it "moves to the specified position" do
						subject.move(8, 1)
						expect( subject.board.get(4, 5) ).to be nil
						expect( subject.board.get(8, 1) ).to be subject
					end

					it "updates its position tracker" do
						subject.move(8, 1)
						expect( subject.position ).to eq([8, 1])
					end

					it "returns true" do
						expect( subject.move(8, 1) ).to be true
					end
				end

				context "destination cell occupied by enemy" do
					before do
						Piece.new(subject.board, :black, 1, 8)
					end

					it "moves to the specified position" do
						subject.move(1, 8)
						expect( subject.board.get(1, 8) ).to be subject
						expect( subject.board.get(4, 5) ).to be nil
					end

					it "updates its position tracker" do
						subject.move(1, 8)
						expect( subject.position ).to eq([1, 8])
					end

					it "returns true" do
						expect( subject.move(1, 8) ).to be true
					end
				end
			end

			context "horizontally and vertically" do
				context "going up" do
					it "moves to the specified position" do
						subject.move(4, 8)
						expect( subject.board.get(4, 5) ).to be nil
						expect( subject.board.get(4, 8) ).to be subject
					end

					it "updates its position tracker" do
						subject.move(4, 8)
						expect( subject.position ).to eq([4, 8])
					end

					it "returns true" do
						expect( subject.move(4, 8) ).to be true
					end
				end
				context "going down" do
					it "moves to the specified position" do
						subject.move(4, 1)
						expect( subject.board.get(4, 5) ).to be nil
						expect( subject.board.get(4, 1) ).to be subject
					end

					it "updates its position tracker" do
						subject.move(4, 1)
						expect( subject.position ).to eq([4, 1])
					end

					it "returns true" do
						expect( subject.move(4, 1) ).to be true
					end
				end
				context "going left" do
					it "moves to the specified position" do
						subject.move(1, 5)
						expect( subject.board.get(4, 5) ).to be nil
						expect( subject.board.get(1, 5) ).to be subject
					end

					it "updates its position tracker" do
						subject.move(1, 5)
						expect( subject.position ).to eq([1, 5])
					end

					it "returns true" do
						expect( subject.move(1, 5) ).to be true
					end
				end
				context "going right" do
					it "moves to the specified position" do
						subject.move(8, 5)
						expect( subject.board.get(4, 5) ).to be nil
						expect( subject.board.get(8, 5) ).to be subject
					end

					it "updates its position tracker" do
						subject.move(8, 5)
						expect( subject.position ).to eq([8, 5])
					end

					it "returns true" do
						expect( subject.move(8, 5) ).to be true
					end
				end

				context "destination cell occupied by enemy" do
					before do
						Piece.new(subject.board, :black, 4, 8)
					end

					it "moves to the specified position" do
						subject.move(4, 8)
						expect( subject.board.get(4, 8) ).to be subject
						expect( subject.board.get(4, 5) ).to be nil
					end

					it "updates its position tracker" do
						subject.move(4, 8)
						expect( subject.position ).to eq([4, 8])
					end

					it "returns true" do
						expect( subject.move(4, 8) ).to be true
					end
				end
			end

		end

		context "when move is illegal" do
			context "out of path" do
				before do
					subject.move(5, 7)
				end

				it "stays in its current position" do
					expect( subject.board.get(4, 5) ).to be subject
				end

				it "doesn't update its position tracker" do
					expect( subject.position ).to eq([4, 5])
				end

				it "returns false" do
					expect( subject.move(5, 7) ).to be false
				end
			end

			context "in path but blocked" do
				before do
					Piece.new(subject.board, :black, 6, 7)
				end

				it "stays in its current position" do
					subject.move(7, 8)
					expect( subject.board.get(4, 5) ).to be subject
				end

				it "doesn't update its position tracker" do
					subject.move(7, 8)
					expect( subject.position ).to eq([4, 5])
				end

				it "returns false" do
					expect( subject.move(7, 8) ).to be false
				end
			end

			context "destination cell occupied by friendly" do
				before do
					Piece.new(subject.board, :white, 7, 8)
				end

				it "stays in its current position" do
					subject.move(7, 8)
					expect( subject.board.get(4, 5) ).to be subject
				end

				it "doesn't update its position tracker" do
					subject.move(7, 8)
					expect( subject.position ).to eq([4, 5])
				end

				it "returns false" do
					expect( subject.move(7, 8) ).to be false
				end
			end		
		end

	end

end