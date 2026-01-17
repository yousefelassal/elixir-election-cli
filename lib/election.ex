defmodule Election do
  @moduledoc """
  Module representing an election with candidates.
  """

  defstruct(
    name: "Mayor",
    candidates: [
      Candidate.new(1, "Will Ferrell"),
      Candidate.new(2, "Kristen Wiig")
    ],
    next_id: 3
  )

  def run, do: %Election{} |> run()

  def run(election = %Election{}) do
    [IO.ANSI.clear(), IO.ANSI.home()] |> IO.write()

    election |> view |> IO.write
  end

  @doc """
  Creates a new Election struct with the given name.
  """
  @spec view_header(%Election{}) :: [String.t()]
  def view_header(election) do
    [
      "Election for: #{election.name}\n"
    ]
  end

  @doc """
  Returns the body of the election view, listing candidates sorted by votes.
  """
  @spec view_body(%Election{}) :: [String.t()]
  def view_body(election) do
    election.candidates
    |> sort_candidates_by_votes()
    |> format_candidates()
    |> prepend_candidate_header()
  end

  @doc """
  Returns the footer of the election view with available commands.
  """
  @spec view_footer() :: [String.t()]
  def view_footer() do
    [
      "\n",
      "commands: (n)ame <election>, (a)dd <candidate>, (v)ote <id>, (q)uit\n"
    ]
  end

  @doc """
  Returns the complete view of the election including header, body, and footer.
  """
  def view(election) do
    [
      view_header(election),
      view_body(election),
      view_footer()
    ]
  end

  @doc """
  Updates the election based on the given command string.
  """
  @spec update(%Election{}, String.t()) :: %Election{}
  def update(election, cmd) when is_binary(cmd) do
    update(election, String.split(cmd))
  end

  @spec update(%Election{}, [String.t()]) :: %Election{}
  def update(election, ["n" <> _ | args]) do
    name = Enum.join(args, " ") |> String.trim()
    Map.put(election, :name, name)
  end

  @spec update(%Election{}, [String.t()]) :: %Election{}
  def update(election, ["a" <> _ | args]) do
    name = Enum.join(args, " ") |> String.trim()
    candidate = Candidate.new(election.next_id, name)
    candidates = [candidate | election.candidates]
    %{election | candidates: candidates, next_id: election.next_id + 1}
  end

  def update(election, ["v" <> _ , id]) do
    vote(election, Integer.parse(id))
  end

  defp vote(election, {id, ""}) do
    candidates = Enum.map(election.candidates, &maybe_inc_vote(&1, id))
    %{election | candidates: candidates}
  end

  defp vote(election, :error), do: election

  defp maybe_inc_vote(candidate, id) when is_integer(id) do
    maybe_inc_vote(candidate, candidate.id == id)
  end

  defp maybe_inc_vote(candidate, false), do: candidate

  defp maybe_inc_vote(candidate, true) do
    Map.update!(candidate, :votes, &(&1 + 1))
  end

  @spec sort_candidates_by_votes([%Candidate{}]) :: [%Candidate{}]
  defp sort_candidates_by_votes(candidates) do
    Enum.sort_by(candidates, & &1.votes, :desc)
  end

  @spec format_candidate_line(%Candidate{}) :: String.t()
  defp format_candidate_line(%Candidate{id: id, name: name, votes: votes}) do
    "#{id}\t#{votes}\t#{name}\n"
  end

  @spec format_candidates([%Candidate{}]) :: [String.t()]
  defp format_candidates([%Candidate{} | _] = candidates) do
    Enum.map(candidates, &format_candidate_line/1)
  end

  @spec format_header() :: [String.t()]
  defp format_header() do
    ["ID\tVotes\tName\n", "------------------\n"]
  end

  @spec prepend_candidate_header([String.t()]) :: [String.t()]
  defp prepend_candidate_header(lines) do
    [format_header() | lines]
  end
end
