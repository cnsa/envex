defmodule EnvexTest do
  use ExSpec, async: false
  doctest Envex

  describe "Base" do
    context "endpoint" do
      it "endpoint" do
        assert :key = Envex.endpoint(:some)
      end

      it "endpoint map" do
        assert [some: :key] = Envex.endpoint_map(:map)
      end
    end

    context "getters" do
      it "get" do
        assert Some = Envex.get(:some)
      end

      it "map" do
        assert [some: :key] = Envex.map(:map)
      end
    end

    context "namespace getters" do
      it "get at namespace" do
        assert %{some: :key} = Envex.get({:other, :map})
      end

      it "map at namespace" do
        assert Some = Envex.map({:other, :some})
      end
    end

    context "integer" do
      it "integer" do
        assert 5 = Envex.integer(:integer)
      end

      it "integer map" do
        assert [other: "", some: 5] = Envex.integer_map(:integer_map)
      end
    end

    context "boolean" do
      it "boolean" do
        assert true = Envex.boolean(:boolean)
      end

      it "boolean map" do
        assert [other: "", some: true] = Envex.boolean_map(:boolean_map)
      end

      it "boolean map at endpoint" do
        assert [other: "", some: true] = Envex.boolean_map({Some, :boolean_map})
      end
    end
  end
end
