using ReduxImGui
using Documenter

makedocs(;
    modules=[ReduxImGui],
    authors="Yupei Qi <qiyupei@gmail.com>",
    repo="https://github.com/Gnimuc/ReduxImGui.jl/blob/{commit}{path}#L{line}",
    sitename="ReduxImGui.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://Gnimuc.github.io/ReduxImGui.jl",
        assets=String[],
    ),
    pages=[
       "Introduction" => "index.md",
       "API Reference" => "api.md",
    ],
)

deploydocs(;
    repo="github.com/Gnimuc/ReduxImGui.jl.git",
)
