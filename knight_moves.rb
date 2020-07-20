require 'pry'

class Square #node
    attr_accessor :data, :children, :parents
    
    @@square_count = 0
    def initialize(board_position)
        @data = board_position
        @parents = []
        @children = []
        @@square_count += 1
    end

    def self.number_of_squares
        @@square_count
    end
end

class Knight #tree
    attr_accessor :adjacency_list, :root, :poi

    def initialize(starting_position = [0, 0], destination)
        @root = Square.new(starting_position)
        @destination = destination
        @all_squares_data = [] #List to maintain no repeats
        @poi = nil #Point Of Interest
    end


    def create_moves_tree(root = @root)
        @all_squares_data << root.data #add the current root.data to the list of total move options, this is to manage repeats
        root.children = move_options(root) #set all legal moves from the given root as child nodes.

        #loop through the given children of the root, set the given root as each childs parent to allow travel back up the tree
        root.children.each do |child|
            child.parents << root
            @poi = child if child.data == @destination
            if @all_squares_data.include?(child.data)
                next #if the child is in this list, we've aready made a subtree for it (as you can get to a square from more than one root location)
            else
                create_moves_tree(child)
            end
        end
    end
    
    def display_path
        moves = make_path
        moves << @poi.data #tack your target square on the end
        puts "You made it in #{moves.length - 1} moves! Here's your path:"
        moves.each do |square|
            puts square.to_s
        end
    end

    def make_path(position = @poi, path = [])
        return if position.parents.include?(@root)
        path.unshift(position.parents.data)
        position = position.parents
        make_path(position, path)
        return path
    end
    
    def move_options(root)
        moves = [
            move_forward_long_right(root), move_forward_long_left(root), move_forward_short_right(root), move_forward_short_left(root),
            move_back_long_right(root), move_back_long_left(root), move_back_short_right(root), move_back_short_left(root)
        ]
        list = []
        #generate all possible moves from the given location of the Knight (root)
        moves.each do |move|
            list << move
        end
        #remove any moves generated that take the knight off the chess board
        list.select! { |position| (0..7).include?(position[0]) && (0..7).include?(position[1]) }
        #make Squares (nodes) for all locations that can be moved too from the root location, set the coordinate as its data attribute
        list.map! { |element| Square.new(element) }
        return list
    end

    #All possible legal moves for a knight chess piece.  These can include moves off the board - off board
    #moves are removed before creating the node square in #move_options
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

def knight_moves(start, finish)
    k = Knight.new(start, finish)
    k.create_moves_tree
    k.display_path
end

# knight_moves([0,0], [3,3])
# knight_moves([3,3], [0,0])
# knight_moves([3,3], [4,3])
