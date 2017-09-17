defmodule MixPhoenixDeploy.Compiler do
  import MixPhoenixDeploy.Helper

  def compile do
    with {:ok, _, 0} <- (SSHEx.run conn(), command(["cd", current_path(), "&&", "mix", "local.rebar", "--force", "&&", "mix", "deps.compile"]), exec_timeout: 60000),
         {:ok, _, 0} <- (SSHEx.run conn(), command(["cd", current_path(), "&&", "mix", "compile"]), exec_timeout: 30000)
    do
      {:ok, "Compiled application and application dependecies"}
    end
  end
end
