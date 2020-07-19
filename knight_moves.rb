require 'pry'

class Square #node
    attr_accessor :data, :children, :parent
    
    @@square_count = 0
    def initialize(board_position)
        @data = board_position
        @parent = nil
        @children = []
        @@square_count += 1
    end

    def self.show_number_of_squares
        @@square_count
    end
end

class Knight #tree
    attr_accessor :adjacency_list, :root

    def initialize(starting_position = [0, 0], destination)
        @root = Square.new(starting_position)
        @destination = destination
        @adjacency_list = []
    end

    ### FIND THE BASE TO STOP THE RECURSION AND FINISH THE TREE ###
    def create_moves_tree(root = @root)
        root.children = move_options(root)
        @adjacency_list << root
        @adjacency_list << root.children
        root.children.each do |child|
            child.parent = root
            elsif child.data == @destination
                return
            else
                create_moves_tree(child)
            end
        end
    end

    def move_options(root)
        moves = [
            move_forward_long_right(root), move_forward_long_left(root), move_forward_short_right(root), move_forward_short_left(root),
            move_back_long_right(root), move_back_long_left(root), move_back_short_right(root), move_back_short_left(root)
        ]
        list = []
        moves.each do |move|
            list << move
        end
        list.select! { |position| (0..7).include?(position[0]) && (0..7).include?(position[1]) }
        list.map! { |element| Square.new(element) }
        return list
    end

    def move_forward_long_right(root)
        square = [root.data[0] + 2, root.data[1] + 1]
    end
    
    def move_forward_long_left(root)
        square = [root.data[0] + 2, root.data[1] - 1]
    end

    def move_forward_short_right(root)
        square = [root.data[0] + 1, root.data[1] + 2]
    end

    def move_forward_short_left(root)
        square = [root.data[0] + 1, root.data[1] - 2]
    end

    def move_back_long_right(root)
        square = [root.data[0] - 2, root.data[1] + 1]
    end

    def move_back_long_left(root)
        square = [root.data[0] - 2, root.data[1] - 1]
    end

    def move_back_short_right(root)
        square = [root.data[0] - 1, root.data[1] + 2]
    end 

    def move_back_short_left(root)
        square = [root.data[0] - 1, root.data[1] - 2]
    end
end

# class Board #tree
#     attr_accessor :root

#     def initalize(start)
#         @root = build_board
#     end

# end

# k = Knight.new
# k.knight_moves([3,3], [4,3])

