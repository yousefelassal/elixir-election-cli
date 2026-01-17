defmodule ElectionTest do
  use ExUnit.Case
  doctest Election

  setup do
    election = %Election{}
    {:ok, election: election}
  end

  test "updating election name", ctx do
    updated_election = Election.update(ctx.election, "n City Mayor")
    assert updated_election.name == "City Mayor"
  end

  test "adding a candidate", ctx do
    updated_election = Election.update(ctx.election, "a Jane Doe")
    assert Enum.any?(updated_election.candidates, fn c -> c.name == "Jane Doe" end)
  end

  test "voting for a candidate", ctx do
    election = ctx.election
    election = Election.update(election, "a John Smith")
    candidate = hd(election.candidates)
    election = Election.update(election, "v #{candidate.id}")
    updated_candidate = Enum.find(election.candidates, fn c -> c.id == candidate.id end)
    assert updated_candidate.votes == 1
  end
end
