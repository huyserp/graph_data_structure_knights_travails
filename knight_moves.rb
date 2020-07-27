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
    attr_accessor :distance, :previous_square
    attr_reader :data, :adjacent_squares

    @@number_of_squares = 0
    
    def initialize(data)
        @data = data 
        @adjacent_squares = []
        @distance = 0
        @previous_square = nil
        @@number_of_squares += 1
    end

    def add_edge(adjacent_square)
        @adjacent_squares << adjacent_square
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
        return list
    end

    def self.number_of_squares
        puts @@number_of_squares
    end

    def to_s
        puts "data: #{self.data}, adjacent_squares: #{self.adjacent_squares.map { |x| x.data} }, distance: #{self.distance}"
    end

end

class ChessBoardGraph
    attr_reader :squares_list

    def initialize
        @squares_list = {}
        build_graph
    end

    def add_square(square) #argument is node
        @squares_list[square.data] = square #key is data for node, value is the node itself
    end

    def build_graph
        # list of all data coordinates on a chessboard
        data_list = []
        for x in 0..7 do 
            for y in 0..7 do
                data_list << [x, y]
            end
        end
        # make Squares of each data coordinate and add them to the squares_list (Adjacency list)
        data_list.each { |data| add_square(Square.new(data)) }

        # populate each Square's adjacent_squares list with the respective legal chess moves available for each
        @squares_list.each do |key, value|
            options = value.move_options(key)

            options.each do |move|
                value.add_edge(@squares_list[move])
            end
        end
        @squares_list
    end

    def squares_list_to_s #easy to read adjacency list
        @squares_list.values.each do |square|
            puts square.to_s
        end
    end

    def knight_moves(start_data, target_data)
        #clear each Square's @distance and previous_square before each search, as the starting and ending points can change
        @squares_list.values.each do |x| 
            x.distance = nil 
            x.previous_square = nil
        end
    
        start = @squares_list[start_data]
        target = @squares_list[target_data]

        destination = nil
        start.distance = 0
        
        visited = []
        to_visit = []

        visited << start
        to_visit << start

        while !to_visit.empty?
            current = to_visit.shift #remove and visit the first node in the queue
            if current == target
                destination = current
                break
            else
            #if it's not the right node, look at its adjacent nodes and add each one to the queue & visited
                current.adjacent_squares.each do |square|
                    if visited.include?(square)
                        next
                    else
                        visited << square
                        to_visit << square

                        if current == start
                            square.distance = 1
                            square.previous_square = current
                        else
                            unless square.distance != nil && square.previous_square != nil #unless the square has already been traversed
                                square.distance = current.distance + 1
                                square.previous_square = current
                            end
                        end
                    end
                end
            end
        end
        # Trace back the path taken
        path = []
        square_before = destination
        until square_before.previous_square == nil
            path.unshift(square_before.data)
            square_before = square_before.previous_square
        end
        # Print out results
        path.unshift(square_before.data)
        puts "You made it in #{destination.distance} moves! Here is your path:"
        path.each { |squares| puts squares.to_s }
    end
end

graph = ChessBoardGraph.new
graph.knight_moves([3,3],[4,3])
graph.knight_moves([0,0],[3,3])
graph.knight_moves([3,3],[0,0])
graph.knight_moves([0,0],[7,7])
graph.knight_moves([0,0],[2,1])
