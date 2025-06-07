#!/usr/bin/env julia
import Pkg
function ensure_dependencies(pkgs::Vector{String})
    for pkg in pkgs
        try
            @eval import $(Symbol(pkg))
        catch
            println("Installing $pkg...")
            Pkg.add(pkg)
            @eval import $(Symbol(pkg))
        end
    end
end
ensure_dependencies(["JSON","Printf","Unicode"])
using JSON
using Printf
using Unicode

replacements = Dict(
    "greaterThan" => ">",
    "lessThan"    => "<",
    "tilde"       => "~",
    "plus"        => "+",
    "minus"       => "-",
    "times"       => "*",
    "quote"       => "\"",
    "closecurly"       => "}",
    "opencurly"       => "{",
    "forwardSlash"       => "\\",
    "backwardSlash"       => "/",
    "backSlash"       => "/",
    "colon"       => ":",
    "backtick"       => "`",
    "dollar"       => "\$",
    "comma"        => ",",
    "openSquare"       => "[",
    "closeSquare"       => "[",
    "Dot"       => ".",
    "Percent" => "%",
    "questionMark" => "?",
)
data = JSON.parsefile("/home/wjmeyer/Documents/projects/en_us.json")
all_keys = collect(keys(data))
erasestr = join(["\u001b[1A\u001b[2K" for _ in 0:length(all_keys)])
while true
    for (i, key) in enumerate(all_keys)
       # println(i, ": ", data[key]["title"])
        println(@sprintf("%-3d: %s", i, data[key]["title"]))
    end
    line = readline()
    num = tryparse(Int, line)
    if isnothing(num) break end 

    print(erasestr)
    curr_key = all_keys[num]

    erasestr2 = join(["\u001b[1A\u001b[2K" for _ in -2:length(keys(data[curr_key]["commands"]))])
    println(data[curr_key]["title"],"\n")
    for curr_cmd in keys(data[curr_key]["commands"])
        cmdp = curr_cmd
        for (word, symbol) in replacements
            cmdp = replace(cmdp, word => symbol)
            cmdp = replace(cmdp, uppercasefirst(word) => symbol)
        end
        println(@sprintf("\t%-20s",cmdp), "\t", data[curr_key]["commands"][curr_cmd])
    end
    if readline() == "q" break end
    print(erasestr2)
end
