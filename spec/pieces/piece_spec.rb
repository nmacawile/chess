require_relative "../spec_helper"

describe Piece do
	subject { Piece.new(Board.new, :white, 1, 1) }

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
				Piece.new(subject.board, :white, 2, 2)
				expect( subject.friendly?(2, 2) ).to be true
			end
		end

		context "when piece at a, b is an enemy" do
			it "returns false" do
				Piece.new(subject.board, :black, 3, 3)
				expect( subject.friendly?(3, 3) ).to be false
			end
		end

		context "when a, b is an empty cell" do
			it "returns false" do
				expect( subject.friendly?(4, 4) ).to be false
			end
		end

	end

	describe "#enemy?(a, b)" do
		context "when piece at a, b is an enemy" do
			it "returns true" do
				Piece.new(subject.board, :black, 2, 2)
				expect( subject.enemy?(2, 2) ).to be true
			end
		end

		context "when piece at a, b is an enemy" do
			it "returns false" do
				Piece.new(subject.board, :white, 3, 3)
				expect( subject.enemy?(3, 3) ).to be false
			end
		end

		context "when a, b is an empty cell" do
			it "returns false" do
				expect( subject.enemy?(4, 4) ).to be false
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
			context "out of path or range" do
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

			context "within range and path but exposes king" do
				before do
					Rook.new(subject.board, :black, 4, 8)
					King.new(subject.board, :white, 4, 1)
					subject.move(4, 2)
				end

				it "stays in its current position" do					
					subject.move(5, 2)
					expect( subject.board.get(4, 2) ).to be subject
					expect( subject.board.get(5, 2) ).to be nil
				end

				it "doesn't update its position tracker" do
					subject.move(5, 2)
					expect( subject.position ).to eq([4, 2])
				end

				it "returns false" do
					expect( subject.move(5, 2) ).to be false
				end
			end
		end
	end

	describe "#moved?" do
		context "hasn't moved yet" do
			it "returns false" do
				expect( subject.moved? ).to be false
			end
		end

		context "has already moved" do
			it "returns true" do
				subject.move(6, 7)
				expect( subject.moved? ).to be true
			end
		end
	end
end