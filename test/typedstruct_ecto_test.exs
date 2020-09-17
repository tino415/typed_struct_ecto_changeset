defmodule TypedStructEctoChangesetTest do
  use ExUnit.Case

  defmodule Struct do
    @moduledoc false

    @type t() :: %__MODULE__{}

    defstruct [:password, :login]
  end

  defmodule Sample do
    @moduledoc false

    use TypedStruct

    typedstruct do
      plugin TypedStructEctoChangeset

      field :integer1, integer()
      field :integer2, :integer
      field :binary, binary()
      field :string1, :string
      field :string2, String.t()
      field :struct1, %TypedStructEctoChangesetTest.Struct{}
      field :struct2, TypedStructEctoChangesetTest.Struct.t()
    end
  end

  test "integer using function spec format" do
    assert Map.get(Sample.__changeset__(), :integer1) == :integer
  end

  test "integer using atom format" do
    assert Map.get(Sample.__changeset__(), :integer2) == :integer
  end

  test "binary using function spec format" do
    assert Map.get(Sample.__changeset__(), :binary) == :binary
  end

  test "string using atom format" do
    assert Map.get(Sample.__changeset__(), :string1) == :string
  end

  test "string using .t() format" do
    assert Map.get(Sample.__changeset__(), :string2) == :string
  end

  test "struct using %{} format" do
    assert Map.get(Sample.__changeset__(), :struct1) == TypedStructEctoChangesetTest.Struct
  end

  test "struct using .t() format" do
    assert Map.get(Sample.__changeset__(), :struct2) == TypedStructEctoChangesetTest.Struct
  end

  test "cast with ecto" do
    changeset =
      Ecto.Changeset.cast(
        %TypedStructEctoChangesetTest.Sample{},
        %{"integer1" => 3, "string2" => "Hello world"},
        [:integer1, :string2]
      )

    assert Ecto.Changeset.get_change(changeset, :integer1) == 3
    assert Ecto.Changeset.get_change(changeset, :string2) == "Hello world"
  end
end
