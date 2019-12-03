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
    steps = 0
    start_index::Int = 0
    end_index::Int = 0
    range_step::Int = 0
    all_coordinates = Set{Tuple}()
    all_distances = Dict{String, Int}()

    for (direction, distance) in directions
        if direction == "U" # Up
            start_index = y+1
            end_index = y+distance
            range_step = start_index < end_index ? 1 : -1
            for coordinate_step in range(start_index, end_index, step=range_step)
                new_coordinates = (x, coordinate_step)
                new_coordinates_key = string(new_coordinates[1], ";", new_coordinates[2])
                push!(all_coordinates, new_coordinates)

                steps += 1
                current_value = get(all_distances, new_coordinates_key, Inf)
                all_distances[new_coordinates_key] = current_value < steps ? current_value : steps
            end
            y += distance
        elseif direction == "D" # Down
            start_index = y-1
            end_index = y-distance
            range_step = start_index < end_index ? 1 : -1
            for coordinate_step in range(start_index, end_index, step=range_step)
                new_coordinates = (x, coordinate_step)
                new_coordinates_key = string(new_coordinates[1], ";", new_coordinates[2])
                push!(all_coordinates, new_coordinates)

                steps += 1
                current_value = get(all_distances, new_coordinates_key, Inf)
                all_distances[new_coordinates_key] = current_value < steps ? current_value : steps
            end
            y -= distance
        elseif direction == "L" # Left
            start_index = x-1
            end_index = x-distance
            range_step = start_index < end_index ? 1 : -1
            for coordinate_step in range(start_index, end_index, step=range_step)
                new_coordinates = (coordinate_step, y)
                new_coordinates_key = string(new_coordinates[1], ";", new_coordinates[2])
                push!(all_coordinates, new_coordinates)

                steps += 1
                current_value = get(all_distances, new_coordinates_key, Inf)
                all_distances[new_coordinates_key] = current_value < steps ? current_value : steps
            end
            x -= distance
        else # Right
            start_index = x+1
            end_index = x+distance
            range_step = start_index < end_index ? 1 : -1
            for coordinate_step in range(start_index, end_index, step=range_step)
                new_coordinates = (coordinate_step, y)
                new_coordinates_key = string(new_coordinates[1], ";", new_coordinates[2])
                push!(all_coordinates, new_coordinates)

                steps += 1
                current_value = get(all_distances, new_coordinates_key, Inf)
                all_distances[new_coordinates_key] = current_value < steps ? current_value : steps
            end
            x += distance
        end
    end

    all_coordinates, all_distances
end

function calculate_distances(crosses, distances1, distances2)
    # Convert set to array and calculate Manhattan distance
    map(
        (cross)->distances1[string(cross[1], ";", cross[2])]+distances2[string(cross[1], ";", cross[2])],
        [cross for cross in crosses]
    )
end

function get_min_steps(wires)
    coordinates1, distances1 = build_coordinates(wires[1])
    coordinates2, distances2 = build_coordinates(wires[2])

    crosses = intersect(
        coordinates1,
        coordinates2
    )

    minimum(calculate_distances(crosses, distances1, distances2))
end

function main()
    testCases = [
        ("R8,U5,L5,D3\nU7,R6,D4,L4", 30)
        ("R75,D30,R83,U83,L12,D49,R71,U7,L72\nU62,R66,U55,R34,D71,R55,D58,R83", 610)
        ("R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51\nU98,R91,D20,R16,D67,R40,U7,R15,U6,R7", 410)
    ]

    for (test_lines, expected) in testCases
        lines = split(test_lines, "\n")
        wires = parse_wire.(convert.(String, lines))

        result = get_min_steps(wires)
        println(string(result, " -> ", expected))
    end

    lines = open("input.txt") do file
        readlines(file)
    end
    
    wires = parse_wire.(convert.(String, lines))
    result = get_min_steps(wires)

    println(result)
end
main()
