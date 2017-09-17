defmodule Mix.Tasks.Phoenix.Deploy do
  use Mix.Task
  import MixPhoenixDeploy.Helper

  @shortdoc "Deploys a phoenix application"

  def run([]) do
    raise "Stage was not specified, specify with -production or -development"
  end

  def run(args) do
    stage = args
      |> List.first
      |> String.replace_prefix("-", "")

    Application.ensure_all_started(:yaml_elixir)
    Application.ensure_all_started(:sshex)

    with {:ok, msg} <- init_config(stage),
         _ <- IO.puts(msg),
         {:ok, msg} <- MixPhoenixDeploy.FileStructurer.ensure_file_structure,
         _ <- IO.puts(msg),
         {:ok, msg} <- MixPhoenixDeploy.VersionManager.prepare_folders,
         _ <- IO.puts(msg),
         {:ok, msg} <- MixPhoenixDeploy.GitCloner.clone_repo,
         _ <- IO.puts(msg),
         {:ok, msg} <- MixPhoenixDeploy.SymLinker.symlink_current,
         _ <- IO.puts(msg),
         {:ok, msg} <- MixPhoenixDeploy.DepsGetter.get_deps,
         _ <- IO.puts(msg),
         {:ok, msg} <- MixPhoenixDeploy.Compiler.compile,
         _ <- IO.puts(msg),
         {:ok, msg} <- MixPhoenixDeploy.AssetBuilder.build,
         _ <- IO.puts(msg),
         {:ok, msg} <- MixPhoenixDeploy.DatabaseMigrator.migrate,
         _ <- IO.puts(msg),
         {:ok, msg} <- MixPhoenixDeploy.ServerStarter.restart,
         _ <- IO.puts(msg)
    do
      IO.puts "Successfully deployed and restarted application!"
    else
      err -> err
      IO.puts "Deploy FAILED! something went wrong: #{inspect err}"
    end
  end
end
