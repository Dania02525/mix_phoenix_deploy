defmodule MixPhoenixDeploy.Helper do

  def init_config(stage) do
    config_stage = read_config(stage)

    state = %{
      config: config_stage,
      conn: init_conn(config_stage)
    }

    {:ok, pid} = Agent.start_link(fn -> state end, name: __MODULE__)
    {:ok, "Deployer agent started with pid #{inspect pid}"}
  end

  def conn do
    Agent.get(__MODULE__, fn state -> state.conn end)
  end

  def config do
    Agent.get(__MODULE__, fn state -> state.config end)
  end

  def root_path do
    Path.join("/home/#{user()}/", config()["app_root"])
  end

  def current_path do
    Path.join(root_path(), "current")
  end

  def current_working_folder do
    Agent.get(__MODULE__, fn state -> state.current_working_folder end)
  end

  def put_current_working_folder(foldername) do
    Agent.update(__MODULE__, fn state -> Map.put(state, :current_working_folder, foldername) end)
  end

  def user do
    config()["user"]
  end

  def server(config_stage) do
    config_stage["server"]
  end

  def user(config_stage) do
    config_stage["user"]
  end

  def command(list, cmd \\ "") do
    build_command(list, cmd)
  end

  defp build_command([], cmd) do
    IO.puts "DEBUG: COMMAND: #{cmd}"
    String.to_charlist(cmd)
  end

  defp build_command([ h | t ], cmd) do
    build_command(t, cmd <> h <> " ")
  end

  def init_conn(config_stage) do
    with {:ok, conn} <- SSHEx.connect ip: server(config_stage), user: user(config_stage)
    do
      conn
    end
  end

  def read_config(stage) do
    map = 
      Path.join(application_root(), "deploy.yml")
      |> YamlElixir.read_from_file([])
    map[stage]
  end

  def application_root do
    Mix.Project.app_path()
    |> String.split("_build")
    |> List.first
  end
end
