defmodule MixPhoenixDeploy.VersionManager do
  import MixPhoenixDeploy.Helper

  def prepare_folders do
    with {:ok, dirs, 0} <- find_release_dirs(),
         {:ok, rm_msg, 0} <- remove_old_versions(dirs),
         {:ok, _, 0} <- put_new_version()
    do
      {:ok, "Found #{Enum.count(dirs)} existing versions " <> rm_msg}
    end
  end

  defp remove_old_versions(dirs) do
    if Enum.count(dirs) > config()["versions_to_keep"] do
      oldest_version = 
        dirs
        |> Enum.sort
        |> List.first

      SSHEx.run conn(), command(["rm", "-rf", Path.join(root_path(), oldest_version)])
    else
      {:ok, "", 0}
    end
  end

  defp put_new_version do
    SSHEx.run conn(), command(["mkdir", "-p", new_version_folder()])
  end

  defp new_version_folder do
    with foldername <- Path.join(root_path(), timestamp_string()),
         :ok <- put_current_working_folder(foldername)
    do
      foldername
    end
  end

  defp timestamp_string do
    :os.system_time(:seconds)
    |> Integer.to_string()
  end

  defp find_release_dirs do
    case SSHEx.run conn(), command(["find", root_path() <> "/*", "-maxdepth", "0", "-type", "d", "-printf", "\'%f:\'"]) do
      {:ok, str, 0} ->
        dirs = str
          |> String.split(":")
          |> Enum.reject(fn dir -> dir == "" end)
          |> Enum.reject(fn dir -> dir =~ ~r/current$/ end)
          |> Enum.reject(fn dir -> dir =~ ~r/shared$/ end)

        {:ok, dirs, 0}
      {:ok, msg, 1} ->
        if msg =~ ~r/No such file/ do
          {:ok, [], 0}
        else
          {:error, msg, 1}
        end
    end
  end
end
