defmodule ElectionTest do
  use ExUnit.Case
  doctest Election

  test "updating election name" do
    election = %Election{}
    updated_election = Election.update(election, "n City Mayor")
    assert updated_election.name == "City Mayor"
  end

  test "adding a candidate" do
    election = %Election{}
    updated_election = Election.update(election, "a Jane Doe")
    assert Enum.any?(updated_election.candidates, fn c -> c.name == "Jane Doe" end)
  end

  test "voting for a candidate" do
    election = %Election{}
    election = Election.update(election, "a John Smith")
    candidate = hd(election.candidates)
    election = Election.update(election, "v #{candidate.id}")
    updated_candidate = Enum.find(election.candidates, fn c -> c.id == candidate.id end)
    assert updated_candidate.votes == 1
  end
end
