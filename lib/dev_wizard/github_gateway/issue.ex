defmodule DevWizard.GithubGateway.Issue do
  alias DevWizard.GithubGateway.{User, Comment, Milestone}

  @linked_issue_regex ~r/(closes|connects)\s+thinkthroughmath\/storyboard#([0-9]+)/i

  defstruct(
    assignee:       nil,
    body:           nil,
    closed_at:      nil,
    comments:       nil,
    comments_url:   nil,
    created_at:     nil,
    events_url:     nil,
    html_url:       nil,
    id:             nil,
    labels:         nil,
    labels_url:     nil,
    locked:         nil,
    milestone:      nil,
    number:         nil,
    pull_request:   nil,
    repository_url: nil,
    review_state:   nil,
    state:          nil,
    title:          nil,
    updated_at:     nil,
    url:            nil,
    user:           nil
  )

  use ExConstructor

  def to_struct(nil), do: nil

  def to_struct(values) do
    raw = new(values)

    %{ raw |
       :user     => User.to_struct(raw.user),
       :assignee => User.to_struct(raw.assignee),
       :comments => get_comments(raw.comments),
       :milestone => Milestone.to_struct(raw.milestone)
     }
  end

  # So, goofy alert
  # we want to add comments to the issue struct. However, because the
  # comments in the github API refers to the *number* of comments,
  # we need to make allowances for that state.
  defp get_comments(value) when is_number(value), do: []
  defp get_comments(value) when is_list(value), do: Enum.map(value, &Comment.to_struct/1)

  def linked_issue_number(issue) do
    matches = Regex.run(@linked_issue_regex, issue.body)

    if matches do
      {number, _} = List.last(matches) |> Integer.parse
      number
    end
  end
end
