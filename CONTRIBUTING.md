# Contributing

Pull requests and issues are welcome.

## TODOs

- Support more dynamic formatting, not just 9 digits precision ISO 8601
- Better docs


## Building documentation

The documentation is built using [Documenter.jl](https://documenter.juliadocs.org/stable/).

To rebuild, run the following command from the root of the repository:

```bash
cd docs
julia --project --eval 'using Pkg; Pkg.resolve(); Pkg.instantiate()'
julia --project make.jl
```

To view the documentation locally, run:

```bash
cd docs
npx live-server ./build
```
