function calculate_fuel(mass)
	fuel_cost = Int(floor(mass / 3) - 2)
	if fuel_cost > 0
		return fuel_cost + calculate_fuel(fuel_cost)
	else
		return 0
	end
end

testCases = [
	(14, 2)
	(1969, 966)
	(100756, 50346)
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
println(
	sum(
		calculate_fuel.(
			parse.(
				Int, lines
			)
		)
	)
)
