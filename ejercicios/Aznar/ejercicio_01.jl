### A Pluto.jl notebook ###
# v0.18.0

using Markdown
using InteractiveUtils

# ╔═╡ 67f4e16e-7acd-4d59-b7ff-eb13b1963e35
begin
	using PlutoUI
	using Primes
end

# ╔═╡ c4f69621-11c6-4b82-a182-3cd177396f92
md"""
# Ejercicio 1 

> Autor: Andrés Millán
> 
Dado tu número n = d1d2d3d4d5d6d7d8,

1. Mientras n sea múltiplo de 2, 3, 5, 7 u 11 le sumas uno. De forma que tu nuevo n no tenga esos divisores primos.
2. Calcula $a^{n-1} \text{ mod } n$ para cada uno de esas cinco bases usando sucesivamente el algoritmo de izda-drcha y de drcha-izda.
3. ¿Es n un posible primo de Fermat para alguna de ellas? ¿Es n un pseudoprimo para alguna de ellas?
"""

# ╔═╡ 3a664158-13f6-479b-bbb3-542728b5ba33
md"Mi número es"

# ╔═╡ 345c845d-97dd-4500-9e2d-a9e4423ab9ab
n = 77432071

# ╔═╡ d0876ae7-eadd-4631-ad8b-0793a8b22f5a
md"Mientras que sea múltiplo de 2, 3, 5, 7 u 11, le vamos a sumar 1:"

# ╔═╡ 4674d500-933e-11ec-319a-2bc8ee4dec72
function parse_number(n)
    while mod(n, 2) == 0 || mod(n, 3) == 0 || mod(n, 5) == 0 || mod(n, 7) == 0 || mod(n, 11) == 0
        n = n + 1
    end

    return n
end

# ╔═╡ 6aafc7d5-25e3-4f26-aab4-b8e838067887
n_parseado = parse_number(n)

# ╔═╡ e99e9208-29b1-4fc0-bdac-b1ca1518a1f6
md"Para calcular $a^{n-1}\text{ mod } n$, vamos a definir las siguientes funciones:"

# ╔═╡ 8c09c59b-80ca-4257-91d4-4b0ce67f04dc
function fast_exp_left_to_right(a, n)
    println("Exponenciación rápida de izquierda a derecha, a = ", a, ", n = ", n)
    binario = reverse(digits(n-1, base = 2))

    acu = 1
    c   = 0

    for (i, e_i) in enumerate(binario)
        acu = mod(acu * acu, n)
        c   = c * 2

        if e_i == 1
            acu = mod(acu * a, n)
            c   = c + 1
        end

        println("\tPaso = ", i, ", acumulador = ", acu)
    end

    println("Finalmente, a^(n-1) mod n = ", a, "^", n - 1, " mod ", n, " = ", acu, "\n")
    return acu
end

# ╔═╡ 81c3e4ce-251a-4417-92e7-8ab9d06bccb9
function fast_exp_right_to_left(a, n)
    # returns a^n-1 mod n
    println("Exponenciación rápida de derecha a izquierda, a = ", a, ", n = ", n)

    base = a
    acu  = 1
    num  = n - 1
    exp  = 0

    e_i = 0
    i   = 0

    while num > 0
        i = i + 1

        if mod(num, 2) == 1
            acu = mod(acu * base, n)
            num = (num - 1)/2
            e_i = 1
        else
            num = num/2
            e_i = 0
        end

        base = mod(base * base, n)
        exp  = exp + (e_i * e_i) ^ i

        println("\tPaso = ", i, ", acumulador = ", acu, ", base = ", base)
    end

    println("Finalmente, a^(n-1) mod n = ", a, "^", n - 1, " mod ", n, " = ", acu, "\n")
    return acu
end

# ╔═╡ 0e4a2664-8bf7-4c5f-9ffd-c1e5e804f23c
with_terminal() do
	for a in [2, 3, 5, 7, 11]
	    fast_exp_left_to_right(a, n_parseado)
	    fast_exp_right_to_left(a, n_parseado)
	end
end

# ╔═╡ 379cc1bd-4c21-4bee-acff-aee05d477606
md"""
## ¿Es n un posible primo de Fermat?

Como podemos ver, ninguna de las ejecuciones acaba dando 1. Esto nos dice que n es compuesto. 

## ¿Es n un pseudoprimo para alguna de ellas?

Dado que lo anterior no ocurre, esto tampoco.

De hecho, podemos ver sus factores con:
"""

# ╔═╡ ffe749c8-7801-4298-af92-56f0ff510232
Primes.factor(n)

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Primes = "27ebfcd6-29c5-5fa9-bf4b-fb8fc14df3ae"

[compat]
PlutoUI = "~0.7.34"
Primes = "~0.5.1"
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

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

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

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

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
git-tree-sha1 = "8979e9802b4ac3d58c503a20f2824ad67f9074dd"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.34"

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

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

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
# ╟─c4f69621-11c6-4b82-a182-3cd177396f92
# ╟─67f4e16e-7acd-4d59-b7ff-eb13b1963e35
# ╟─3a664158-13f6-479b-bbb3-542728b5ba33
# ╠═345c845d-97dd-4500-9e2d-a9e4423ab9ab
# ╟─d0876ae7-eadd-4631-ad8b-0793a8b22f5a
# ╠═4674d500-933e-11ec-319a-2bc8ee4dec72
# ╠═6aafc7d5-25e3-4f26-aab4-b8e838067887
# ╟─e99e9208-29b1-4fc0-bdac-b1ca1518a1f6
# ╠═8c09c59b-80ca-4257-91d4-4b0ce67f04dc
# ╠═81c3e4ce-251a-4417-92e7-8ab9d06bccb9
# ╠═0e4a2664-8bf7-4c5f-9ffd-c1e5e804f23c
# ╟─379cc1bd-4c21-4bee-acff-aee05d477606
# ╠═ffe749c8-7801-4298-af92-56f0ff510232
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002