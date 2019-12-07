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

        param1_mode = command_len < 3 ? 0 : parse(Int, command[end-2])
        param2_mode = command_len < 4 ? 0 : parse(Int, command[end-3])

        if opcode == 99 # Terminate program
            return memory, output
        end

        if opcode == 1 || opcode == 2
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
            if param1_mode == 1
                output_value = memory[instruction_pointer + 1]
            else
                param1_address = memory[instruction_pointer + 1] + 1
                output_value = memory[param1_address]
            end
            
            println(output_value)
            push!(output, output_value)

            counter += 2
        elseif opcode == 5 # jump-if-true
            if param1_mode == 1
                check_value = memory[instruction_pointer + 1]
            else
                param1_address = memory[instruction_pointer + 1] + 1
                check_value = memory[param1_address]
            end

            if param2_mode == 1
                jump_destination = memory[instruction_pointer + 2]
            else
                param2_value = memory[instruction_pointer + 2] + 1
                jump_destination = memory[param2_value]
            end

            if check_value != 0
                counter = jump_destination 
            else
                counter += 3
            end
        elseif opcode == 6 # jump-if-false
            if param1_mode == 1
                check_value = memory[instruction_pointer + 1]
            else
                param1_address = memory[instruction_pointer + 1] + 1
                check_value = memory[param1_address]
            end

            if param2_mode == 1
                jump_destination = memory[instruction_pointer + 2]
            else
                param2_value = memory[instruction_pointer + 2] + 1
                jump_destination = memory[param2_value]
            end

            if check_value == 0
                counter = jump_destination 
            else
                counter += 3
            end
        elseif opcode == 7 # less than
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

            if param1 < param2
                memory[destination_address] = 1
            else
                memory[destination_address] = 0
            end

            counter += 4
        elseif opcode == 8 # equals
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

            if param1 == param2
                memory[destination_address] = 1
            else
                memory[destination_address] = 0
            end

            counter += 4
        else # Unknown opcode
            println("Unknown opcode=", opcode)
            return memory, nothing
        end
    end
end

function main()
    testCases = [
        # pos, eq
        ([3 9 8 9 10 9 4 9 99 -1 8], [8], 1)
        ([3 9 8 9 10 9 4 9 99 -1 8], [10], 0)
        # pos, less
        ([3 9 7 9 10 9 4 9 99 -1 8], [7], 1)
        ([3 9 7 9 10 9 4 9 99 -1 8], [9], 0)
        # imm, eq
        ([3 3 1108 -1 8 3 4 3 99], [8], 1)
        ([3 3 1108 -1 8 3 4 3 99], [10], 0)
        # imm, less
        ([3 3 1107 -1 8 3 4 3 99], [7], 1)
        ([3 3 1107 -1 8 3 4 3 99], [9], 0)
        # pos, eq zero
        ([3 12 6 12 15 1 13 14 13 4 13 99 -1 0 1 9], [0], 0)
        ([3 12 6 12 15 1 13 14 13 4 13 99 -1 0 1 9], [5], 1)
        # imm, eq zero
        ([3 3 1105 -1 9 1101 0 0 12 4 12 99 1], [0], 0)
        ([3 3 1105 -1 9 1101 0 0 12 4 12 99 1], [5], 1)
        # eq, less, greater
        ([3 21 1008 21 8 20 1005 20 22 107 8 21 20 1006 20 31 1106 0 36 98 0 0 1002 21 125 20 4 20 1105 1 46 104 999 1105 1 46 1101 1000 1 20 4 20 1105 1 46 98 99], [5], 999)
        ([3 21 1008 21 8 20 1005 20 22 107 8 21 20 1006 20 31 1106 0 36 98 0 0 1002 21 125 20 4 20 1105 1 46 104 999 1105 1 46 1101 1000 1 20 4 20 1105 1 46 98 99], [8], 1000)
        ([3 21 1008 21 8 20 1005 20 22 107 8 21 20 1006 20 31 1106 0 36 98 0 0 1002 21 125 20 4 20 1105 1 46 104 999 1105 1 46 1101 1000 1 20 4 20 1105 1 46 98 99], [10], 1001)

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
    result = compute(program, [5])

    println(result)
end
main()
