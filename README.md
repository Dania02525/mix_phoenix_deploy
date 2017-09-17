# MixPhoenixDeploy

**A capistrano-like deployment solution for Phoenix applications**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `mix_phoenix_deploy` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:mix_phoenix_deploy, "~> 0.1.0"}]
end
```

## Use
configure `deploy.yml` in your application root with a stage and the parameters as in 
the provided `deploy.yml.example

Now you can do command like deploys like this: 
```elixir
iex> mix phoenix.deploy -production
```

## Gotchas
* You must have elixir, erlang and git installed on remote server
* Your local private keyfile (in ~/.ssh) must be called id_rsa
* You will probably have to do a `sudo apt-get install build-essential` on remote server to compile deps with c code (bcrypt is a good example)
* Make sure your config/prod.exs imports from `/home/-deploy user-/-app root-/shared/prod.secret.exs`
* Make sure you have generated a private key on the remote server and added the public key to your git profile

## Todo
* pre and post deploy hooks
* rollback
