using Distributed

addprocs()

@everywhere function compute(memory)
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

@everywhere function search(program, pair)
	noun, verb = pair
	program[2] = noun
	program[3] = verb

	result = compute(program)
	if result == 19690720
		return noun, verb
	else
		return nothing
	end
end

# https://michaellindon.github.io/programming/partial-application-functions-julia/
function partial(f, a...)
	(b...) -> f(a..., b...)
end

function main()
	line = open("input.txt") do file
		read(file, String)
	end
	println(line)

	original_program = parse.(Int, split(line, ","))
	partial_search = partial(search, original_program)
	word_pairs = [(noun, verb) for noun in 0:99, verb in 0:99]

	@time result = pmap(partial_search, word_pairs)

	noun, verb = filter(value -> value != nothing, result)[1]
	println(100 * noun + verb)
end
main()
