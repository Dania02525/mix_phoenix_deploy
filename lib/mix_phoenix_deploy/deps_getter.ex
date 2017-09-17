defmodule MixPhoenixDeploy.DepsGetter do
  import MixPhoenixDeploy.Helper

  def get_deps do
    with {:ok, _, 0} <- (SSHEx.run conn(), command(["cd", current_path(), "&&", "mix", "local.hex", "--force", "&&", "mix", "deps.get", "--only", "prod"]), exec_timeout: 30000)
    do
      {:ok, "Fetched application dependecies"}
    end
  end
end
