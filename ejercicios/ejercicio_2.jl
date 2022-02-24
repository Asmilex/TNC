### A Pluto.jl notebook ###
# v0.18.0

using Markdown
using InteractiveUtils

# ╔═╡ a61850f7-32bc-4463-9e28-9117ed578f8f
using PlutoUI

# ╔═╡ 328a2950-9343-11ec-28ec-7139a5c072a1
md"""

# Ejercicio 2 

Dado tu número n de 8 cifras de la lista publicada.
1. Usa el algoritmo manual para calcular el símbolo de Jacobi ($\frac{p}{n}$), para p cada uno de los 5 primeros primos.
2. Si para alguna de esas bases tu número sale posible primo de Fermat, comprueba si además es posible primo de Euler.
3. ¿Es tu número n pseudoprimo de Fermat o de Euler para alguna de las bases?
"""

# ╔═╡ 71d06108-4871-4c8e-a1d2-fea490935048
n::Int64 = 77432081
# m = 27213647 # m de ejemplo

# ╔═╡ 777b4e82-d446-4e88-8a01-505d148a6371
md"## Algoritmo manual"

# ╔═╡ ff475c8f-5192-4821-ad48-cdd27519b1ee
md"De partida, calculemos $n \text{ mod } 8$ y $n \text{ mod } 4$"

# ╔═╡ 4fd7e3a6-6919-4572-8b59-d205e1b2e91e
mod(n, 8)

# ╔═╡ d2f30f92-485a-4097-971d-82a9e6e769e2
mod(n, 4)

# ╔═╡ 472aa319-9f85-480a-8fe1-21e16e40d74d
md"Por tanto, para $p > 2$, nos encontraremos en el caso en el que uno de ellos ambos son impares y uno de ellos, n, $n \equiv 1 \text{ mod } 4$"

# ╔═╡ 90763f21-a853-4d80-898c-41d78ca54d6e
md"### p = 2"

# ╔═╡ 546739b8-5334-4733-a54d-ac415212cb57
md"Queremos calcular $\Big(\frac{2}{n}\Big)$. "

# ╔═╡ fe13bd86-f990-4e22-a576-735b78bc34a2
mod(n, 8)

# ╔═╡ 5f2e842f-a62a-4f7c-b299-ceeee16295cf
md"$\Rightarrow \Big(\frac{2}{n}\Big) = (-1)^{(n^2 -1)/8} = 1$"

# ╔═╡ d5fc863d-fdc4-4bc1-a281-98093211237c
md"### p = 3"

# ╔═╡ 0a66c417-b35e-48b8-b1f5-1f249fc16dc3
md"Ambos son impares "

# ╔═╡ bcfa05ea-369c-40cd-99eb-0b3b657fa8e0
mod(n, 4)

# ╔═╡ 10d00066-432c-420c-93ba-6902e128534f
md"Como uno de ellos, n, es $1\text{ mod } 4$, entonces $\Big(\frac{3}{n}\Big) = \Big(\frac{n}{3}\Big)$"

# ╔═╡ fbf982e6-5cb9-441c-8e02-75968faef70a
mod(n, 3)

# ╔═╡ a10680a1-ef2d-49e9-9313-b85b92d54857
md"Como $n \equiv 2 \text{ mod } 3, \Big(\frac{3}{n}\Big) = \Big(\frac{n}{3}\Big) = \Big(\frac{2}{3}\Big) = -1$"

# ╔═╡ 5bb2ed10-821a-44d3-8d33-ff9f62a3eaa3
md"### p = 5"

# ╔═╡ e7009fbe-859f-4220-9dd7-bd566b2e34e6
mod(5, 4)

# ╔═╡ 45727247-2e48-4b62-b478-21db799699ab
md"Ambos son impares, y uno de ellos (5) da congruente con 1 módulo 4, por lo que $\Big(\frac{5}{n}\Big) = \Big(\frac{n}{5}\Big)$"

# ╔═╡ c4c739ad-3785-414a-8ac5-3a97894057f6
mod(n, 5)

# ╔═╡ df319eb4-6c4f-418a-8fa0-47278f85ebd6
md"Como $n \equiv 1 \text{ mod } 5, \Big(\frac{5}{n}\Big) = \Big(\frac{n}{5}\Big) = \Big(\frac{1}{5}\Big) = 1$"

# ╔═╡ 1baa439c-9c37-45b2-bf33-53887b9ab638
md"### p = 7"

# ╔═╡ 9a19825c-b932-4e03-9e05-ed6ea3cb2002
md"Estamos en el mismo caso que antes, así que $\Big(\frac{7}{n}\Big) = \Big(\frac{n}{7}\Big)$"

# ╔═╡ f865a535-39d9-44b8-9232-fd963ce72287
mod(n, 7)

# ╔═╡ 5f1359db-bbf2-42c6-8140-23701c52c589
md"Entonces, $\Big(\frac{7}{n}\Big) = \Big(\frac{n}{7}\Big) = \Big(\frac{6}{7}\Big) = \Big(\frac{2}{7}\Big) \Big(\frac{3}{7}\Big) = 1 \cdot (-1) = -1$"

# ╔═╡ ea6d4df7-c41c-4037-a3a0-35279f7d530d
md"### p = 11"

# ╔═╡ 02b1b79c-0296-4d93-8cd2-c9fcaccfa34c
md"Misma situación: $\Big(\frac{11}{n}\Big) = \Big(\frac{n}{11}\Big)$"

# ╔═╡ 5ec35e25-1bea-4491-b523-daf4e2ed526d
mod(n, 11)

# ╔═╡ 629d8e0b-28e7-40fc-9b6e-d10759edcb1f
md"Y por lo tanto, $\Big(\frac{11}{n}\Big) = 1$"

# ╔═╡ 877b751d-921a-4f82-b39a-eae049862815
md"## Símbolo de Jacobi"

# ╔═╡ 516c0ed3-5106-4650-ad35-675168a0a5a3
md"Comprobaremos los resultados anteriores con el algoritmo proporcionado en los apuntes"

# ╔═╡ af5e9810-9a49-48fb-85de-82225d2b0ece
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

# ╔═╡ f563c8af-82ee-4b2e-8cfd-0b1b151dd7d7
with_terminal() do
	for a in [2, 3, 5, 7, 11]
		τ = simbolo_jacobi(a, n)
		println("El símbolo de Jacobi para a = ", a, ", m = ", n, " vale ", τ)
	end
end

# ╔═╡ ca8df1e0-fa82-434b-8e24-9f8c60cf5690
md"## Posibles primos de Euler"

# ╔═╡ d7ea76b8-a788-4237-a5ff-fb1fe4685420
posibles_primos = Vector{Int64}()

# ╔═╡ 12aa0271-fcec-4f14-86bf-f5d5bcf5ebdc
for a in [2, 3, 5, 7, 11]
	if powermod(a, n-1, n) == 1
		push!(posibles_primos, a)
	end
end

# ╔═╡ f9ebfc88-8623-46a2-bde5-de9b666cba77
md"Podemos ver que todos son posibles primos"

# ╔═╡ cce2601b-541c-4b64-95a1-28927356dced
posibles_primos

# ╔═╡ d6f01108-1b9c-49e3-89a5-51b09d6d07a1
md"""
Decimos que si n es primo, entonces $\big(\frac{a}{n}\big) \equiv a^{(n-1)/2}\text{ mod }n$
"""

# ╔═╡ d3591d04-d300-467c-9fdf-2b912e9e6130
posibles_primos_euler = Vector{Int64}()

# ╔═╡ 5392da90-c4d6-4723-b6f5-576e201edafc
with_terminal() do
	for a in posibles_primos
		jacobi = simbolo_jacobi(a, n)
		exponencial = powermod(a, div(n-1, 2), n)
		
		println("(", a, "/n) = ", jacobi, " =? ", exponencial, " = ", a, "^((n - 1)/2) mod n")

		if jacobi == exponencial
			push!(posibles_primos_euler, a)
		end
			
	end
end

# ╔═╡ f5199680-5116-4263-a8b1-40a3fb6f11c4
md"Por lo tanto, tenemos tres posibles primos de Euler:"

# ╔═╡ bcc7ff02-9639-4d16-9b2b-915acd87cd11
posibles_primos_euler

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
PlutoUI = "~0.7.34"
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
# ╟─328a2950-9343-11ec-28ec-7139a5c072a1
# ╠═71d06108-4871-4c8e-a1d2-fea490935048
# ╠═a61850f7-32bc-4463-9e28-9117ed578f8f
# ╟─777b4e82-d446-4e88-8a01-505d148a6371
# ╟─ff475c8f-5192-4821-ad48-cdd27519b1ee
# ╠═4fd7e3a6-6919-4572-8b59-d205e1b2e91e
# ╠═d2f30f92-485a-4097-971d-82a9e6e769e2
# ╟─472aa319-9f85-480a-8fe1-21e16e40d74d
# ╟─90763f21-a853-4d80-898c-41d78ca54d6e
# ╟─546739b8-5334-4733-a54d-ac415212cb57
# ╠═fe13bd86-f990-4e22-a576-735b78bc34a2
# ╟─5f2e842f-a62a-4f7c-b299-ceeee16295cf
# ╟─d5fc863d-fdc4-4bc1-a281-98093211237c
# ╟─0a66c417-b35e-48b8-b1f5-1f249fc16dc3
# ╠═bcfa05ea-369c-40cd-99eb-0b3b657fa8e0
# ╟─10d00066-432c-420c-93ba-6902e128534f
# ╠═fbf982e6-5cb9-441c-8e02-75968faef70a
# ╟─a10680a1-ef2d-49e9-9313-b85b92d54857
# ╟─5bb2ed10-821a-44d3-8d33-ff9f62a3eaa3
# ╠═e7009fbe-859f-4220-9dd7-bd566b2e34e6
# ╟─45727247-2e48-4b62-b478-21db799699ab
# ╠═c4c739ad-3785-414a-8ac5-3a97894057f6
# ╟─df319eb4-6c4f-418a-8fa0-47278f85ebd6
# ╟─1baa439c-9c37-45b2-bf33-53887b9ab638
# ╟─9a19825c-b932-4e03-9e05-ed6ea3cb2002
# ╠═f865a535-39d9-44b8-9232-fd963ce72287
# ╟─5f1359db-bbf2-42c6-8140-23701c52c589
# ╟─ea6d4df7-c41c-4037-a3a0-35279f7d530d
# ╟─02b1b79c-0296-4d93-8cd2-c9fcaccfa34c
# ╠═5ec35e25-1bea-4491-b523-daf4e2ed526d
# ╟─629d8e0b-28e7-40fc-9b6e-d10759edcb1f
# ╟─877b751d-921a-4f82-b39a-eae049862815
# ╠═516c0ed3-5106-4650-ad35-675168a0a5a3
# ╠═af5e9810-9a49-48fb-85de-82225d2b0ece
# ╠═f563c8af-82ee-4b2e-8cfd-0b1b151dd7d7
# ╟─ca8df1e0-fa82-434b-8e24-9f8c60cf5690
# ╠═d7ea76b8-a788-4237-a5ff-fb1fe4685420
# ╠═12aa0271-fcec-4f14-86bf-f5d5bcf5ebdc
# ╟─f9ebfc88-8623-46a2-bde5-de9b666cba77
# ╠═cce2601b-541c-4b64-95a1-28927356dced
# ╟─d6f01108-1b9c-49e3-89a5-51b09d6d07a1
# ╠═d3591d04-d300-467c-9fdf-2b912e9e6130
# ╠═5392da90-c4d6-4723-b6f5-576e201edafc
# ╟─f5199680-5116-4263-a8b1-40a3fb6f11c4
# ╠═bcc7ff02-9639-4d16-9b2b-915acd87cd11
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
