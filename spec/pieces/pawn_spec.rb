require_relative "../spec_helper"

describe Pawn do
	subject { Pawn.new(Board.new, :white, 2, 2) }
	describe "#new" do
		it "inherits from Piece class" do
			expect( subject.class ).to be < Piece
		end
	end

	describe "#move(a, b)" do
		context "moving forward 1 step" do
			context "started from bottom half of board (white)" do
				context "clear path" do
					it "moves" do
						subject.move(2, 3)
						expect( subject.board.get(2, 3) ).to be subject
					end
				end

				context "blocked on target cell" do
					it "doesn't move" do						
						blocker = Piece.new(subject.board, :black, 2, 3)
						subject.move(2, 3)
						expect( subject.board.get(2, 2) ).to be subject
						expect( subject.board.get(2, 3) ).to be blocker
					end
				end
			end

			context "started from top half of board (black)" do
				context "clear path" do
					it "moves" do
						subject = Pawn.new(Board.new, :black, 2, 7)
						subject.move(2, 6)
						expect( subject.board.get(2, 6) ).to be subject
					end
				end

				context "blocked on target cell" do
					it "doesn't move" do
						subject = Pawn.new(Board.new, :black, 2, 7)						
						blocker = Piece.new(subject.board, :white, 2, 6)
						subject.move(2, 6)
						expect( subject.board.get(2, 7) ).to be subject
						expect( subject.board.get(2, 6) ).to be blocker
					end
				end
			end
		end

		context "moving forward 2 steps" do
			context "from starting position" do
				context "clear path" do
					it "moves" do
						subject.move(2, 4)
						expect( subject.board.get(2, 4) ).to be subject
					end

					context "bypassing opposing pawn(s)" do
						context "very next turn" do
							it "enables bypassed opponent piece to execute en passant" do
								enemy = Pawn.new(subject.board, :black, 3, 5)
								enemy.move(3, 4)
								subject.move(2, 4)
								enemy.move(2, 3)
								expect( subject.board.get(2, 3) ).to be enemy
								expect( subject.board.get(2, 4) ).to be nil
							end
						end

						context "one turn later" do
							it "opponent piece can no longer execute en passant" do
								enemy = Pawn.new(subject.board, :black, 3, 5)
								enemy2 = Piece.new(subject.board, :black, 8, 8)
								enemy.move(3, 4)
								subject.move(2, 4)
								enemy2.move(7, 8)
								enemy.move(2, 3)

								expect( subject.board.get(3, 4) ).to be enemy
								expect( subject.board.get(2, 4) ).to be subject
							end
						end
					end
				end

				context "blocked path" do
					it "doesn't move" do
						Piece.new(subject.board, :black, 2, 3)
						subject.move(2, 4)
						expect( subject.board.get(2, 2) ).to be subject
						expect( subject.board.get(2, 4) ).to be nil
					end
				end

				context "blocked on target cell" do
					it "doesn't move" do						
						blocker = Piece.new(subject.board, :black, 2, 4)
						subject.move(2, 4)
						expect( subject.board.get(2, 2) ).to be subject
						expect( subject.board.get(2, 4) ).to be blocker
					end
				end		

			end

			context "not from starting position" do
				it "doesn't move" do
					subject.move(2, 3)
					subject.move(2, 5)
					expect( subject.board.get(2, 3) ).to be subject
					expect( subject.board.get(2, 5) ).to be nil
				end
			end
		end		

		context "moving diagonally to a cell adjacent to the cell in front" do
			context "occupied by enemy" do
				it "moves and captures the enemy" do
					Piece.new(subject.board, :black, 3, 3)
					subject.move(3, 3)
					expect( subject.board.get(3, 3) ).to be subject
				end
			end

			context "occupied by friendly" do
				it "doesn't move" do
					ally = Piece.new(subject.board, :white, 3, 3)
					subject.move(3, 3)
					expect( subject.board.get(2, 2) ).to be subject
					expect( subject.board.get(3, 3) ).to be ally
				end
			end

			context "empty cell" do
				context "normal conditions" do
					it "doesn't move" do
						subject.move(3, 3)
						expect( subject.board.get(2, 2) ).to be subject
						expect( subject.board.get(3, 3) ).to be nil
					end
				end

				context "en passant" do
					context "safe" do
						it "moves to the cell and captures the Pawn behind it" do
							enemy = Pawn.new(subject.board, :black, 3, 7)
							subject.move(2, 4)
							subject.move(2, 5)
							enemy.move(3, 5)
							subject.move(3, 6)						
							expect( subject.board.get(3, 6) ).to be subject
							expect( subject.board.get(3, 5) ).to be nil
						end
					end

					context "leaves king open" do
						it "doesn't proceed" do
							subject.move(2, 4)
							subject.move(2, 5)
							Queen.new(subject.board, :black, 8, 5)
							King.new(subject.board, :white, 1, 5)
							enemy = Pawn.new(subject.board, :black, 3, 7)
							enemy.move(3, 5)
							subject.move(3, 6)

							expect( subject.board.get(2, 5) ).to be subject
							expect( subject.board.get(3, 5) ).to be enemy
						end
					end
				end
			end
		end

		context "reaching enemy's first rank" do
			context "coming from the bottom side" do
				context "by capturing" do
					it "gets promoted" do
						Rook.new(subject.board, :black, 3, 8)
						subject.move(2, 4)
						subject.move(2, 5)
						subject.move(2, 6)
						subject.move(2, 7)
						subject.move(3, 8)
						expect( subject.board.get(2, 7) ).to be nil
						expect( subject.board.get(3, 8) ).to be_an_instance_of Queen
					end
				end

				context "moving straight forward" do
					it "gets promoted" do
						subject.move(2, 4)
						subject.move(2, 5)
						subject.move(2, 6)
						subject.move(2, 7)
						subject.move(2, 8)
						expect( subject.board.get(2, 7) ).to be nil
						expect( subject.board.get(2, 8) ).to be_an_instance_of Queen
					end
				end
			end

			context "coming from the bottom side" do
				context "by capturing" do
					it "gets promoted" do
						pawn = Pawn.new(subject.board, :black, 4, 5)
						Rook.new(subject.board, :white, 3, 1)
						pawn.move(4, 4)
						pawn.move(4, 3)
						pawn.move(4, 3)
						pawn.move(4, 2)
						pawn.move(3, 1)
						expect( subject.board.get(4, 2) ).to be nil
						expect( subject.board.get(3, 1) ).to be_an_instance_of Queen
					end
				end

				context "moving straight forward" do
					it "gets promoted" do
						pawn = Pawn.new(subject.board, :black, 4, 5)
						pawn.move(4, 4)
						pawn.move(4, 3)
						pawn.move(4, 3)
						pawn.move(4, 2)
						pawn.move(4, 1)
						expect( subject.board.get(4, 2) ).to be nil
						expect( subject.board.get(4, 1) ).to be_an_instance_of Queen
					end
				end
			end
		end

	end

end