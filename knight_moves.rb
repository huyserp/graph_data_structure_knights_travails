class Knight
    attr_accessor :root, :destination

    def initialize(start_position = [0, 0])
        @root = start_position
        @destination = []
        @moves = [
            move_forward_long_right, move_forward_long_left, move_forward_short_right, move_forward_short_left,
            move_back_long_right, move_back_long_left, move_back_short_right, move_back_short_left
        ]
    end

    def adjacency_list(root = @root)
        list = []

        @moves.each do |move|
            unless move[0] < 0 || move[0] > 7 || move[1] < 0 || move[1] > 7
                list << Square.new(move)
            end
        end
    end

    def move_forward_long_right(root = @root)
        root = [root[0] + 2, root[1] + 1]
    end
    
    def move_forward_long_left(root = @root)
        root = [root[0] + 2, root[1] - 1]
    end

    def move_forward_short_right(root = @root)
        root = [root[0] + 1, root[1] + 2]
    end

    def move_forward_short_left(root = @root)
        root = [root[0] + 1, root[1] - 2]
    end

    def move_back_long_right(root = @root)
        root = [root[0] - 2, root[1] + 1]
    end

    def move_back_long_left(root = @root)
        root = [root[0] - 2, root[1] - 1]
    end

    def move_back_short_right(root = @root)
        root = [root[0] - 1, root[1] + 2]
    end 

    def move_back_short_left(root = @root)
        root = [root[0] - 1, root[1] - 2]
    end
end

class Square #node
    attr_accessor :data
    
    def initialize(board_position)
        @data = board_position
    end
end

# class Board
#     def initalize
#         @board = Array.new(8, Array.new(8, ""))
#         self.populate_board
#     end

#     def populate_board
#         @board.map! do |line|
#             row = 0


#     end
# end



