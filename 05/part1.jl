function compute(memory, input)
    output = []
    counter = 0
    while true
        # Julia Arrays start at index 1 instead of 0
        instruction_pointer = counter + 1

        command = string(memory[instruction_pointer])
        command_len = length(command)
        if command_len < 2
            opcode = parse(Int, command)
        else
            opcode = parse(Int, command[end-1:end])
        end


        if opcode == 99 # Terminate program
            return memory, output
        end

        if opcode == 1 || opcode == 2
            param1_mode = command_len < 3 ? 0 : parse(Int, command[end-2])
            param2_mode = command_len < 4 ? 0 : parse(Int, command[end-3])

            destination_address = memory[instruction_pointer + 3] + 1

            if param1_mode == 1
                param1 = memory[instruction_pointer + 1]
            else
                param1_address = memory[instruction_pointer + 1] + 1
                param1 = memory[param1_address]
            end

            if param2_mode == 1
                param2 = memory[instruction_pointer + 2]
            else
                param2_value = memory[instruction_pointer + 2] + 1
                param2 = memory[param2_value]
            end

            if opcode == 1 # Add
                memory[destination_address] = param1 + param2
            else # Multiply
                memory[destination_address] = param1 * param2
            end

            counter += 4
        elseif opcode == 3 # Input
            destination_address = memory[instruction_pointer + 1] + 1

            if length(input) > 0
                value = popfirst!(input)
                memory[destination_address] = value
            end
            # Error on empty input?

            counter += 2
        elseif opcode == 4 # Output
            output_address = memory[instruction_pointer + 1] + 1
            output_value = memory[output_address]
            
            println(output_value)
            push!(output, output_value)

            counter += 2
        else # Unknown opcode
            println("Unknown opcode=", opcode)
            return memory, nothing
        end
    end
end

function main()
    testCases = [
        ([3 0 4 0 99], [1], 1)
        ([3 0 1002 0 5 0 4 0 99], [2], 10)
        ([1101 100 -1 4 0], [], [])
    ]
    for (program, input, expected_first) in testCases
        println(program, " with input ", input)
        memory, output = compute(program, input)
        println(string(output, " -> ", expected_first))
        println()
    end

    line = open("input.txt") do file
        read(file, String)
    end
    println(line)

    program = parse.(Int, split(line, ","))
    result = compute(program, [1])

    println(result)
end
main()
