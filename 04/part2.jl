numpairs = Set([string(x, x) for x in 0:9])
droppairs = [string(num, num, num) for num in 0:9]

function is_valid(code)
    if length(code) != 6
        return false
    end

    if (join(sort(collect(code)))) != code
        return false
    end

    found_drop_set = Set()
    for pair in droppairs
        if occursin(pair, code)
            push!(found_drop_set, pair[1:2])
        end
    end

    found_pairs = 0
    for pair in setdiff(numpairs, found_drop_set)
        if occursin(pair, code)
            found_pairs += 1
        end
    end

    return found_pairs == 0 ? false : true
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

    result = 0
    for x in input
        if is_valid(string(x))
            result += 1
        end
    end

    println(result)
end
main()
