### A Pluto.jl notebook ###
# v0.18.0

using Markdown
using InteractiveUtils

# ╔═╡ 328a2950-9343-11ec-28ec-7139a5c072a1
md"""

# Ejercicio 2 

Dado tu número n de 8 cifras de la lista publicada.
1. Usa el algoritmo manual para calcular el símbolo de Jacobi ($\frac{p}{n}$), para p cada uno de los 5 primeros primos.
2. Si para alguna de esas bases tu número sale posible primo de Fermat, comprueba si además es posible primo de Euler.
3. ¿Es tu número n pseudoprimo de Fermat o de Euler para alguna de las bases?
"""

# ╔═╡ 71d06108-4871-4c8e-a1d2-fea490935048
m = 77432081

# ╔═╡ af5e9810-9a49-48fb-85de-82225d2b0ece
function simbolo_jacobi(a, n)
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

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.2"
manifest_format = "2.0"

[deps]
"""

# ╔═╡ Cell order:
# ╟─328a2950-9343-11ec-28ec-7139a5c072a1
# ╠═71d06108-4871-4c8e-a1d2-fea490935048
# ╠═af5e9810-9a49-48fb-85de-82225d2b0ece
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
