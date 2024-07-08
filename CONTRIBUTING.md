# Contributing

Pull requests and issues are welcome.

## TODOs

- Implement ranges for `Timestamp64`
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
