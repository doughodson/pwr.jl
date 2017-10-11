using Documenter, pwr

push!(LOAD_PATH,"../src/")

makedocs()

deplydocs(
    deps   = Deps.pip("mkdocs", "python-markdown-math"),
    repo = "github.com/mwsohn/pwr.jl.git"
    julia  = "0.6",
    osname = "osx"
)
