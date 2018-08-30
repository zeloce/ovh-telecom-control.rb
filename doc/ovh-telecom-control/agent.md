###### > [Source]

## Methods

- `new(line:, identifier:)`
- `delete`: Removes from [Line]
- `client`: [Client]
- `line`: [Line]
- `identifier`
- `number` (____)
- `status` (____): Returns [Integer]
  - `1` → `[ON]`
  - `0` → `[OFF]`
  - `-1` → `[Toggle]`
- `queues`: [Array] of [Queue]
- `path`: [Path]
- `self.resource`: `hunting/agent`
- `resource`: `hunting/agent/%{identifier}`
- `to_s`: Returns [String]
  - `identifier`
- `to_h`: Returns [Hash]
  - `identifier`
  - `number`
  - `status`
- `to_user`: Returns [User]

[Source]: /lib/ovh-telecom-control/agent.rb
[Client]: ovh-telecom-control/client.md
[Line]: ovh-telecom-control/line.md
[Queue]: ovh-telecom-control/queue.md
[User]: ovh-telecom-control/user.md
[Integer]: https://ruby-doc.org/core/Integer.html
[String]: https://ruby-doc.org/core/String.html
[Array]: https://ruby-doc.org/core/Array.html
[Hash]: https://ruby-doc.org/core/Hash.html
[Path]: https://ruby-doc.org/stdlib/libdoc/pathname/rdoc/Pathname.html
