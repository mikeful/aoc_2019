numpairs = Set([string(x, x) for x in 0:9])
droppairs = Set([string(x, x) for x in 0:9])

function is_valid(code)
    length(code) != 6 ? (return false) : nothing

    (join(sort(collect(code)))) != code ? (return false) : nothing

    found_pairs = []
    for pair in numpairs
        if occursin(pair, code)
            push!(found_pairs, pair)
        end
    end
    length(found_pairs) == 0 ? (return false) : nothing

    # TODO

    true
end

function main()
    testCases = [
        ("112233", true)
        ("123444", false)
        ("111122", true)
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
