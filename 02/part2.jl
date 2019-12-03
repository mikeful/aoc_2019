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

function search(original_program)
	for noun in 0:99
		for verb in 0:99
			program = copy(original_program)
			program[2] = noun
			program[3] = verb

			result = compute(program)
			if result == 19690720
				return noun, verb
			end
		end
	end
end

function main()
	line = open("input.txt") do file
		read(file, String)
	end
	println(line)

	original_program = parse.(Int, split(line, ","))
	noun, verb = search(original_program)

	println(100 * noun + verb)
end
main()
