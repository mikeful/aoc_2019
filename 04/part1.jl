numpairs = Set([string(x, x) for x in 0:9])

function is_valid(code)
    length(code) != 6 ? (return false) : nothing

    !pairfound(code) ? (return false) : nothing
    
    (join(sort(collect(code)))) != code ? (return false) : nothing

    true
end

function pairfound(code)
    for pair in numpairs
        if occursin(pair, code)
            return true
        end
    end
    false
end

function main()
    testCases = [
        ("111111", true)
        ("223450", false)
        ("123789", false)
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
