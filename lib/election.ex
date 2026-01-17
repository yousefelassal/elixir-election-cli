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
    |> Enum.sort_by(& &1.votes, :desc)
    |> Enum.map(fn %{id: id, name: name, votes: votes} ->
      "#{id}\t#{votes}\t#{name}\n"
    end)
    |> (fn cands -> ["ID\tVotes\tName\n", "------------------\n" | cands] end).()
  end
end
