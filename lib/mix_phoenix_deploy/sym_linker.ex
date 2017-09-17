defmodule MixPhoenixDeploy.SymLinker do
  import MixPhoenixDeploy.Helper

  def symlink_current do
    with {:ok, _, 0} <- (SSHEx.run conn(), command(["rm", "-rf", current_path()])),
         {:ok, _, 0} <- (SSHEx.run conn(), command(["ln", "-s", current_working_folder(), current_path()]))
    do
      {:ok, "Symlinked current directory to #{current_working_folder()}"}
    end
  end
end
