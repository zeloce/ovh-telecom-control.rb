###### > [Source]

## Methods

- `new(line:, identifier:)`
- `delete`: Removes from [Line]
- `client`: [Client]
- `line`: [Line]
- `identifier`
- `name` (Editable)
- `agents`: [Array] of [Agent]
- `users`: [Array] of [User]
- `path`: [Path]
- `self.resource`: `hunting/agent`
- `resource`: `hunting/agent/%{identifier}`
- `add_agent(agent, position: -1)`
- `remove_agent(agent)`
- `set_agent(agent, position:)`
- `add_user(user, position: -1)`
- `remove_user(user)`
- `set_user(user, position:)`
- `to_s`: Returns [String]
  - `identifier`
- `to_h`: Returns [Hash]
  - `identifier`
  - `name`

[Source]: /lib/ovh-telecom-control/queue.rb
[Client]: ovh-telecom-control/client.md
[Line]: ovh-telecom-control/line.md
[Agent]: ovh-telecom-control/agent.md
[User]: ovh-telecom-control/user.md
[String]: https://ruby-doc.org/core/String.html
[Array]: https://ruby-doc.org/core/Array.html
[Hash]: https://ruby-doc.org/core/Hash.html
[Path]: https://ruby-doc.org/stdlib/libdoc/pathname/rdoc/Pathname.html
