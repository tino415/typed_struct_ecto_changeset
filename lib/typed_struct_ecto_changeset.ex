defmodule TypedStructEctoChangeset do
  @moduledoc """
  TypedStruct plugin to integrate ecto changeset, allow
  to use typedstrcut module like ecto schema module when casting
  changeset, embeds and assoc are not yet supported, but you can use
  `Ecto.Type` implementation instead

  Module worsk by generating __changeset__ that returns field types
  and is used by `Ecto.Changeset.cast` to cast types

  ## Examples

  if module exists:
  ```
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


  Supports as many Ecto types as possible including `:decimal`, `:date`,
  `:time`, `:datetime`, from their corresponding typespecs `Decimal.t()`, etc.

  Also converts `any()`, `term()` or `map()` types in field specifications
  to `:map`, and list types, like `[integer()]` to e.g. `{:array, :integer}`.

  You can supply a `:usec_times` option to the plugin. If the option is
  `true`, then `Time.t()`, `DateTime.t()` and `NaiveDateTime.t()` fields
  will produce the Ecto types `:time_usec`, `:datetime_usec` and
  `naive_datetime_usec`.
  """
  use TypedStruct.Plugin

  defmacro init(opts) do
    quote do
      Module.register_attribute(__MODULE__, :changeset_fields, accumulate: true)

      @usec_times unquote(opts) |> Keyword.get(:usec_times, false)
    end
  end

  def field(name, type, opts) do
    quote do
      @changeset_fields {unquote(name), unquote(spec_to_type(type, opts))}
    end
  end

  defp spec_to_type(:term, _opts), do: :map
  defp spec_to_type(:any, _opts), do: :map

  defp spec_to_type(type, _opts) when is_atom(type) do
    type
  end

  defp spec_to_type(type, opts) do
    case type do
      [array_type] ->
        {:array, spec_to_type(array_type, opts)}

      {:%, _, [{:__aliases__, _, _} = aliases, {:%{}, _, []}]} ->
        aliases

      {{:., _, [{:__aliases__, _, _path} = aliases, :t]}, _, []} ->
        build_in_aliases(aliases, opts)

      {atom, _, []} ->
        spec_to_type(atom, opts)
    end
  end

  # Support for more primitive types
  # https://hexdocs.pm/ecto/Ecto.Schema.html#module-primitive-types
  defp build_in_aliases({:__aliases__, _, [:String]}, _opts), do: :string
  defp build_in_aliases({:__aliases__, _, [:Decimal]}, _opts), do: :decimal
  defp build_in_aliases({:__aliases__, _, [:Date]}, _opts), do: :date
  defp build_in_aliases({:__aliases__, _, [:Time]}, opts) do
    if Keyword.get(opts, :usec_times, false) do
      :time_usec
    else
      :time
    end
  end
  defp build_in_aliases({:__aliases__, _, [:DateTime]}, opts) do
    if Keyword.get(opts, :usec_times, false) do
      :datetime_usec
    else
      :datetime
    end
  end
  defp build_in_aliases({:__aliases__, _, [:NaiveDateTime]}, opts) do
    if Keyword.get(opts, :usec_times, false) do
      :naive_datetime_usec
    else
      :naive_datetime
    end
  end
  defp build_in_aliases({:__aliases__, _, _} = aliases, _opts), do: aliases

  def after_definition(_opts) do
    quote unquote: false do
      def __changeset__ do
        %{unquote_splicing(Macro.escape(@changeset_fields))}
      end
    end
  end
end
