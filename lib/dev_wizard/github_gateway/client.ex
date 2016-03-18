defmodule DevWizard.GithubGateway.Client do
  require Logger
  alias DevWizard.GithubGateway.Cache

  defstruct(tentacat: nil)

  def new(gh_access_token) do
    tentacat = Tentacat.Client.new(%{access_token: gh_access_token})
    %DevWizard.GithubGateway.Client{tentacat: tentacat}
  end

  def me(client) do
    Tentacat.Users.me(client.tentacat)
  end

  def member_of_org?(client, org, username) do
    {req_status, _} = Tentacat.Organizations.Members.member?(org, username, client.tentacat)

    case req_status do
      204 -> true
      _   -> false
    end
  end

  def filter_issues(client, org, repo, filters) do
    Tentacat.Issues.filter(org, repo, filters, client.tentacat)
  end

  def comments(client, org, repo, issue)  do
    Tentacat.Issues.Comments.list(org, repo, issue, client.tentacat)
  end
end