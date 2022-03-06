### A Pluto.jl notebook ###
# v0.18.1

using Markdown
using InteractiveUtils

# ╔═╡ 90d0590a-8eb1-414c-b310-5b4efcaea7ef
using Revise, DataFrames, PlutoUI, Primes

# ╔═╡ 4bde657e-f021-4f4b-b844-3fccaad1ea7b
include("./ejercicio_3.jl")

# ╔═╡ 3d9b74e0-9959-11ec-3543-cda7e1f95c77
md"""
# Ejercicio 4

Dado tu número $n$ de 8 cifras de la lista del ejercicio 2:

1. Facroriza $n-1$ aplicando el método $\rho$ de Polard. ¿Cuántas iteraciones necesitas?
2. Si es necesario aplica recursivamente Lucas-Lehmer para certificar factores primos de $n-1$ mayores de 4 cifras.
3. Aplica Lucas-Lehmer para encontrar un certificado de primalidad de $n$.

> NOTA: Debes encontrar el natural más pequeño cuya clase sea primitiva.
"""

# ╔═╡ 97ac7584-87b6-4082-afaf-8e6610ad7bd7
md"""
## Apartado 1

Volvemos a usar el número del ejercicio 2, que es
"""

# ╔═╡ e6c11a6f-fad9-4be7-b72d-9b052ddc4554
n = 77432081

# ╔═╡ be15cc7d-8d66-49a0-835d-66f614e98796
md"Vamos a aplicar el método $\rho$ de Polard para factorizar $n$:"

# ╔═╡ 5f73adf3-55ab-49d8-a9ed-c8d06e0d5805
"""
Factoriza el número `n` usando una función `f: Z_n -> Z_n` mediante el método de detección de Floyd. Devuelve el formato `[factores, iteraciones]`, donde `factores` es un array
"""
function ρ_Polard(n, f, t = 100, x0 = 2)
	# En caso en el que sea divisible por dos, es posible que falle, así que lo comprobamos a mano.
	if mod(n, 2) == 0
		return [[2, div(n, 2)], 0]
	end


	x = x0
	y = x
	i = 0

	println("Paso | x | y | mcd")
	while i < t
		i = i + 1
		x = mod(f(x), n)
		y = mod(f(f(y)), n)
		g = gcd(x - y, n)
		println("$i | $x | $y | $g")

		if 1 < g && g < n
			println("Iteraciones necesarias para $n: $i")
			return [[g, div(n, g)], i]
		end
	end

	return []
end

# ╔═╡ 2fa8bd85-95c9-45cb-838c-fa2da880de66
md"Primero, vamos a aplicar $\rho$ de Polard para n-1, con la función $f(x) = x^2 + 1$:"

# ╔═╡ c3202c6e-c174-4fdb-827c-30b513ee2c26
ρ_Polard(n-1, x -> x^2 + 1)

# ╔═╡ cacc9213-fcc6-4789-a0c2-6af504ed612d
md"Vemos que nuestro método ha encontrado los factores $2$ y $38716040$. Sin embargo, es bastante probable que tenga más. Vamos a definir una nueva función que nos permita encontrarlos todos:"

# ╔═╡ 585b4013-4158-4617-a6bf-e41f98d2a8e4
"""
Descompone el número `n` aplicando el método `rho_Polard` recursivamente
"""
function descomponer(n)
	por_descomponer = [n]
	irreducibles = []
	primos = [2, 3, 5, 7, 11, 13, 17]
	f = x -> x^2 + 1
	i = 0

	while length(por_descomponer) > 0
		num = pop!(por_descomponer)

		test_MR = map(a -> test_Miller_Rabin(a, num), primos)

		if all(test_MR) || num ∈ primos
			push!(irreducibles, num)
		else
			resultado = ρ_Polard(num, f)
			i = i + resultado[2]
			por_descomponer = vcat(por_descomponer, resultado[1])
		end
	end

	return [irreducibles, i]
end

# ╔═╡ 1455a101-4535-46af-82bf-4389d54b5043
with_terminal() do
	resultado = descomponer(n-1)
end

# ╔═╡ 8d80b723-f5ae-4bc1-a4f8-008acd4d6033
md"""
Vemos que los factores son $87991, 5, 11, 2, 2, 2, 2$, y han sido necesarias $5$ iteraciones para calcularlo.
"""

# ╔═╡ 1677f7f4-dba2-465a-bf28-4f4b3d9f9bde
md"""
## Apartado 2

Hemos obtenido un factor, $87991$, que es mayor de 4 cifras. Vamos a pasarle el test de Lucas-Lehmer para certificar su primalidad.

El teorema de Lucas-Lehmer nos dice que si $\exists a \in \mathbb{Z}$ tal que $a^{n-1} \equiv 1 \text{ mod }n$ y $a^{(n-1)/q} \not \equiv 1 \text{ mod }n$ para todo divisor primo $q$ de $n - 1$, entonces $n$ es primo.

Vamos a programar una función para comprobar cualquier $n$:
"""

# ╔═╡ d141bd31-db98-44b0-88f1-8ea7ebea61f6
function lucas_lehmer(n)
	println("Aplicando el test de Lucas-Lehmer para $n")

	factores = collect(keys(factor(n-1)))

	for a in 1:(n-1)
		println("\tProbando con $a")

		if powermod(a, n-1, n) == 1
			resultado = map(q -> powermod(a, div(n-1, q), n), factores)
			if 1 ∉ resultado
				println("\t\tSe ha encontrado a = $a")
				println("\t\tResultados modulares: $resultado")
				return true
			else
				posicion = first(findall(x -> x == 1, resultado))
				println("\t\tFalla para q = ", factores[posicion])
			end
		end
	end

	return false
end

# ╔═╡ e7af23f6-dc54-4fc0-96f0-5be8a25962e4
md"Veamos qué ocurre si se lo aplicamos:"

# ╔═╡ 60b600c8-8557-4c9a-800c-e20a55b701dd
with_terminal() do
	lucas_lehmer(87991)
end

# ╔═╡ a508c201-258d-4077-b865-470fbb28c14c
md"Así que el número $87991$ es primo"

# ╔═╡ 351fcf82-4237-4d67-9125-a3c93880b177
md"""
## Apartado 3

Apliquémosle el test ahora a $n$
"""

# ╔═╡ 4ce136e2-41b2-440a-ac1c-056b6dcc97e2
with_terminal() do
	lucas_lehmer(n)
end


# ╔═╡ 07c998de-2dd9-42c2-b266-524028fc3197
md"Por el Teorema de Lucas-Lehmer, $n$ es primo"

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Primes = "27ebfcd6-29c5-5fa9-bf4b-fb8fc14df3ae"
Revise = "295af30f-e4ad-537b-8983-00126c2a3abe"

[compat]
DataFrames = "~1.3.2"
PlutoUI = "~0.7.35"
Primes = "~0.5.1"
Revise = "~3.3.2"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.2"
manifest_format = "2.0"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.CodeTracking]]
deps = ["InteractiveUtils", "UUIDs"]
git-tree-sha1 = "759a12cefe1cd1bb49e477bc3702287521797483"
uuid = "da1fd8a2-8d9e-5ec2-8556-3022fb5608a2"
version = "1.0.7"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "024fe24d83e4a5bf5fc80501a314ce0d1aa35597"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.0"

[[deps.Compat]]
deps = ["Base64", "Dates", "DelimitedFiles", "Distributed", "InteractiveUtils", "LibGit2", "Libdl", "LinearAlgebra", "Markdown", "Mmap", "Pkg", "Printf", "REPL", "Random", "SHA", "Serialization", "SharedArrays", "Sockets", "SparseArrays", "Statistics", "Test", "UUIDs", "Unicode"]
git-tree-sha1 = "44c37b4636bc54afac5c574d2d02b625349d6582"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.41.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[deps.Crayons]]
git-tree-sha1 = "249fe38abf76d48563e2f4556bebd215aa317e15"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.1.1"

[[deps.DataAPI]]
git-tree-sha1 = "cc70b17275652eb47bc9e5f81635981f13cea5c8"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.9.0"

[[deps.DataFrames]]
deps = ["Compat", "DataAPI", "Future", "InvertedIndices", "IteratorInterfaceExtensions", "LinearAlgebra", "Markdown", "Missings", "PooledArrays", "PrettyTables", "Printf", "REPL", "Reexport", "SortingAlgorithms", "Statistics", "TableTraits", "Tables", "Unicode"]
git-tree-sha1 = "ae02104e835f219b8930c7664b8012c93475c340"
uuid = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
version = "1.3.2"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "3daef5523dd2e769dad2365274f760ff5f282c7d"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.11"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

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

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
git-tree-sha1 = "2b078b5a615c6c0396c77810d92ee8c6f470d238"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.3"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.InvertedIndices]]
git-tree-sha1 = "bee5f1ef5bf65df56bdd2e40447590b272a5471f"
uuid = "41ab1584-1d38-5bbf-9106-f11c6c58b48f"
version = "1.1.0"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[deps.JuliaInterpreter]]
deps = ["CodeTracking", "InteractiveUtils", "Random", "UUIDs"]
git-tree-sha1 = "0a815f0060ab182f6c484b281107bfcd5bbb58dc"
uuid = "aa1ae85d-cabe-5617-a682-6adf51b2e16a"
version = "0.9.7"

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

[[deps.LoweredCodeUtils]]
deps = ["JuliaInterpreter"]
git-tree-sha1 = "6b0440822974cab904c8b14d79743565140567f6"
uuid = "6f1432cf-f94c-5a45-995e-cdbf5db27b0b"
version = "2.2.1"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "bf210ce90b6c9eed32d25dbcae1ebc565df2687f"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.0.2"

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

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "13468f237353112a01b2d6b32f3d0f80219944aa"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.2.2"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "85bf3e4bd279e405f91489ce518dedb1e32119cb"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.35"

[[deps.PooledArrays]]
deps = ["DataAPI", "Future"]
git-tree-sha1 = "db3a23166af8aebf4db5ef87ac5b00d36eb771e2"
uuid = "2dfb63ee-cc39-5dd5-95bd-886bf059d720"
version = "1.4.0"

[[deps.PrettyTables]]
deps = ["Crayons", "Formatting", "Markdown", "Reexport", "Tables"]
git-tree-sha1 = "dfb54c4e414caa595a1f2ed759b160f5a3ddcba5"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "1.3.1"

[[deps.Primes]]
git-tree-sha1 = "984a3ee07d47d401e0b823b7d30546792439070a"
uuid = "27ebfcd6-29c5-5fa9-bf4b-fb8fc14df3ae"
version = "0.5.1"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.Revise]]
deps = ["CodeTracking", "Distributed", "FileWatching", "JuliaInterpreter", "LibGit2", "LoweredCodeUtils", "OrderedCollections", "Pkg", "REPL", "Requires", "UUIDs", "Unicode"]
git-tree-sha1 = "606ddc4d3d098447a09c9337864c73d017476424"
uuid = "295af30f-e4ad-537b-8983-00126c2a3abe"
version = "3.3.2"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "b3363d7460f7d098ca0912c69b082f75625d7508"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.0.1"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "TableTraits", "Test"]
git-tree-sha1 = "bb1064c9a84c52e277f1096cf41434b675cd368b"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.6.1"

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
# ╟─3d9b74e0-9959-11ec-3543-cda7e1f95c77
# ╟─4bde657e-f021-4f4b-b844-3fccaad1ea7b
# ╟─90d0590a-8eb1-414c-b310-5b4efcaea7ef
# ╟─97ac7584-87b6-4082-afaf-8e6610ad7bd7
# ╟─e6c11a6f-fad9-4be7-b72d-9b052ddc4554
# ╟─be15cc7d-8d66-49a0-835d-66f614e98796
# ╠═5f73adf3-55ab-49d8-a9ed-c8d06e0d5805
# ╟─2fa8bd85-95c9-45cb-838c-fa2da880de66
# ╠═c3202c6e-c174-4fdb-827c-30b513ee2c26
# ╟─cacc9213-fcc6-4789-a0c2-6af504ed612d
# ╠═585b4013-4158-4617-a6bf-e41f98d2a8e4
# ╠═1455a101-4535-46af-82bf-4389d54b5043
# ╟─8d80b723-f5ae-4bc1-a4f8-008acd4d6033
# ╟─1677f7f4-dba2-465a-bf28-4f4b3d9f9bde
# ╠═d141bd31-db98-44b0-88f1-8ea7ebea61f6
# ╟─e7af23f6-dc54-4fc0-96f0-5be8a25962e4
# ╠═60b600c8-8557-4c9a-800c-e20a55b701dd
# ╟─a508c201-258d-4077-b865-470fbb28c14c
# ╟─351fcf82-4237-4d67-9125-a3c93880b177
# ╠═4ce136e2-41b2-440a-ac1c-056b6dcc97e2
# ╟─07c998de-2dd9-42c2-b266-524028fc3197
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
