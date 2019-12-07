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

function count_paths(node, orbit_subtree, parent_pathcount, level)
    pathcount = parent_pathcount

    if !isempty(orbit_subtree)
        for (node_name, children) in orbit_subtree
            sub_pathcount = count_paths(
                node_name,
                orbit_subtree[node_name],
                parent_pathcount + 1,
                level + 1
            )

            pathcount += sub_pathcount
        end
    end

    return pathcount
end

function main()
    testCases = [
        ("COM)B\nB)C\nC)D\nD)E\nE)F\nB)G\nG)H\nD)I\nE)J\nJ)K\nK)L\n", 42)
        ("COM)B\nB)C\nC)D\nB)G\nG)H\n", 11)
        ("COM)B\nB)C\nC)D\nB)G\n", 8)
        ("COM)B\nB)C\nB)D\nB)E\n", 7)
        ("COM)B\nB)C\nB)D\n", 5)
    ]
    for (test_line, expected_first) in testCases
        lines = sort(
            convert.(String,
                split(strip(test_line), "\n")
            )
        )
        orbits = parse_line.(lines)
        root, tree = get_tree(orbits)
        result = count_paths(root, tree[root], 0, 0)

        println(string(result, " -> ", expected_first))
        println()
    end

    lines = open("input.txt") do file
        readlines(file)
    end

    orbits = parse_line.(sort(lines))
    root, tree = get_tree(orbits)
    result = count_paths(root, tree[root], 0, 0)

    println(result)
end
main()
