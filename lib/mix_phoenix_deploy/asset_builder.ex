defmodule MixPhoenixDeploy.AssetBuilder do
  import MixPhoenixDeploy.Helper

  def build do
    if config()["build_brunch"] do
      build_assets()
    else
      {:ok, "Skipping brunch build"}
    end
  end

  defp build_assets do
    with {:ok, _, 0} <- (SSHEx.run conn(), command(["cd", current_path(), "&&", "brunch", "build", "--production"])),
         {:ok, _, 0} <- (SSHEx.run conn(), command(["cd", current_path(), "&&", "mix", "local.hex", "--force", "&&", "mix", "phx.digest"]))
    do
      {:ok, "Built static assets"}
    end
  end
end
