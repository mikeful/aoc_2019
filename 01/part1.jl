function calculate_fuel(mass)
	Int(floor(mass / 3) - 2)
end

function main()
	testCases = [
		(12, 2)
		(14, 2)
		(1969, 654)
		(100756, 33583)
	]
	for pair in testCases
		mass, expected_fuelcost = pair
		println(string(calculate_fuel(mass), " -> ", expected_fuelcost))
	end

	lines = open("part1.txt") do file
		readlines(file)
	end
	println(lines)

	# https://docs.julialang.org/en/v1/base/arrays/index.html#Base.Broadcast.broadcast
	result = sum(
		calculate_fuel.(
			parse.(
				Int, lines
			)
		)
	)
	println(result)
end
main()
