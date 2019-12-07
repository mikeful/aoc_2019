function parse_line(line)
    splitted = split(line, ")")
    string(splitted[1]), string(splitted[2])
end

function find_root(orbits)
    parents = Set()
    moons = Set()

    for orbit in orbits
        push!(parents, orbit[1])
        push!(moons, orbit[2])
    end

    # TODO Find better way to return only 1 item from set
    for item in setdiff(parents, moons)
        return item
    end
end

function insert_node(node, value, subtree)
    inserted = false

    for (node_name, children) in copy(subtree)
        if node_name == node
            inserted = true
            subtree[node_name][value] = Dict()

            return subtree, inserted
        elseif !isempty(children)
            subtree[node_name], inserted = insert_node(
                node,
                value,
                subtree[node_name]
            )

            if inserted
                return subtree, inserted
            end
        end
    end

    return subtree, inserted
end

function get_tree(orbits)
    root = find_root(orbits)

    remaining_orbits = copy(orbits)
    tree = Dict(root => Dict())

    while length(remaining_orbits) > 0
        new_remaining_orbits = []

        for orbit in copy(remaining_orbits)
             tree, inserted = insert_node(orbit[1], orbit[2], tree)

             if !inserted
                 push!(new_remaining_orbits, orbit)
             end
        end

        remaining_orbits = new_remaining_orbits
    end

    root, tree
end

function get_node_path(node, subtree)
    found = false
    for (node_name, children) in copy(subtree)
        if node_name == node
            return [node_name], true
        elseif !isempty(children)
            subtree_path, found = get_node_path(
                node,
                subtree[node_name]
            )

            if found
                push!(subtree_path, node_name)

                return subtree_path, found
            end
        end
    end

    return subtree, found
end

function calculate_length(path1, path2)
    my_path = setdiff(path1, path2)
    santa_path = setdiff(path2, path1)

    length(my_path) + length(santa_path) - 2
end

function main()
    testCases = [
        ("COM)B\nB)C\nC)D\nD)E\nE)F\nB)G\nG)H\nD)I\nE)J\nJ)K\nK)L\nK)YOU\nI)SAN\n", 4)
        ("COM)B\nB)E\nE)YOU\nB)C\nC)SAN\n", 2)
        ("COM)B\nB)YOU\nB)C\nC)SAN\n", 1)
        ("COM)B\nB)YOU\nB)SAN\n", 0)
    ]
    for (test_line, expected_first) in testCases
        lines = sort(
            convert.(String,
                split(strip(test_line), "\n")
            )
        )
        orbits = parse_line.(lines)
        root, tree = get_tree(orbits)

        path1, _ = get_node_path("YOU", tree[root])
        path2, _ = get_node_path("SAN", tree[root])

        result = calculate_length(path1, path2)

        println(string(result, " -> ", expected_first))
        println()
    end

    lines = open("input.txt") do file
        readlines(file)
    end

    orbits = parse_line.(sort(lines))
    root, tree = get_tree(orbits)

    path1, _ = get_node_path("YOU", tree[root])
    path2, _ = get_node_path("SAN", tree[root])

    result = calculate_length(path1, path2)
    println(result)
end
main()
