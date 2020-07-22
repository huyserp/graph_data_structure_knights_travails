require 'pry'
module KnightMoveable
    #All possible legal moves for a knight chess piece.  These can include moves off the board - off board
    #moves are removed before creating the node square in #move_options
    def move_forward_long_right(current)
        square = [current[0] + 2, current[1] + 1]
    end
    
    def move_forward_long_left(current)
        square = [current[0] + 2, current[1] - 1]
    end

    def move_forward_short_right(current)
        square = [current[0] + 1, current[1] + 2]
    end

    def move_forward_short_left(current)
        square = [current[0] + 1, current[1] - 2]
    end

    def move_back_long_right(current)
        square = [current[0] - 2, current[1] + 1]
    end

    def move_back_long_left(current)
        square = [current[0] - 2, current[1] - 1]
    end

    def move_back_short_right(current)
        square = [current[0] - 1, current[1] + 2]
    end 

    def move_back_short_left(current)
        square = [current[0] - 1, current[1] - 2]
    end
end

class Square #node
    include KnightMoveable
    attr_accessor :distance
    attr_reader :data, :adjacent_squares
    
    def initialize(data)
        @data = data 
        @adjacent_squares = []
        @distance = 0
    end

    def add_adjacent_squares
        @adjacent_squares = move_options(self.data)
    end

    def move_options(root)
        moves = [
            move_forward_long_right(root), move_forward_long_left(root), move_forward_short_right(root), move_forward_short_left(root),
            move_back_long_right(root), move_back_long_left(root), move_back_short_right(root), move_back_short_left(root)
        ]
        list = []
        #generate all possible moves from the given location of the Knight
        moves.each do |move|
            list << move
        end
        #remove any moves generated that take the knight off the chess board
        list.select! { |position| (0..7).include?(position[0]) && (0..7).include?(position[1]) }
        #make Squares (nodes) for all locations that can be moved too from the root location, set the coordinate as its data attribute
        list.map! { |element| Square.new(element) }
        return list
    end
end

class ChessBoardGraph
    attr_reader :squares_list

    def initialize
        @squares_list = {}
    end

    def add_square(square) #argument is node
        @squares_list[square.data] = square #key is data for node, value for key is the node itself
    end

    def build_graph(root)
        return if @squares_list.has_key?(root.data)
        add_square(root)
        
        root.adjacent_squares.each do |adjacent|
            adjacent.add_adjacent_squares
            build_graph(adjacent)
        end
    end

    def find(data)
        return @squares_list[data]
    end

    def level_order_search(starting_square_data, target_square_data)
        root = @squares_list[starting_square_data]
        visited = []
        to_visit = []

        visited << root
        to_visit << root

        while !to_visit.empty?
            current = to_visit.shift #remove and visit the first node in the queue
            break if current.data == target_square_data

            #if it's not the right node, look at its adjacent nodes and add each one to the queue & visited
            current.adjacent_squares.each do |square|
                if visited.map { |x| x.data}.include?(square)
                    next
                else
                    visited << square
                    to_visit << square

                    if current == root
                        square.distance = 1
                    else
                        unless square.distance != 0 #unless the distance has already been assigned
                            square.distance = current.distance + 1
                        end
                    end
                end
            end
        end
        puts current.data.to_s
        puts current.distance
    end

end

start = Square.new([0,0])
start.add_adjacent_squares

graph = ChessBoardGraph.new
graph.build_graph(start)
graph.level_order_search([3,3],[4,3])


    


























# class Square #node
#     attr_accessor :data, :children, :parents
    
#     @@square_count = 0
#     def initialize(board_position)
#         @data = board_position
#         @parents = []
#         @children = []
#         @@square_count += 1
#     end

#     def self.number_of_squares
#         @@square_count
#     end
# end

# class Knight #tree
#     attr_accessor :adjacency_list, :root, :poi

#     def initialize(starting_position = [0, 0], destination)
#         @root = Square.new(starting_position)
#         @destination = destination
#         @all_squares_data = [] #List to maintain no repeats
#         @poi = nil #Point Of Interest
#     end


#     def create_moves_tree(root = @root)
#         @all_squares_data << root.data #add the current root.data to the list of total move options, this is to manage repeats
#         root.children = move_options(root) #set all legal moves from the given root as child nodes.

#         #loop through the given children of the root, set the given root as each childs parent to allow travel back up the tree
#         root.children.each do |child|
#             child.parents << root
#             @poi = child if child.data == @destination
#             if @all_squares_data.include?(child.data)
#                 next #if the child is in this list, we've aready made a subtree for it (as you can get to a square from more than one root location)
#             else
#                 create_moves_tree(child)
#             end
#         end
#     end
    
#     def display_path
#         moves = make_path
#         moves << @poi.data #tack your target square on the end
#         puts "You made it in #{moves.length - 1} moves! Here's your path:"
#         moves.each do |square|
#             puts square.to_s
#         end
#     end

#     def make_path(position = @poi, path = [])
#         return if position.parents.include?(@root)
#         path.unshift(position.parents.data)
#         position = position.parents
#         make_path(position, path)
#         return path
#     end
    
#     def move_options(root)
#         moves = [
#             move_forward_long_right(root), move_forward_long_left(root), move_forward_short_right(root), move_forward_short_left(root),
#             move_back_long_right(root), move_back_long_left(root), move_back_short_right(root), move_back_short_left(root)
#         ]
#         list = []
#         #generate all possible moves from the given location of the Knight (root)
#         moves.each do |move|
#             list << move
#         end
#         #remove any moves generated that take the knight off the chess board
#         list.select! { |position| (0..7).include?(position[0]) && (0..7).include?(position[1]) }
#         #make Squares (nodes) for all locations that can be moved too from the root location, set the coordinate as its data attribute
#         list.map! { |element| Square.new(element) }
#         return list
#     end

#     #All possible legal moves for a knight chess piece.  These can include moves off the board - off board
#     #moves are removed before creating the node square in #move_options
#     def move_forward_long_right(root)
#         square = [root.data[0] + 2, root.data[1] + 1]
#     end
    
#     def move_forward_long_left(root)
#         square = [root.data[0] + 2, root.data[1] - 1]
#     end

#     def move_forward_short_right(root)
#         square = [root.data[0] + 1, root.data[1] + 2]
#     end

#     def move_forward_short_left(root)
#         square = [root.data[0] + 1, root.data[1] - 2]
#     end

#     def move_back_long_right(root)
#         square = [root.data[0] - 2, root.data[1] + 1]
#     end

#     def move_back_long_left(root)
#         square = [root.data[0] - 2, root.data[1] - 1]
#     end

#     def move_back_short_right(root)
#         square = [root.data[0] - 1, root.data[1] + 2]
#     end 

#     def move_back_short_left(root)
#         square = [root.data[0] - 1, root.data[1] - 2]
#     end
# end

# def knight_moves(start, finish)
#     k = Knight.new(start, finish)
#     k.create_moves_tree
#     k.display_path
# end

# knight_moves([0,0], [3,3])
# knight_moves([3,3], [0,0])
# knight_moves([3,3], [4,3])
