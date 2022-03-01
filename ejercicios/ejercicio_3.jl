### A Pluto.jl notebook ###
# v0.18.0

using Markdown
using InteractiveUtils

# ╔═╡ 570a058d-32df-4c76-b7de-8836f871b90e
using DataFrames, PlutoUI

# ╔═╡ edc56070-9958-11ec-370c-09c13519040e
md"""
# Ejercicio 3 

Dado tu número $m$ (de 30 cifras o mas) de la lista publicada:

1. Calcula $a^{m-1}\text{ mod }m$ para los 5 primeros primos.
2. Calcula el test de Solovay-Strassen para los 5 primeros primos.
3. Calcula el test de Miller-Rabin para esas 5 bases.
4. ¿Qué deduces sobre la primalidad de tu número?
"""

# ╔═╡ 2c4714d8-ef98-4e4e-9265-bd1d6506a9d7
md"## Apartado 1"

# ╔═╡ 22960792-61b2-4b9d-a2cc-d35903c8005b
m = 35948725702518441292684587619699

# ╔═╡ d1412d6f-329c-43b4-ab66-e68daecdddb6
md"Vamos a calcular $a^{m-1}\text{ mod }m$ para los primos 2, 3, 5, 7, 11:"

# ╔═╡ 2cc2e3b9-cf28-440e-b595-73b9890bfd97
primos = [2, 3, 5, 7, 11]

# ╔═╡ 7c95fb0f-c1cc-4683-850c-b0dce587ecc6
map(a -> powermod(a, m-1, m), primos)

# ╔═╡ 2bfcc6ff-b05e-42d6-a31d-5192066408ac
md"Como vemos, sale 1 para todos nuestros primos"

# ╔═╡ 54b36515-dab3-41d1-a022-8873bc8e895f
md"""
## Apartado 2

Para este apartado, vamos a reutilizar la función del símbolo de Jacobi del ejercicio 2
"""

# ╔═╡ 08adaa1c-ba20-404e-a205-ab510bb27a01
function simbolo_jacobi(a, n)
	if mod(n, 2) == 0
		throw("n debe ser impar")
	end
	
	t = 1 
	m = abs(n)
	b = mod(a, m)
	
	while a != 0
		while mod(a, 2) == 0
			a = a/2
			
			if mod(m, 8) in [3, 5]
				t = -t
			end
		end

		a, m = m, a

		if mod(a, 4) == 3 && mod(m, 4) == 3
			t = -t
		end

		a = mod(a, m)
	end

	if m == 1
		return t
	else
		return 0
	end
end

# ╔═╡ ae10b119-865f-4597-bec6-b0e32e88f1e9
"""
Computa el test de Solovay Strassen. Devuelve `true` si lo pasa; `false` en caso contrario
"""
function test_Solovay_Strassen(a, n)
	println("Test de Solovay Strassen para a = ", a, ", m = ", m)

	powmod = powermod(a, div(n-1, 2), n)
	
	if powmod ∉ [1, m-1]
		println("\ta^{(n-1)/2} mod n = ", powmod, ", que no es congruente con 1 o -1. Falla.")
		return false
	end

	println("\ta^{(n-1)/2} mod n = ", powmod, ". Jacobi = ", simbolo_jacobi(a, n), "\n")

	return mod(simbolo_jacobi(a, n), n)	== powmod
end

# ╔═╡ b08067ab-4ef3-42b4-8cd4-7fec7af924f7
md"Veamos si nuestro número pasa el test para los primeros primos:"

# ╔═╡ 9937ff68-532d-472a-9cee-612157785efa
with_terminal() do
	map(a -> test_Solovay_Strassen(a, m), primos)
end

# ╔═╡ 72da2e90-6fe8-48a3-92db-97f96a74ea94
resultados_test_SS = map(a -> test_Solovay_Strassen(a, m), primos)

# ╔═╡ 5bb28b44-02b8-4d98-a20b-a4731b6921e4
md"Los resultados del test son los siguientes:"

# ╔═╡ c1b61b28-f4f1-4552-8b8a-f03676336206
resultados = DataFrame(primo = primos, Test_Solovay_Strassen=resultados_test_SS)

# ╔═╡ b072d5ac-32e3-410e-86ef-624c26f24c58
md"""# Apartado 3
Hagamos lo mismo, pero con el test de Miller Rabin
"""

# ╔═╡ 2673a6b9-a86e-43e5-9e14-7fd3c15bb1be
"""
Calcula el test de Miller-Rabin para la base `a` y el exponente `m`. Devuelve `true` si lo pasa; `false` en caso contrario
"""
function test_Miller_Rabin(a, m)
	println("Calculando el test de Miller Rabin para a = ", a, ", m = ", m)
	
	# Paramos cuando (n-1)/2^i es impar
	exponentes = []
	actual = m - 1
	i = 0
	push!(exponentes, actual)

	while mod(actual, 2) == 0
		i = i + 1
		actual = div(m - 1, 2^i)
		push!(exponentes, actual)
	end

	# Ahora tenemos [n-1, (n-1)/2, ...]
	# Necesitamos ver qué sale la a-sucesión

	a_sucesion = map(e -> powermod(a, e, m), reverse(exponentes))

	# Si el último no sale módulo 1, o hay un 1 precedido de un entero != +-1, es compuesto
	if last(a_sucesion) != 1
		return false
	end

	for i in 2:length(a_sucesion)
		if a_sucesion[i] == 1 && a_sucesion[i-1] ∉ [1, m-1]
			return false
		end
	end

	println("\ta-sucesión = ", a_sucesion, "\n")
	
	return true
end

# ╔═╡ 0e4360db-a03a-40f3-adfb-1d88865045d1
md"Vemos que, para todos nuestros primos, nuestro número $m$ pasa el test de Miller Rabin:"

# ╔═╡ 6e65b0c4-2100-45e2-b393-8838767c40df
with_terminal() do
	map(a -> test_Miller_Rabin(a, 27213647), primos)
end

# ╔═╡ 9d8399c7-51fc-4b59-9317-d27879288995
resultados_test_MR = map(a -> test_Miller_Rabin(a, 27213647), primos)

# ╔═╡ be9fa5ac-8988-4b0f-8b1f-acce0777158d
resultados[!, :Test_Miller_Rabin] .= resultados_test_MR

# ╔═╡ 9ce5180e-28e9-485b-84b3-05e6e814dcc0
resultados

# ╔═╡ c7a223a4-4b36-4598-9d8c-1510c6760008
md"## Apartado 4"

# ╔═╡ 3da22578-2d20-4868-9107-8f2b23ba0bf0
md"""
Como ha pasado el test de Miller Rabin para las 5 bases, la probabilidad de que mi número sea compuesto es menor a $\frac{1}{4^5} = 0.0009765625$; es decir, que tiene una probabilidad de ser primo de $0.9990234375$
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
DataFrames = "~1.3.2"
PlutoUI = "~0.7.35"
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
# ╟─edc56070-9958-11ec-370c-09c13519040e
# ╠═570a058d-32df-4c76-b7de-8836f871b90e
# ╟─2c4714d8-ef98-4e4e-9265-bd1d6506a9d7
# ╟─22960792-61b2-4b9d-a2cc-d35903c8005b
# ╟─d1412d6f-329c-43b4-ab66-e68daecdddb6
# ╟─2cc2e3b9-cf28-440e-b595-73b9890bfd97
# ╠═7c95fb0f-c1cc-4683-850c-b0dce587ecc6
# ╟─2bfcc6ff-b05e-42d6-a31d-5192066408ac
# ╟─54b36515-dab3-41d1-a022-8873bc8e895f
# ╟─08adaa1c-ba20-404e-a205-ab510bb27a01
# ╠═ae10b119-865f-4597-bec6-b0e32e88f1e9
# ╟─b08067ab-4ef3-42b4-8cd4-7fec7af924f7
# ╟─9937ff68-532d-472a-9cee-612157785efa
# ╠═72da2e90-6fe8-48a3-92db-97f96a74ea94
# ╟─5bb28b44-02b8-4d98-a20b-a4731b6921e4
# ╟─c1b61b28-f4f1-4552-8b8a-f03676336206
# ╟─b072d5ac-32e3-410e-86ef-624c26f24c58
# ╠═2673a6b9-a86e-43e5-9e14-7fd3c15bb1be
# ╟─0e4360db-a03a-40f3-adfb-1d88865045d1
# ╠═6e65b0c4-2100-45e2-b393-8838767c40df
# ╟─9d8399c7-51fc-4b59-9317-d27879288995
# ╟─be9fa5ac-8988-4b0f-8b1f-acce0777158d
# ╟─9ce5180e-28e9-485b-84b3-05e6e814dcc0
# ╟─c7a223a4-4b36-4598-9d8c-1510c6760008
# ╟─3da22578-2d20-4868-9107-8f2b23ba0bf0
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
