defmodule OcapRpc.Internal.Parser do
  @moduledoc """
  Private utility for generator
  """
  require Logger

  @doc """
  get the directory of priv/rpc
  """
  def get_dir(type), do: Application.app_dir(:ocap_rpc, "priv/rpc/#{type}")

  def read_main(type) do
    dir = get_dir(type)
    filename = Path.join(dir, "main.yml")

    data = read_one_file(filename)
    rpc = read_files(dir, data["rpc"])
    result = read_files(dir, data["result"])

    data
    |> Map.put("rpc", rpc)
    |> Map.put("result", merge_types(result))
    |> Map.take(["name", "doc", "rpc", "result"])
  end

  def parse_args(args) do
    Enum.map(args, &parse_arg/1)
  end

  def gen_args(args) do
    Enum.map(args, &gen_arg/1)
  end

  def build_doc(method_doc, required_args, optional_args) do
    args_doc = Enum.map_join(required_args, &build_arg_doc/1)
    options_doc = Enum.map_join(optional_args, &build_arg_doc/1)

    method_doc
    |> do_build_doc(args_doc, "## Parameters")
    |> do_build_doc(options_doc, "## Options")
  end

  def split_args(args) do
    required_args = Enum.filter(args, &get_required_arg/1)
    multipart_args = Enum.filter(args, &get_multipart_arg/1)
    optional_args = Enum.filter(args, &get_optional_arg/1)
    {required_args, multipart_args, optional_args}
  end

  def split_optional_args(args) do
    IO.inspect(args)
    Enum.split_with(args, &get_optional_arg/1)
  end

  # private functions
  defp read_files(dir, filenames) do
    filenames
    |> Enum.map(&read_one_file(dir, &1))
    |> List.flatten()
    |> Enum.reject(fn item -> is_nil(item) || (is_map(item) && map_size(item) == 0) end)
  end

  defp read_one_file(dir, name), do: read_one_file(Path.join(dir, name))

  defp read_one_file(filename) do
    case YamlElixir.read_from_file(filename) do
      {:ok, data} ->
        data

      {:error, err} ->
        Logger.error("Error when parsing file: #{filename}")
        raise err
    end
  end

  defp merge_types(types) do
    types = List.flatten(types)

    Enum.reduce(types, %{}, fn item, acc ->
      {k, v} = get_kv(item)
      Map.put(acc, k, update_type(acc, v))
    end)
  end

  defp update_type(types, item) do
    item
    |> Enum.map(fn item ->
      {k, v} = get_kv(item)

      result =
        case is_binary(v) and String.starts_with?(v, "@") do
          true ->
            Map.get(types, String.trim_leading(v, "@"))

          _ ->
            v
        end

      {String.to_atom(k), result}
    end)
  end

  defp get_kv(map), do: {get_one(map, :keys), get_one(map, :values)}
  defp get_one(map, type), do: List.first(apply(Map, type, [map]))

  defp parse_arg(%{"name" => name} = arg), do: %{arg | "name" => String.to_atom(name)}
  defp parse_arg(arg), do: String.to_atom(arg)

  defp gen_arg(%{"name" => name}), do: Macro.var(name, nil)
  defp gen_arg(arg), do: Macro.var(arg, nil)

  defp build_arg_doc(%{"name" => name, "desc" => desc}), do: "  - #{name}: #{desc}.\n"
  defp build_arg_doc(_), do: ""

  defp do_build_doc(existing, adding, title) do
    case adding do
      "" ->
        existing

      _ ->
        """
        #{existing}

        #{title}

        #{adding}
        """
    end
  end

  defp get_required_arg(%{"multipart" => true}), do: false
  defp get_required_arg(%{"required" => false}), do: false
  defp get_required_arg(_), do: true

  defp get_multipart_arg(%{"multipart" => true}), do: true
  defp get_multipart_arg(_), do: false

  defp get_optional_arg(%{"required" => false}), do: true
  defp get_optional_arg(_), do: false
end
