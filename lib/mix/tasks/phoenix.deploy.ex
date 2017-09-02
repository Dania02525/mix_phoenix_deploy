defmodule Mix.Tasks.Phoenix.Deploy do
  use Mix.Task

  @shortdoc "Deploys a phoenix application"

  def run(stage) do
    Application.ensure_all_started(:yaml_elixir)
    Application.ensure_all_started(:sshex)
    config = read_config()[stage]
    conn = SSHex.connect ip: server(config), user: user(config)
    run_predeploy_hook(config)
    ensure_file_structure(conn, config)
    check_old_versions(conn, config)
    clone_new_version(conn, config)
    symlink_current(conn, config)
    run_migrations(conn, config)
    restart_app(conn, config)
    run_postdeploy_hook(conn, config)
  end

  def server(config) do
    config[stage]["server"]
    |> String.to_char_list
  end

  def user(config) do
    config[stage]["user"]
    |> String.to_char_list
  end

  def ensure_file_structure(conn, config) do
    with {:ok, _, 0} <- SSHEx.run conn, command(["mkdir", "-p", config["app_root"]),
         {:ok, _, 0} <- SSHEx.run conn, command(["mkdir", "-p", Path.join(config["app_root"], "current")
    do
      IO.puts "App directory exists at " <> config["app_root"]
    end
  end

  def check_old_versions(conn, config) do
    {:ok, dirs, 0} = SSHex.run conn, command("find" config["app_root"] <> "/*", "-maxdepth", "0", "-type", "d")
    IO.puts "Found #{Enum.count(dirs) -1} existing versions"
    if Enum.count(dirs) > config["versions_to_keep"]
      remove_old_versions(conn, dirs)
    end
  end

  def remove_old_versions(conn, dirs) do

  end

  def command([], cmd) do
    String.to_char_list(cmd)
  end

  def command([ h | t ], cmd \\ "") do
    command(t, cmd <> h)
  end

  def read_config do
    IO.puts "parsing deploy.yml from project root"
    Path.join(Mix.Project.app_path(), "deploy.yml")
    |> YamlElixir.read_from_file([])
  end
end
