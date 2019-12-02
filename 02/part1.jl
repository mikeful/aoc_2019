function compute(memory)
	counter = 0
	while true
		# Julia Arrays start at index 1 instead of 0
		memory_index = counter + 1

		opcode = memory[memory_index]
		if opcode == 99
			return memory[1]
		end

		number1_index = memory[memory_index + 1] + 1
		number2_index = memory[memory_index + 2] + 1
		destination_index = memory[memory_index + 3] + 1
		number1 = memory[number1_index]
		number2 = memory[number2_index]

		if opcode == 1
			memory[destination_index] = number1 + number2
		elseif opcode == 2
			memory[destination_index] = number1 * number2
		else
			return nothing # Unknown opcode
		end

		counter += 4
	end
end

testCases = [
	([1 9 10 3 2 3 11 0 99 30 40 50], 3500)
	([1 0 0 0 99], 2)
	([2 3 0 3 99], 2)
	([2 4 4 5 99 0], 2)
	([1 1 1 4 99 5 6 0 99], 30)
]
for pair in testCases
	program, expected_first = pair
	println(string(compute(program), " -> ", expected_first))
end

line = open("input.txt") do file
	read(file, String)
end
println(line)

program = parse.(Int, split(line, ","))
program[2] = 12
program[3] = 2

@time result = compute(program)

println(result)
