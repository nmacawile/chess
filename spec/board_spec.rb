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

	describe "#friendlies(faction)" do
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

		context "king moving into an opponent pawn's 'capture cell" do
			it "returns false" do
				board = Board.new
				bking = King.new(board, :black, 8, 8)
				bking2 = King.new(board, :black, 8, 8)
				wpawn = Pawn.new(board, :white, 6, 6)
				expect( board.simulate_move(bking, 7, 7) ).to be false
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

	describe "#move(x1, y1, x2, y2)" do
		it "moves the piece in x1, y1 to y1, y2" do
			piece = Piece.new(subject, :white, 1, 1) 
			subject.move(1, 1, 2, 2)
			expect( subject.get(1, 1) ).to be nil
			expect( subject.get(2, 2) ).to be piece
		end
	end

	describe "#previous_turn" do
		context "when a piece moves" do
			before do
				piece1 = Piece.new(subject, :white, 1, 1)
				piece1.move(2, 2)
			end

			it "returns the faction of the piece that moved last" do
				expect( subject.previous_turn ).to eq :white
			end

			it "returns the faction of the piece that moved last" do
				piece2 = Piece.new(subject, :black, 3, 3)
				piece2.move(4, 4)
				expect( subject.previous_turn ).to eq :black
			end
		end

		context "when no pieces have moved yet" do
			it "returns nil" do
				piece1 = Piece.new(subject, :white, 1, 1)
				piece2 = Piece.new(subject, :black, 8, 8)
				expect( subject.previous_turn ).to be nil
			end
		end
	end

	describe "#copy_pieces_to(new_board)" do
		it "creates a copy of the current state of the board" do
			original = Board.new
			King.new(original, :white, 1, 2)
			Queen.new(original, :white, 2, 3)
			Rook.new(original, :white, 3, 4)
			Bishop.new(original, :white, 4, 5)
			copy = original.copy

			expect( copy.get(1, 2) ).to be_an_instance_of King
			expect( copy.get(2, 3) ).to be_an_instance_of Queen
			expect( copy.get(3, 4) ).to be_an_instance_of Rook
			expect( copy.get(4, 5) ).to be_an_instance_of Bishop
		end

		it "copies previous_turn value over to the new board" do
			original = Board.new
			wk = King.new(original, :white, 1, 2)
			bk = King.new(original, :black, 1, 8)
			wk.move(2, 2)
			bk.move(1, 7)

			copy = original.copy
			expect( copy.previous_turn ).to eq :black
		end

		context "pawn copy" do
			context "en passant window" do
				it "copies pawn's special attributes" do
					original = Board.new
					wk = King.new(original, :white, 1, 5)			
					bk = King.new(original, :black, 8, 5)

					pawn1 = Pawn.new(original, :white, 2, 2)
					pawn2 = Pawn.new(original, :black, 3, 7)

					pawn1.move(2, 4)
					pawn1.move(2, 5)
					pawn2.move(3, 5)

					copy = original.copy

					expect( copy.get(2, 5).en_passant_cell ).to eq [3, 6]
					expect( copy.get(2, 5).en_passant_capture_cell ).to eq [3, 5]
				end
			end

			context "en passant expires" do
				it "copies pawn's special attributes" do
					original = Board.new
					wk = King.new(original, :white, 1, 5)			
					bk = King.new(original, :black, 8, 5)

					pawn1 = Pawn.new(original, :white, 2, 2)
					pawn2 = Pawn.new(original, :black, 3, 7)

					pawn1.move(2, 4)
					pawn1.move(2, 5)
					pawn2.move(3, 5)
					wk.move(1, 6)

					copy = original.copy

					expect( copy.get(2, 5).en_passant_cell ).to eq nil
				end
			end
		end
	end

	describe "#available_moves(faction)" do
		it "returns a hash table of each piece's position and the array of all its available moves as value" do
			board = Board.new

			Queen.new(board, :black, 6, 8)
			Bishop.new(board, :black, 1, 5)
			Pawn.new(board, :white, 2, 2)
			Pawn.new(board, :white, 4, 2)
			King.new(board, :white, 5, 1)

			result = board.available_moves(:white)

			expect( result ).to have_key([5, 1])
			expect( result ).to have_key([2, 2])
			expect( result ).not_to have_key([4, 2])

			expect( result[[5, 1]] ).to match_array [[5, 2], [4, 1]]
			expect( result[[2, 2]] ).to match_array [[2, 3], [2, 4]]
		end
	end
end