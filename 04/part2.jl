numpairs = Set([string(x, x) for x in 0:9])
droppairs = [string(num, num, num) for num in 0:9]

function is_valid(code)
    length(code) != 6 ? (return false) : nothing

    (join(sort(collect(code)))) != code ? (return false) : nothing

    found_drop_pairs = []
    for pair in droppairs
        if occursin(pair, code)
            push!(found_drop_pairs, pair[1:2])
        end
    end

    found_drop_set = Set(found_drop_pairs)

    found_pairs = []
    for pair in [cross for cross in setdiff(numpairs, found_drop_set)]
        if occursin(pair, code)
            push!(found_pairs, pair)
        end
    end
    length(found_pairs) == 0 ? (return false) : nothing

    true
end

function main()
    testCases = [
        ("111111", false)
        ("112233", true)
        ("123444", false)
        ("111122", true)
        ("122233", true)
        ("222333", false)
        ("222233", true)
        ("222223", false)
    ]

    for (test_code, expected) in testCases
        result = is_valid(test_code)
        println(string(test_code, " ", result, " -> ", expected))
    end

    input = 278384:824795

    result = []
    for x in input
        if is_valid(string(x))
            push!(result, string(x))
        end
    end

    println(length(result))
end
main()
