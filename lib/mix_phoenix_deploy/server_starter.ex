defmodule MixPhoenixDeploy.ServerStarter do
  import MixPhoenixDeploy.Helper

  def restart do
    with {:ok, pid, _} <- find_pid(),
         {:ok, _, 0} <- stop(pid),
         {:ok, _, 0} <- start()
    do
      {:ok, "(Re)started server"}
    end
  end

  defp start do
    SSHEx.run conn(), command(["cd", current_path(), "&&", config()["server_start_command"]])
  end

  defp stop("") do
    {:ok, :noop, 0}
  end

  defp stop(pid) do
    SSHEx.run conn(), command(["sudo", "kill", "-9", pid])
  end

  def find_pid do
    SSHEx.run conn(), command(["sudo", "lsof", "-t", "-i:#{port()}"])
  end

  def port do
    config()["port"]
  end
end
