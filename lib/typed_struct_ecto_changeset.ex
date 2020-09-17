defmodule TypedStructEctoChangeset do
  @moduledoc """
  TypedStruct plugin to integrate ecto changeset, allow
  to use typedstrcut module like ecto schema module when casting
  changeset, embeds and assoc are not yet supported, but you can use
  `Ecto.Type` implementation instead

  Module worsk by generating __changeset__ that returns field types
  and is used by `Ecto.Changeset.cast` to cast types
  """
  use TypedStruct.Plugin

  defmacro init(_opts) do
    quote do
      Module.register_attribute(__MODULE__, :changeset_fields, accumulate: true)
    end
  end

  def field(name, type, _opts) do
    quote do
      @changeset_fields {unquote(name), unquote(spec_to_type(type))}
    end
  end

  defp spec_to_type(type) when is_atom(type) do
    type
  end

  defp spec_to_type(type) do
    case type do
      {:%, _, [{:__aliases__, _, _} = aliases, {:%{}, _, []}]} ->
        aliases

      {{:., _, [{:__aliases__, _, _path} = aliases, :t]}, _, []} ->
        build_in_aliases(aliases)

      {atom, _, []} ->
        atom
    end
  end

  defp build_in_aliases({:__aliases__, _, [:String]}), do: :string
  defp build_in_aliases(aliases), do: aliases

  def after_definition(_opts) do
    quote unquote: false do
      def __changeset__ do
        %{unquote_splicing(Macro.escape(@changeset_fields))}
      end
    end
  end
end
