defmodule EnvexTest do
  use ExSpec, async: false
  doctest Envex

  describe "Base" do
    context "use" do
      it "endpoint" do
        assert :key = Envex.endpoint(:some)
      end

      it "endpoint map" do
        assert [some: :key] = Envex.endpoint_map(:map)
      end

      it "get" do
        assert [some: Some, map: %{some: :key}] = Envex.get(:other)
      end

      it "map" do
        assert [some: Some, map: %{some: :key}] = Envex.map(:other)
      end

      it "integer" do
        assert_raise ArgumentError, fn -> [some: Some, map: %{some: :key}] = Envex.integer(:other) end
      end

      it "integer map" do
        assert_raise ArgumentError, fn -> [some: Some, map: %{some: :key}] = Envex.integer_map(:other) end
      end
    end
  end
end
