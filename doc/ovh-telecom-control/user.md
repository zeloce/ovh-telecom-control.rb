###### > [Source]

## Methods

- `new(client:, identifier:)`
- `delete`: Removes from all [Line]
- `client`: [Client]
- `identifier` (____): Phone number
- `status` (____): Returns [Integer]
  - `1` → `[ON]` (Active at least on _one_ [Line])
  - `0` → `[OFF]`
  - `-1` → `[Toggle]`
- `agents`: [Array] of [Agent]
- `to_s`: Returns [String]
  - `identifier`
- `to_h`: Returns [Hash]
  - `identifier`
  - `agents`: [Array] of [Agent] to [Hash]

[Source]: /lib/ovh-telecom-control/user.rb
[Client]: ovh-telecom-control/client.md
[Line]: ovh-telecom-control/line.md
[Agent]: ovh-telecom-control/agent.md
[Integer]: https://ruby-doc.org/core/Integer.html
[String]: https://ruby-doc.org/core/String.html
[Array]: https://ruby-doc.org/core/Array.html
[Hash]: https://ruby-doc.org/core/Hash.html
