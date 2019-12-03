function parse_direction(direction)
    direction[1:1], parse(Int, direction[2:end])
end

function parse_wire(wire)
    map(
        parse_direction,
        convert.(String, split(wire, ","))
    )
end

function build_coordinates(directions)
    x = 0
    y = 0
    all_coordinates = Set{Tuple}()

    for (direction, distance) in directions
        if direction == "U" # Up
            for coordinate_step in x+1:x+distance
                push!(all_coordinates, (y, coordinate_step))
            end
            x += distance
        elseif direction == "D" # Down
            for coordinate_step in x-distance:x-1
                push!(all_coordinates, (y, coordinate_step))
            end
            x -= distance
        elseif direction == "L" # Left
            for coordinate_step in y-distance:y-1
                push!(all_coordinates, (coordinate_step, x))
            end
            y -= distance
        else # Right
            for coordinate_step in y+1:y+distance
                push!(all_coordinates, (coordinate_step, x))
            end
            y += distance
        end
    end

    all_coordinates
end

function calculate_distances(crosses)
    # Convert set to array and calculate Manhattan distance
    map(
        (cross)->abs(cross[1])+abs(cross[2]),
        [cross for cross in crosses]
    )
end

function get_min_distance(wires)
    crosses = intersect(
        build_coordinates(wires[1]),
        build_coordinates(wires[2])
    )

    minimum(calculate_distances(crosses))
end

function main()
    testCases = [
        ("R8,U5,L5,D3\nU7,R6,D4,L4", 6)
        ("R75,D30,R83,U83,L12,D49,R71,U7,L72\nU62,R66,U55,R34,D71,R55,D58,R83", 159)
        ("R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51\nU98,R91,D20,R16,D67,R40,U7,R15,U6,R7", 135)
    ]

    for (test_lines, expected) in testCases
        lines = split(test_lines, "\n")
        wires = parse_wire.(convert.(String, lines))

        result = get_min_distance(wires)
        println(string(result, " -> ", expected))
    end

    lines = open("input.txt") do file
        readlines(file)
    end
    
    wires = parse_wire.(convert.(String, lines))
    result = get_min_distance(wires)

    println(result)
end
main()
