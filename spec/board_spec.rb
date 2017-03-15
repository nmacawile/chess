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
			piece = Piece.new(subject, :red, 2, 3)
			expect( subject.get(2, 3) ).to be piece
		end

		it "records all the captured pieces" do
			piece_a = Piece.new(subject, :red, 1, 3)
			piece_b = Piece.new(subject, :blue, 3, 3)
			piece_a.move(3, 3)

			expect( subject.captures[:red] ).to include piece_b
		end
	end

	describe "#pieces_in_play" do
		it "list all pieces in play" do
			piece1 = Piece.new(subject, :black, 1, 1)
			piece2 = Piece.new(subject, :white, 1, 2)
			piece3 = Piece.new(subject, :white, 1, 3)
			piece4 = Piece.new(subject, :black, 1, 4)
			expect( subject.pieces_in_play.count ).to eq 4
			expect( subject.pieces_in_play ).to include(piece1, piece2, piece3, piece4)
			expect( subject.pieces_in_play ).not_to include nil
		end
	end

	describe "#enemies(faction)" do
		it "list all enemy pieces in board" do
			piece1 = Piece.new(subject, :black, 1, 1)
			piece2 = Piece.new(subject, :white, 1, 2)
			piece3 = Piece.new(subject, :white, 1, 3)
			piece4 = Piece.new(subject, :black, 1, 4)
			expect( subject.enemies(:white) ).to include(piece1, piece4)
			expect( subject.enemies(:white) ).not_to include(piece2, piece3)
		end
	end

	describe "#pieces(faction)" do
		it "list all friendly pieces in board" do
			piece1 = Piece.new(subject, :black, 1, 1)
			piece2 = Piece.new(subject, :white, 1, 2)
			piece3 = Piece.new(subject, :white, 1, 3)
			piece4 = Piece.new(subject, :black, 1, 4)
			expect( subject.friendlies(:white) ).to include(piece2, piece3)
			expect( subject.friendlies(:white) ).not_to include(piece1, piece4)
		end
	end

	describe "#enemy_moves(faction)" do
		it "shows all possible moves of all enemy pieces" do
			rook = Rook.new(subject, :black, 5, 5)
			expect( subject.enemy_moves(:white) ).to include [1, 5], [8, 5], [5, 1], [5, 8]
		end
	end

	describe "#friendly_moves(faction)" do
		it "shows all possible moves of all friendly pieces" do
			rook = Rook.new(subject, :white, 5, 5)
			expect( subject.friendly_moves(:white) ).to include [1, 5], [8, 5], [5, 1], [5, 8]
		end
	end

	describe "#checked?(faction)" do
		context "checked" do
			it "returns true" do
				rook = Rook.new(subject, :black, 1, 5)
				king = King.new(subject, :white, 8, 5)			
				expect( subject.checked?(:white) ).to be true
			end
		end

		context "not checked" do
			it "returns false" do
				rook = Rook.new(subject, :black, 1, 6)
				king = King.new(subject, :white, 8, 5)			
				expect( subject.checked?(:white) ).to be false
			end
		end
	end

	describe "#simulate_move(piece, x, y)" do
		before do
			rook = Rook.new(subject, :black, 1, 5)			
			king = King.new(subject, :white, 8, 5)
		end

		context "exposes king" do
			it "returns false" do
				piece = Piece.new(subject, :white, 7, 5)	
				expect( subject.simulate_move(piece, 7, 4) ).to be false
			end

			it "stays in its current position" do
				piece = Piece.new(subject, :white, 7, 5)
				subject.simulate_move(piece, 7, 4)
				expect( subject.get(7, 5) ).to be piece
			end
		end

		context "doesn't expose king" do
			it "returns true" do
				piece = Piece.new(subject, :white, 7, 5)	
				expect( subject.simulate_move(piece, 6, 5) ).to be true
			end

			it "stays in its current position" do
				piece = Piece.new(subject, :white, 7, 5)
				subject.simulate_move(piece, 6, 5)
				expect( subject.get(7, 5) ).to be piece
			end
		end
	end

	describe "#occupied_cells" do
		it "lists all cells that are occupied" do
			p2 = Piece.new(subject, :white, 7, 5)
			p1 = Piece.new(subject, :white, 7, 6)
			p1.move(2, 4)
			p2.move(3, 5)
			expect( subject.occupied_cells ).to include [3, 5], [2, 4]
		end
	end

	describe "#stalemate?(faction)" do
		context "when there are no possible moves available" do
			context "not checked" do
				it "returns true" do
					board = Board.new
					King.new(board, :white, 8, 8)
					Rook.new(board, :black, 7, 6)
					Rook.new(board, :black, 6, 7)
					expect( board.stalemate?(:white) ).to be true
				end
			end

			context "checked" do
				it "returns false" do
					board = Board.new
					King.new(board, :white, 8, 8)
					Rook.new(board, :black, 7, 6)
					Rook.new(board, :black, 6, 7)
					Bishop.new(board, :black, 6, 6)
					expect( board.stalemate?(:white) ).to be false
				end
			end
		end
	end

	describe "#checkmate?(faction)" do
		context "when there are no possible moves available" do
			context "not checked" do
				it "returns false" do
					board = Board.new
					King.new(board, :white, 8, 8)
					Rook.new(board, :black, 7, 6)
					Rook.new(board, :black, 6, 7)
					expect( board.checkmate?(:white) ).to be false
				end
			end

			context "checked" do
				it "returns true" do
					board = Board.new
					King.new(board, :white, 8, 8)
					Rook.new(board, :black, 7, 6)
					Rook.new(board, :black, 6, 7)
					Bishop.new(board, :black, 6, 6)
					expect( board.checkmate?(:white) ).to be true
				end
			end
		end
	end
end