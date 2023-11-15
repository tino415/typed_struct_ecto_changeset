defmodule TypedStructEctoChangesetTest do
  use ExUnit.Case

  defmodule MyApp.EctoTypeAny do
    use Ecto.Type

    def type, do: :any

    def cast(value), do: {:ok, value}

    def load(value), do: {:ok, value}

    def dump(value), do: {:ok, value}
  end

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
      field :decimal1, Decimal.t()
      field :date1, Date.t()
      field :time1, Time.t()
      field :datetime1, DateTime.t()
      field :datetime2, NaiveDateTime.t()
      field :any1, any()
      field :custom_type, MyApp.EctoTypeAny
      field :term1, term()
      field :list1, [integer()]
      field :list2, [String.t()]
      field :list3, [any()]
      field :list4, [term()]
      field :struct1, %TypedStructEctoChangesetTest.Struct{}
      field :struct2, TypedStructEctoChangesetTest.Struct.t()
    end
  end

  defmodule SampleUsec do
    @moduledoc false

    use TypedStruct

    typedstruct do
      plugin TypedStructEctoChangeset, usec_times: true

      field :time1, Time.t()
      field :datetime1, DateTime.t()
      field :datetime2, NaiveDateTime.t()
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

  test "Decimal.t() format" do
    assert Map.get(Sample.__changeset__(), :decimal1) == :decimal
  end

  test "Date.t() format" do
    assert Map.get(Sample.__changeset__(), :date1) == :date
  end

  test "Time.t() format" do
    assert Map.get(Sample.__changeset__(), :time1) == :time
  end

  test "DateTime.t() format" do
    assert Map.get(Sample.__changeset__(), :datetime1) == :datetime
  end

  test "NaiveDateTime.t() format" do
    assert Map.get(Sample.__changeset__(), :datetime2) == :naive_datetime
  end

  test "any() format is a :map" do
    assert Map.get(Sample.__changeset__(), :any1) == :map
  end

  test "custom_type format is a CustomType" do
    assert Map.get(Sample.__changeset__(), :custom_type) ==
             TypedStructEctoChangesetTest.MyApp.EctoTypeAny
  end

  test "term() format is a :map" do
    assert Map.get(Sample.__changeset__(), :term1) == :map
  end

  test "[integer()] format is an {:array, :integer}" do
    assert Map.get(Sample.__changeset__(), :list1) == {:array, :integer}
  end

  test "[String.t()] format is an {:array, :string}" do
    assert Map.get(Sample.__changeset__(), :list2) == {:array, :string}
  end

  test "[any()] format is an {:array, :map}" do
    assert Map.get(Sample.__changeset__(), :list3) == {:array, :map}
  end

  test "[term()] format is an {:array, :map}" do
    assert Map.get(Sample.__changeset__(), :list4) == {:array, :map}
  end

  test "struct using %{} format" do
    assert Map.get(Sample.__changeset__(), :struct1) == TypedStructEctoChangesetTest.Struct
  end

  test "struct using .t() format" do
    assert Map.get(Sample.__changeset__(), :struct2) == TypedStructEctoChangesetTest.Struct
  end

  test "Time.t() format with usec option" do
    assert Map.get(SampleUsec.__changeset__(), :time1) == :time_usec
  end

  test "DateTime.t() format with usec option" do
    assert Map.get(SampleUsec.__changeset__(), :datetime1) == :datetime_usec
  end

  test "NaiveDateTime.t() format with usec option" do
    assert Map.get(SampleUsec.__changeset__(), :datetime2) == :naive_datetime_usec
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
