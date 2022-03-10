### A Pluto.jl notebook ###
# v0.18.1

using Markdown
using InteractiveUtils

# ╔═╡ 29916bf1-dd8b-4b58-a1bb-fc69fa87d806
using Revise, PlutoUI, DataFrames, Primes

# ╔═╡ 02eebdd6-e6c6-4352-bb67-7c43d8ff1424
include("./ejercicio_4.jl")

# ╔═╡ 33d1dcf0-9df6-11ec-052c-db0b1f6e9906
md"""
# Ejercicio 5

Dado tu número $n$ de la lista publicada para este ejercicio:

1. Factoriza $n$ aplicando el método $\rho$ de Polard. ¿Cúantas iteraciones necesitas?
Sea $p1$ el mayor de sus factores primos y $p2$ el siguiente primo.
2. Calcula las partes enteras de $\sqrt{p1}$ y $\sqrt{p2}$ con el algoritmo entero.
3. Calcula las FCS de $\sqrt{p1}$ y $\sqrt{p2}$ aplicando el algoritmo que usa aritmética entera
"""

# ╔═╡ 05d36ee9-9e0a-416e-8691-0ea120a8f283
md"""
## Apartado 1
"""

# ╔═╡ 13c7aa41-a48b-46bb-aec8-d4419b445ce7
n = 16133993
#n = 22607939 # n de Paula

# ╔═╡ fc246906-c272-44b6-b0e7-42822d42d29c
md"Vamos a factorizar $n$ usando $\rho$ de Polard:"

# ╔═╡ 661190ff-c3f0-49da-a71a-7c5cfd660983
factores = ρ_Polard(n, x -> x^2 + 1, 5000)

# ╔═╡ 866bdcd2-d61f-42db-bfa2-cadad0c078a2
md"""Se han necesitado 1113 iteraciones. Vamos a comprobar que son primos: """

# ╔═╡ 57c7e721-020b-4284-9daa-350d8f23f618
p1 = first(first(factores))

# ╔═╡ 673cdf01-eb38-4be8-8c55-1222d669b849
p2 = last(first(factores))

# ╔═╡ 0b6feb51-6448-4ec1-9564-2cdc26d0e275
lucas_lehmer(p1), lucas_lehmer(p2)

# ╔═╡ 73d69c7c-7c09-4ae9-90fa-6e50d385a71d
isprime(p1), isprime(p2)

# ╔═╡ d49e8ca6-b8d3-43f3-b44d-83ec59ee70c4
md"""Por Lucas-Lehmer, es muy probable que sean primos. Y de todas formas, lo verificamos con las funciones integradas del lenguaje para asegurarnos.

## Apartado 2 

Vamos a calcular ahora sus partes enteras con el algoritmo de raíz entera. Para ello, definimos la siguiente función:
"""

# ╔═╡ 28dba051-1fd8-4ee5-9621-b360f019209c
"""
Calcula la parte entera de la raíz de n
"""
function raiz_entera(n)
	a =	iseven(n) ? div(n, 2) : div(n+1, 2)
	b = div(a^2 + n, 2*a)
	i = 0 

	while a > b
		a = b
		b = div(a^2 + n, 2*a)
		i = i + 1
		#println("i, a, b = $i, $a, $b")
	end

	return a
end

# ╔═╡ 6e054b14-21a6-4386-98ea-9d37a0e4ea88
md"Aplicándolo a nuestros primos $p_1$  y $p_2$:"

# ╔═╡ f63b34b4-7e13-4a22-b7ee-273a939bf508
raiz_entera(p1), raiz_entera(p2)

# ╔═╡ f68fce17-e50e-4ca3-9875-9d37e3412eb2
md"""
## Apartado 3

Pasemos a calcular las fracciones continuas simples. Como estamos en el caso de que $\alpha = \sqrt{d}$, podemos usar el criterio de parada $Q_i = 1$
"""

# ╔═╡ 1b887f64-944e-49bb-84c0-a70e81e0d8cd
function FCS(d)
	P = 0 
	Q = 1 
	sqrt_d_entera = raiz_entera(d)
	q = sqrt_d_entera

	fcs = [q]
	
	i = 0 

    println("Paso | P_i | Q_i | q_i")
    println("$i | $P | $Q | $q")

	i = 1 
	P = q * Q - P 
	Q_anterior = Q
	Q = div(d - P^2, Q)
	q = div(P + sqrt_d_entera, Q)

	push!(fcs, q)

	println("$i | $P | $Q | $q")

	while true
		i = i + 1
		
		P_anterior = P 
		P = q * Q - P 
		
		Q_anterior2 = Q_anterior
		Q_anterior = Q

		Q = Q_anterior2 + q * (P_anterior - P)
		q = div(P + sqrt_d_entera, Q)
		
		if Q_anterior == 1
			break
		else 
			push!(fcs, q)
		end

		println("$i | $P | $Q | $q")
	end

	return fcs
end

# ╔═╡ cfa3f294-208a-4e96-ac72-2e7dafbf9e3b
FCS(p1)

# ╔═╡ f8af2039-fd2c-4c7d-8225-e4eb55226323
FCS(p2)

# ╔═╡ 54f11d9d-da5a-4c17-9623-50806eb25117
md"""
# Ejercicio 6

Sea $p$ el factor primo que tiene mayor periodo.
1. Calcula los convergentes de $p$.
2. Calcula las soluciones de las ecuaciones de Pell, $x^2 - py^2 = \pm 1$
3. Calcula las unidades del anillo de enteros cuadráticos $\mathbb{Z}[\sqrt{p}]$.
4. ¿Es $\mathbb{Z}[\sqrt{p}]$ el anillo de enteros del cuerpo $\mathbb{Q}[\sqrt{p}]$? 
"""

# ╔═╡ 6d379883-3912-430d-b03f-40e0752787e5
"""
Calcula el periodo de una FCS de la forma sqrt(d)
"""
function periodo_raiz_irracional(d)
	return length(FCS(d)) - 1
end

# ╔═╡ 904bddae-3602-4b13-bc13-ffedba08c2f3
md"""
Primero, tomemos el primo con mayor periodo:
"""

# ╔═╡ 480d195c-26b1-4513-aaa6-801ccfeb9941
periodo_raiz_irracional(p1), periodo_raiz_irracional(p2)

# ╔═╡ e3990510-2d29-457d-b64c-1322ce057a90
p = periodo_raiz_irracional(p1) > periodo_raiz_irracional(p2) ? p1 : p2

# ╔═╡ df7cc798-3319-4fd7-aea6-19b159589c2a
md"""
## Apartado 1

Calculemos los convergentes de $p$
"""

# ╔═╡ 4d064a97-1ae3-4d82-8d0d-06bfc89c3bf6
"""
Calcula los convergentes de d
"""
function convergentes(d)
	fcs = FCS(d)
	
	A_anterior2::BigInt = 1 		    # A_-1
	A_anterior::BigInt  = first(fcs)	# A_0

	B_anterior2::BigInt = 0 	# B_-1
	B_anterior::BigInt  = 1   	# B_0 

	convergentes = [(convert(BigInt, first(fcs)), convert(BigInt, 1))]

	for i in 2:length(fcs)-1
		A = fcs[i] * A_anterior + A_anterior2
		B = fcs[i] * B_anterior + B_anterior2

		A_anterior2 = A_anterior
		A_anterior = A
		
		B_anterior2 = B_anterior
		B_anterior = B

		push!(convergentes, (A, B))
	end

	return convergentes
end

# ╔═╡ a9a4cfb7-d098-4d52-923e-8165039f4336
function convergentes(d, t)
	P = 0 
	Q = 1 
	sqrt_d_entera = raiz_entera(d)
	q = sqrt_d_entera

	fcs = [q]

	A_anterior2::BigInt = 1
	A_anterior::BigInt  = q

	B_anterior2::BigInt = 0
	B_anterior::BigInt =  1
	convergentes = [(convert(BigInt, q), convert(BigInt, 1))]
	
	i = 0 

	i = 1 
	P = q * Q - P 
	Q_anterior = Q
	Q = div(d - P^2, Q)
	q = div(P + sqrt_d_entera, Q)


	A::BigInt = q * A_anterior + A_anterior2
	B::BigInt = q * B_anterior + B_anterior2

	A_anterior2 = A_anterior
	A_anterior = A
	
	B_anterior2 = B_anterior
	B_anterior = B

	push!(convergentes, (A, B))


	guardados = []

	while true
		i = i + 1
		
		P_anterior = P 
		P = q * Q - P 
		
		Q_anterior2 = Q_anterior
		Q_anterior = Q

		Q = Q_anterior2 + q * (P_anterior - P)
		q = div(P + sqrt_d_entera, Q)

		if i == t
			break
		end

		A = q * A_anterior + A_anterior2
		B = q * B_anterior + B_anterior2

		A_anterior2 = A_anterior
		A_anterior = A
		
		B_anterior2 = B_anterior
		B_anterior = B

		push!(convergentes, (A, B))
		#println("[$i](q = $q) $A^2 - d*$B^2 = ", A^2 - d*B^2)
	end

	return convergentes
end

# ╔═╡ b14ad0dd-a3d7-40d7-a2c6-6ba79370a47f
convergentes(p)

# ╔═╡ ba8876c9-26aa-433a-ade7-16b9335ecf72
"""
Calcula las soluciones a la ecuación de Pell `x^2 - d y^2 = -+ 1`
"""
function ecuacion_Pell(d)
	conv = convergentes(d)
	r = periodo_raiz_irracional(d)

	indices_posibles_sols = []

	# Corolario 10
	for i in 1:length(conv)
		if r * i > length(conv)
			break
		end

		push!(indices_posibles_sols, r * i)

	end

	@info indices_posibles_sols
	@info length(conv)
	
	soluciones = []

	for i in indices_posibles_sols
		push!(soluciones, 
			(numerator(conv[i]), denominator(conv[i]))
		)
	end
	return soluciones
end

# ╔═╡ 68e13fff-d841-401a-aa47-72b8c3a344ae
function ecuacion_generica(d, N)
	conv = convergentes(d)
	#popfirst!(conv)
	soluciones = []

	@info conv

	for fraccion in conv
		x = numerator(fraccion)
		y = denominator(fraccion)

		if abs(x^2 - d*y^2) == N
			push!(soluciones, (x, y)) 
		end
	end

	return soluciones

end

# ╔═╡ 60de4a9e-0361-44e8-bf6a-e3a70e57ec6c
with_terminal() do 
	convergentes(p, 1000)
end

# ╔═╡ a803ca75-945d-45c8-9f44-133775e29ffb
periodo_raiz_irracional(p)

# ╔═╡ 30092553-8edd-4ec8-8f0c-47134e65c4ea
md"Como el periodo de $p$ es par, la solución a $x^2 - p*y^2 = -1$ viene dada por $(A_{r-1}, B_{r-1})$"

# ╔═╡ dc6a254a-0ede-4cf6-af1b-d62765b30490
convergente = convergentes(p, periodo_raiz_irracional(p))[periodo_raiz_irracional(p)]

# ╔═╡ 9454430c-c522-4659-b2e1-64f2792a2650
a, b = convergente[1], convergente[2]

# ╔═╡ e5e869e4-241b-4ced-948e-005cf5269c00
md"Comprobamos que se cumple:"

# ╔═╡ 20c36cbe-fa47-4fa1-ab1a-af1e07e1cc75
a^2 - p*b^2

# ╔═╡ b771c1c0-c282-4dfc-954e-5981ac78164c
md"""
Por lo tanto, cualquier unidad del anillo cuadrático $\mathbb{Z}[\sqrt{p}] = \mathbb{Z}[\sqrt{7753}]$ es una potencia (excepto signo) de $a + b\sqrt{7753}$:

$$x + y \sqrt{7753} = \pm (a + b\sqrt{7753})^n$$
"""

# ╔═╡ ab9f3694-c27b-49ba-9637-96a523b902c1
md"# Ejemplo de verificación del profesor"

# ╔═╡ 749a567d-0f32-4914-a658-9b5e794415a1
profesor = 3613

# ╔═╡ 93fff8c6-03c7-4121-8e3c-7605de96c6cf
FCS(profesor)

# ╔═╡ 0a583da5-4ff3-4ad3-9a72-c8d0b54197b8
periodo_raiz_irracional(profesor)

# ╔═╡ ec079971-0bcf-4bca-b959-7b90dcd19481
convergentes(profesor, periodo_raiz_irracional(profesor) + 1)

# ╔═╡ 50cb5baf-0884-4fcd-8f41-20dba40212a8
prof_conv = convergentes(profesor, periodo_raiz_irracional(profesor))[periodo_raiz_irracional(profesor)]

# ╔═╡ e92ccfdf-f374-40ad-8ac8-d55df6b787ec
convergentes(profesor)

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Primes = "27ebfcd6-29c5-5fa9-bf4b-fb8fc14df3ae"
Revise = "295af30f-e4ad-537b-8983-00126c2a3abe"

[compat]
DataFrames = "~1.3.2"
PlutoUI = "~0.7.36"
Primes = "~0.5.1"
Revise = "~3.3.3"
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
git-tree-sha1 = "96b0bc6c52df76506efc8a441c6cf1adcb1babc4"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.42.0"

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
git-tree-sha1 = "8d3217a3599ac9371dbbb9f6fd3051c6b1c59b45"
uuid = "aa1ae85d-cabe-5617-a682-6adf51b2e16a"
version = "0.9.8"

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
git-tree-sha1 = "85b5da0fa43588c75bb1ff986493443f821c70b7"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.2.3"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "2c87c85e397b7ffed5ffec054f532d4edd05d901"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.36"

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
git-tree-sha1 = "4d4239e93531ac3e7ca7e339f15978d0b5149d03"
uuid = "295af30f-e4ad-537b-8983-00126c2a3abe"
version = "3.3.3"

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
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "OrderedCollections", "TableTraits", "Test"]
git-tree-sha1 = "5ce79ce186cc678bbb5c5681ca3379d1ddae11a1"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.7.0"

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
# ╟─33d1dcf0-9df6-11ec-052c-db0b1f6e9906
# ╟─29916bf1-dd8b-4b58-a1bb-fc69fa87d806
# ╟─02eebdd6-e6c6-4352-bb67-7c43d8ff1424
# ╟─05d36ee9-9e0a-416e-8691-0ea120a8f283
# ╟─13c7aa41-a48b-46bb-aec8-d4419b445ce7
# ╟─fc246906-c272-44b6-b0e7-42822d42d29c
# ╠═661190ff-c3f0-49da-a71a-7c5cfd660983
# ╟─866bdcd2-d61f-42db-bfa2-cadad0c078a2
# ╟─57c7e721-020b-4284-9daa-350d8f23f618
# ╟─673cdf01-eb38-4be8-8c55-1222d669b849
# ╠═0b6feb51-6448-4ec1-9564-2cdc26d0e275
# ╠═73d69c7c-7c09-4ae9-90fa-6e50d385a71d
# ╟─d49e8ca6-b8d3-43f3-b44d-83ec59ee70c4
# ╠═28dba051-1fd8-4ee5-9621-b360f019209c
# ╟─6e054b14-21a6-4386-98ea-9d37a0e4ea88
# ╠═f63b34b4-7e13-4a22-b7ee-273a939bf508
# ╟─f68fce17-e50e-4ca3-9875-9d37e3412eb2
# ╠═1b887f64-944e-49bb-84c0-a70e81e0d8cd
# ╠═cfa3f294-208a-4e96-ac72-2e7dafbf9e3b
# ╠═f8af2039-fd2c-4c7d-8225-e4eb55226323
# ╟─54f11d9d-da5a-4c17-9623-50806eb25117
# ╠═6d379883-3912-430d-b03f-40e0752787e5
# ╟─904bddae-3602-4b13-bc13-ffedba08c2f3
# ╠═480d195c-26b1-4513-aaa6-801ccfeb9941
# ╟─e3990510-2d29-457d-b64c-1322ce057a90
# ╟─df7cc798-3319-4fd7-aea6-19b159589c2a
# ╠═4d064a97-1ae3-4d82-8d0d-06bfc89c3bf6
# ╠═b14ad0dd-a3d7-40d7-a2c6-6ba79370a47f
# ╟─ba8876c9-26aa-433a-ade7-16b9335ecf72
# ╟─68e13fff-d841-401a-aa47-72b8c3a344ae
# ╟─a9a4cfb7-d098-4d52-923e-8165039f4336
# ╠═60de4a9e-0361-44e8-bf6a-e3a70e57ec6c
# ╠═a803ca75-945d-45c8-9f44-133775e29ffb
# ╟─30092553-8edd-4ec8-8f0c-47134e65c4ea
# ╠═dc6a254a-0ede-4cf6-af1b-d62765b30490
# ╠═9454430c-c522-4659-b2e1-64f2792a2650
# ╟─e5e869e4-241b-4ced-948e-005cf5269c00
# ╠═20c36cbe-fa47-4fa1-ab1a-af1e07e1cc75
# ╟─b771c1c0-c282-4dfc-954e-5981ac78164c
# ╠═ab9f3694-c27b-49ba-9637-96a523b902c1
# ╟─749a567d-0f32-4914-a658-9b5e794415a1
# ╠═93fff8c6-03c7-4121-8e3c-7605de96c6cf
# ╠═0a583da5-4ff3-4ad3-9a72-c8d0b54197b8
# ╠═ec079971-0bcf-4bca-b959-7b90dcd19481
# ╠═50cb5baf-0884-4fcd-8f41-20dba40212a8
# ╠═e92ccfdf-f374-40ad-8ac8-d55df6b787ec
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
