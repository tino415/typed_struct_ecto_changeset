# TypedStructEctoChangeset

A [plugin](https://hexdocs.pm/typed_struct/TypedStruct.Plugin.html)
to enable basic "embeds"
[Ecto.cast](https://hexdocs.pm/ecto/Ecto.Changeset.html#cast/4) support to the 
module created by the containing
[TypedStruct](https://hexdocs.pm/typed_struct/TypedStruct.html) macro.

## Example

If this module is defined:
  ```elixir
  defmodule TypedStructModule do
    use TypedStruct

    typedstruct do
      plugin TypedStructEctoChangeset

      field :age, integer()
      field :name, String.t()
    end
  end
  ```
Then we can:

      iex> Ecto.Changeset.cast(%TypedStructModule{}, %{"age" => 23, "name" => "John Doe"}, [:age, :name])
      %Ecto.Changeset{}

## Limitations

More database-centric fields such as [assoc](https://hexdocs.pm/ecto/Ecto.Changeset.html#cast_assoc/3) are not yet 
supported

## Example use cases of this plugin

* [`typed_struct_ctor`](https://hexdocs.pm/typed_struct_ctor/TypedStructCtor.html)
– Adds validating (`new` and `from`) constructor functions.
> Try the macro out in real time without having to install or write any of your own code.  
> All you need is a running instance of [Livebook](https://livebook.dev/)
>
> [![Run in Livebook](https://livebook.dev/badge/v1/blue.svg)](https://livebook.dev/run?url=https://github.com/withbelay/typed_struct_ctor/blob/main/try_it_out.livemd)


## Installation

Because this plugin supports the interface defined by the `TypedStruct` macro, installation assumes you've already
added that dependency.

While you can use the original [typed_struct](https://hex.pm/packages/typed_struct) library, it seems to no longer be 
maintained.  However, there is a fork [here](https://hex.pm/packages/typedstruct) that is quite active.

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `typed_struct_ecto_changeset` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    # Choose either of the following `TypedStruct` libraries
    # The original TypedStruct library
    {:typed_struct, "~> 0.3.0"},
      
    # Or the newer forked TypedStruct library
    {:typedstruct, "~> 0.5.2"},

    # And add this library  
    {:typed_struct_ecto_changeset, "~> 1.0.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/typed_struct_ecto_changeset](https://hexdocs.pm/typed_struct_ecto_changeset).
