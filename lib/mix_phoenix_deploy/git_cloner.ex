defmodule MixPhoenixDeploy.GitCloner do
  import MixPhoenixDeploy.Helper

  def clone_repo do
    with {:ok, _, 0} <- (SSHEx.run conn(), command(["cd", current_working_folder(), "&&", "git", "clone", config()["repo_target"], "."]), exec_timeout: 30000)
    do
      {:ok, "Cloned repo into #{current_working_folder()}"}
    end
  end
end
