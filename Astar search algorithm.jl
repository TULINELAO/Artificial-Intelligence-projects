### A Pluto.jl notebook ###
# v0.18.4

using Markdown
using InteractiveUtils

# ╔═╡ 9bca0d70-c67b-11ec-107f-c1c951eeb197
begin
	using Markdown
	using DataStructures
using AStarSearch
	
end

# ╔═╡ 2f87c95c-d054-43c1-b888-87ff587a6f97
struct  office_state
	hasAgent::Bool
	hasParcel::Bool
end

# ╔═╡ d2c78ce0-43c5-46d1-922f-6f8b4a96453f
md"# Actions and costs"

# ╔═╡ 2117e527-e709-4449-a540-2c0aa1f07b6c
struct action
	me = (2)
	mw = (2)
	mu = (1)
	md = (1)
	co = (5)
	
end 

# ╔═╡ 1780448f-95ae-4a62-9752-09043a7b5660
struct building
	numberOfStories:: Int64
numberOfOfficesPerFloor::Int64
end
function building ()
	(3)
end 

# ╔═╡ b6db9e7a-97b1-4db5-8a94-6215ea0ead32
grid_storey = [1111; 1111]

# ╔═╡ 4909ebd7-47f2-4902-a5b5-de2d6ed140fc


# ╔═╡ d5c03262-b344-4f77-84c3-2739b8f0e4c7
struct Parcels_per_office
	
numberOfParcelInOffices :: Dict{String, Int64}("a" => 1, "b" => 2, "c" => 1,"d "=> 3 )
end

# ╔═╡ db7d2e72-874d-470d-9e68-8b6aaf55b8cd
struct State
	
	five:: floor_office, six:: floor_office, seven:: floor_office,              eight:: floor_office, nine::floor_office,ten:: floor_office,
	eleven:: floor_office,twelve:: floor_office,thirteen:: floor_office
	
	
end

# ╔═╡ 3a9c00f5-328a-4228-aaa5-abacdca22fac
struct Node
	state::State
	parent::Union{Nothing , Node}
	action::Union{Nothing, Action}
end

# ╔═╡ add08b1f-ea70-4bad-a517-4efbe2a83586
struct occupied_offices
	company =  [0 1 1 0 0;
                0 1 0 0 1;
                0 1 0 0 0]
                
end

# ╔═╡ b5b28681-04fa-45cc-abda-5314686bad70
md"# Define the transitions "

# ╔═╡ 552b2660-f0bd-42b5-86a8-1af71de08098
function get_transitions(node::Node)
	state = node.state
	transitions = Dict{Action, Node}()
	
	if state.five.hasAgent
	if state.five.hasParcel
		transitions[co] = Node(
			State(floor_office(true,false), state.six, state.seven)),
			node,
			co
		)
	end

		transitions[mw] = Node(
		State(floor_office(false, state.five.hasPeacel),office_floor(true, state.sixhasParcel),state.seven)),
		node,
		mw
		)
	

     elseif state.six.hasAgent
	   if state.six.hasParcel
		transitions[co] = Node(
		State(state.five,floor_office(true, false), state.seven)),
		node,
		co
		)
	end
transitions[mu] = Node(State(  
	floor_office(true, state.five.hasParcel),
	floor_office(true, state.six.hasParcel),
	state.seven)),
	node,
	mu
)
transitions[me] = Node(State( 
	state.five,
	floor_office(true, state.six.hasParcel),
	floor_office(true, state.seven.hasParcel),
	node,
	me
)
	elseif state.seven.hasAgent
	 if    state.seven.hasParcel
		 transitions[co] = Node(State(
			 state.five,
			 state.six,
			 floor_office(true , false)),
			 node,
			 co
	 )
	 end 
	transitions[md] = Node(State(
	state.five,
	floor_office(true, state.six.hasParcel)
	floor_office(true, state.seven.hasParcel)),
	node,
	md
	
	)

end
return transitions
end
	

# ╔═╡ 598cd970-d053-46e8-91cd-97695d9b8818
md"# Goal states"

# ╔═╡ a307cf6d-d1a3-463f-915c-527c07102431
function is_goal(state::State)
	return !state.five.hasParcel && !state.six.hasParcel && !state.seven.hasParcel
end

# ╔═╡ ac9eb5d8-dd35-4b34-a7e9-8ce9dfc0fb22
md"### define Path"

# ╔═╡ f6dfb722-f093-4a27-bd2a-0317c2f4b72c
function get_path(node::Node)
	path= [node]
	while !isnothing(node.parent)
node = node.parent
		pushfirst!(path, node)
	end
	return path
end

# ╔═╡ ff625ef2-e2f1-4753-99bf-76933b0bb8ec
md"### function to explore solutions"

# ╔═╡ d4650231-abe1-4cd6-a300-fd71f7758f11
function solution(node::Node, explored::Array)
path = get_path(node)
	actions = []
	for node in path
		if !is nothing(node.action)
		end
	end

cost = length(actions)
	return cost,"Found $(length(actions)) step solution in $(length(explored))
	steps: $(join(actions, "->"))"
end

# ╔═╡ 69782c41-da9f-45d8-93af-66c213a50836
md"### Heuriistic function"

# ╔═╡ d7b632a4-786d-42b2-9314-5b1a6c436bb3
function a_star_cost(node::Node)
	return calculate_path_cost(node) + heuristic(node)
	
end

# ╔═╡ 69869a66-e827-48f5-b027-18cba7f69841
md"### Start the A*Search algorithm"

# ╔═╡ 8b0325c7-c9ae-49b6-a508-3a0405edfdcb
function a_star_search(start::State)
	node = Node(start,nothing, nothing)
	if is_goal(node.state)
		return solution(node, "Agent is already at goal", [])
	end
	Frontier = PriorityQueue{Node , Int}()
	enqueue!(frontier, node, a_star_cost(node))
	explored = []
	count = 0
	
	while  true
		if isempty(frontier)
			return failure("Failed to find solution after exploring all nodes")
		end
		node = dequeue!(frontier)
		push!(explored, node.state)
		for(action, child) in get_transitions(node)
			if !(child in keys(frontier)) && (child.state in explored)
				if is_goal(child.state)
					return solution(child, explored)
						end
			end
			if count > 100
				return failure("Timed out")
			end
			end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
AStarSearch = "e6cbe913-2b79-4cc5-848a-e3bbf8537828"
DataStructures = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
Markdown = "d6f4376e-aef5-505a-96c1-9c027394607a"

[compat]
AStarSearch = "~0.5.3"
DataStructures = "~0.18.11"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.2"
manifest_format = "2.0"

[[deps.AStarSearch]]
deps = ["DataStructures"]
git-tree-sha1 = "a87235526b086001b4670bb950d76ffe861c8d83"
uuid = "e6cbe913-2b79-4cc5-848a-e3bbf8537828"
version = "0.5.3"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.Compat]]
deps = ["Base64", "Dates", "DelimitedFiles", "Distributed", "InteractiveUtils", "LibGit2", "Libdl", "LinearAlgebra", "Markdown", "Mmap", "Pkg", "Printf", "REPL", "Random", "SHA", "Serialization", "SharedArrays", "Sockets", "SparseArrays", "Statistics", "Test", "UUIDs", "Unicode"]
git-tree-sha1 = "b153278a25dd42c65abbf4e62344f9d22e59191b"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.43.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "3daef5523dd2e769dad2365274f760ff5f282c7d"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.11"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[deps.OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
"""

# ╔═╡ Cell order:
# ╠═9bca0d70-c67b-11ec-107f-c1c951eeb197
# ╠═2f87c95c-d054-43c1-b888-87ff587a6f97
# ╠═d2c78ce0-43c5-46d1-922f-6f8b4a96453f
# ╠═2117e527-e709-4449-a540-2c0aa1f07b6c
# ╠═3a9c00f5-328a-4228-aaa5-abacdca22fac
# ╠═1780448f-95ae-4a62-9752-09043a7b5660
# ╠═b6db9e7a-97b1-4db5-8a94-6215ea0ead32
# ╠═4909ebd7-47f2-4902-a5b5-de2d6ed140fc
# ╠═d5c03262-b344-4f77-84c3-2739b8f0e4c7
# ╠═db7d2e72-874d-470d-9e68-8b6aaf55b8cd
# ╠═add08b1f-ea70-4bad-a517-4efbe2a83586
# ╠═b5b28681-04fa-45cc-abda-5314686bad70
# ╠═552b2660-f0bd-42b5-86a8-1af71de08098
# ╠═598cd970-d053-46e8-91cd-97695d9b8818
# ╠═a307cf6d-d1a3-463f-915c-527c07102431
# ╠═ac9eb5d8-dd35-4b34-a7e9-8ce9dfc0fb22
# ╠═f6dfb722-f093-4a27-bd2a-0317c2f4b72c
# ╠═ff625ef2-e2f1-4753-99bf-76933b0bb8ec
# ╠═d4650231-abe1-4cd6-a300-fd71f7758f11
# ╟─69782c41-da9f-45d8-93af-66c213a50836
# ╠═d7b632a4-786d-42b2-9314-5b1a6c436bb3
# ╟─69869a66-e827-48f5-b027-18cba7f69841
# ╠═8b0325c7-c9ae-49b6-a508-3a0405edfdcb
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
