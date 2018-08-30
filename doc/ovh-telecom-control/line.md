###### > [Source]

## Methods

- `new(client:, identifier:)`
- `client`: [Client]
- `type`
- `identifier`
- `name` (Editable)
- `agents`: [Array] of [Agent]
- `queues`: [Array] of [Queue]
- `path`: [Path]
- `self.resource`: `%{type}`
- `resource`: `%{type}/%{identifier}`
- `create_agent(number:)`
- `create_queue(name:)`
- `to_s`: Returns [String]
  - `identifier`
- `to_h`: Returns [Hash]
  - `type`
  - `identifier`
  - `name`
  - `agents`: [Array] of [Agent] to [Hash]
  - `queues`: [Array] of [Queue] to [Hash]

[Source]: /lib/ovh-telecom-control/line.rb
[Client]: ovh-telecom-control/client.md
[Agent]: ovh-telecom-control/agent.md
[Queue]: ovh-telecom-control/queue.md
[String]: https://ruby-doc.org/core/String.html
[Array]: https://ruby-doc.org/core/Array.html
[Hash]: https://ruby-doc.org/core/Hash.html
[Path]: https://ruby-doc.org/stdlib/libdoc/pathname/rdoc/Pathname.html
