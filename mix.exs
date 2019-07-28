defmodule Sailor.MixProject do
  use Mix.Project

  def project do
    [
      app: :sailor,
      version: "0.1.0",
      elixir: "~> 1.9.0",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      compilers: [:ecma262] ++ Mix.compilers
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Sailor.Application, []},
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:salty, "~> 0.1.3", git: "https://github.com/the-kenny/libsalty.git", branch: "add-ed-to-curve-conversion-functions"},
      {:jason, "~> 1.1"},
      {:jsone, "~> 1.5"},
      {:sqlitex, "~> 1.7"},
      {:poolboy, "~> 1.5.2"},
      {:worker_pool, "~> 4.0"},
      {:gen_stage, "~> 0.14.2"},

      {:credo, "~> 1.0.0", only: [:dev, :test], runtime: false},
    ]
  end
end


defmodule Mix.Tasks.Compile.Ecma262 do
  def run(_args) do
    {result, _errcode} = System.cmd("gcc",
      ["--std=c99",
        "-O3",
        "-fpic",
        "-shared",
        "-o", "ecma262.so",
        "-I#{Path.join([:code.root_dir(), 'usr', 'include'])}",
        "-L#{Path.join([:code.root_dir(), 'usr', 'lib'])}",
        "-lei",
        "-flat_namespace",
        "-undefined", "suppress",
        "-lerl_interface",
        "-DIEEE_8087",
        "native_lib/dtoa.c",
        "native_lib/g_fmt.c",
        "native_lib/ecma262.c",
      ], stderr_to_stdout: true)
    IO.puts(result)
  end
end
