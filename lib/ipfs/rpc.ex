defmodule OcapRpc.Internal.IpfsRpc do
  @moduledoc """
  RPC request to ipfs server
  """
  use Tesla
  require Logger
  alias OcapRpc.Internal.Utils
  alias Tesla.Multipart

  @version "v0"
  @timeout Application.compile_env(:ocap_rpc, [:ipfs, :timeout], 240_000)

  # TODO(lei): when tesla not compatible issue solved: `https://github.com/teamon/tesla/issues/157`
  if Utils.env() not in [:test] do
    plug(Tesla.Middleware.Timeout, timeout: @timeout)
  end

  def call(method, _verb, args, opts \\ []) do
    %{hostname: hostname, port: port} = Application.get_env(:ocap_rpc, :ipfs)

    path = "http://#{hostname}:#{to_string(port)}/api/#{@version}/#{method}"

    {multipart, opts} = Keyword.pop(opts, :multipart)

    {args, mp} =
      case multipart do
        nil ->
          {args, ""}

        _ ->
          {multipart_args, args} = Enum.split_with(args, fn {k, _v} -> k in multipart end)

          mp =
            multipart_args
            |> Enum.reduce(
              Multipart.new(),
              fn {k, v}, acc ->
                Multipart.add_file_content(acc, v, "#{k}")
              end
            )

          {args, mp}
      end

    query = build_query(args, opts)
    url = "#{path}?#{query}"

    Logger.debug(fn -> "IPFS RPC request to POST for: #{inspect(url)}." end)

    # All IPFS RPC requests are POST
    result = post(url, mp)

    case result do
      {:ok, %{status: 200, body: body, headers: headers}} ->
        content_type = get_header(headers, "content-type")

        case content_type do
          "application/json" ->
            Jason.decode!(body)

          _ ->
            case Jason.decode(body) do
              {:ok, jason_body} -> jason_body
              {:error, _} -> body
            end
        end

      {:ok, %{status: status, body: body}} ->
        Logger.error("Status: #{status}. Result: #{inspect(body)}")
        raise RuntimeError

      {:error, reason} ->
        raise(
          "RPC call failed. Reason: #{inspect(reason)}, method: #{inspect(method)}, arguments: #{inspect(args)}"
        )

      e ->
        Logger.error(e)
        raise RuntimeError
    end
  end

  defp get_header(headers, name) do
    Enum.reduce_while(headers, nil, fn {k, v}, _acc ->
      if k === name, do: {:halt, v}, else: {:cont, nil}
    end)
  end

  defp build_query(args, opts) do
    l1 =
      args
      |> Stream.filter(fn {_, v} -> v != nil && v != "" end)
      |> Enum.map(fn {k, v} -> "#{to_dash_arg(k)}=#{v}" end)

    l2 = Enum.map(opts, fn {k, v} -> "#{to_dash_arg(k)}=#{v}" end)

    Enum.join(l1 ++ l2, "&")
  end

  defp to_dash_arg(k) do
    k |> Atom.to_string() |> String.replace("_", "-")
  end
end
