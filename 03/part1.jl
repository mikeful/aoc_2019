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
    coordinates = [0 0]
    all_coordinates = Set{Tuple}()

    for (direction, distance) in directions
        if direction == "U"
            # Up
            for coordinate_step in coordinates[2]+1:coordinates[2]+distance
                push!(all_coordinates, (coordinates[1], coordinate_step))
            end
            coordinates[2] += distance
        elseif direction == "D"
            # Down
            for coordinate_step in coordinates[2]-distance:coordinates[2]-1
                push!(all_coordinates, (coordinates[1], coordinate_step))
            end
            coordinates[2] -= distance
        elseif direction == "L"
            # Left
            for coordinate_step in coordinates[1]-distance:coordinates[1]-1
                push!(all_coordinates, (coordinate_step, coordinates[2]))
            end
            coordinates[1] -= distance
        else
            # Right
            for coordinate_step in coordinates[1]+1:coordinates[1]+distance
                push!(all_coordinates, (coordinate_step, coordinates[2]))
            end
            coordinates[1] += distance
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
