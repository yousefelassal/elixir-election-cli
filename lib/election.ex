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

  @spec view_header(%Election{}) :: [String.t()]
  def view_header(election) do
    [
      "Election for: #{election.name}\n"
    ]
  end

  @spec view_body(%Election{}) :: [String.t()]
  def view_body(election) do
    election.candidates
    |> sort_candidates_by_votes()
    |> Enum.map(&format_candidate_line/1)
    |> (fn cands -> [format_header() | cands] end).()
  end

  defp sort_candidates_by_votes(candidates) do
    Enum.sort_by(candidates, & &1.votes, :desc)
  end

  defp format_candidate_line(%Candidate{id: id, name: name, votes: votes}) do
    "#{id}\t#{votes}\t#{name}\n"
  end

  defp format_header() do
    ["ID\tVotes\tName\n", "------------------\n"]
  end
end
