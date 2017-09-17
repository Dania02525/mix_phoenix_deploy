defmodule MixPhoenixDeploy.DatabaseMigrator do
  import MixPhoenixDeploy.Helper

  def migrate do
    with {:ok, _, 0} <- (SSHEx.run conn(), command(["cd", current_path(), "&&", "MIX_ENV=prod", "mix", "ecto.migrate"]), exec_timeout: 30000)
    do
      {:ok, "Migrated production database"}
    end
  end
end
