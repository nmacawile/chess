require_relative "../spec_helper"

describe Rook do
	subject { Rook.new(Board.new, :white, 4, 5) }
	describe "#new" do
		it "inherits from Piece class" do
			expect( subject.class ).to be < Piece
		end
	end

	describe "#move(a, b)" do
		context "when move is legal" do
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
		end

		context "when move is illegal" do
			context "out of path" do
				before do
					subject.move(3, 4)
				end

				it "stays in its current position" do
					expect( subject.board.get(4, 5) ).to be subject
				end

				it "doesn't update its position tracker" do
					expect( subject.position ).to eq([4, 5])
				end

				it "returns false" do
					expect( subject.move(3, 4) ).to be false
				end
			end

			context "in path but blocked" do
				before do
					Piece.new(subject.board, :black, 4, 7)
				end

				it "stays in its current position" do
					subject.move(4, 8)
					expect( subject.board.get(4, 5) ).to be subject
				end

				it "doesn't update its position tracker" do
					subject.move(4, 8)
					expect( subject.position ).to eq([4, 5])
				end

				it "returns false" do
					expect( subject.move(4, 8) ).to be false
				end
			end

			context "in path but destination is occupied" do
				context "by friendly" do
					before do
						Piece.new(subject.board, :white, 4, 8)
					end

					it "stays in its current position" do
						subject.move(4, 8)
						expect( subject.board.get(4, 5) ).to be subject
					end

					it "doesn't update its position tracker" do
						subject.move(4, 8)
						expect( subject.position ).to eq([4, 5])
					end

					it "returns false" do
						expect( subject.move(4, 8) ).to be false
					end
				end

				context "by enemy" do
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
	end
	
end