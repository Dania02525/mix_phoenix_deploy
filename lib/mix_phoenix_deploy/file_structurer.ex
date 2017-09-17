defmodule MixPhoenixDeploy.FileStructurer do
  import MixPhoenixDeploy.Helper

  def ensure_file_structure do
    with {:ok, _, 0} <- (SSHEx.run conn(), command(["mkdir", "-p", root_path()]))
    do
      {:ok, "App directory exists at " <> config()["app_root"]}
    end
  end
end
