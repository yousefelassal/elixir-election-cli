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
    |> (fn cands -> [format_header() | cands] end).()
  end

  @spec sort_candidates_by_votes([%Candidate{}]) :: [%Candidate{}]
  defp sort_candidates_by_votes(candidates) do
    Enum.sort_by(candidates, & &1.votes, :desc)
  end

  @spec format_candidate_line(%Candidate{}) :: String.t()
  defp format_candidate_line(%Candidate{id: id, name: name, votes: votes}) do
    "#{id}\t#{votes}\t#{name}\n"
  end

  defp format_candidates([%Candidate{} | _] = candidates) do
    Enum.map(candidates, &format_candidate_line/1)
  end

  @spec format_header() :: [String.t()]
  defp format_header() do
    ["ID\tVotes\tName\n", "------------------\n"]
  end
end
