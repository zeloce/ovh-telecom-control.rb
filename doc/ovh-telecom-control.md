###### > [Source](/lib/ovh-telecom-control.rb)

> [OVH] [Telecom][Telephony] [API] for Humans.

## Overview

Here’s a bird’s-eye view of [OVHTelecomControl] classes.

### Tree-view

- [Client]
  - [User]
  - [Line]
    - [Agent]
    - [Queue]

### Flat-view

- [Client]
- [Client] → [User]
- [Client] → [Line]
- [Client] → [Line] → [Agent]
- [Client] → [Line] → [Queue]

## Loading

``` ruby
require 'ovh-telecom-control'
```

[OVH]: https://ovh.com
[API]: https://api.ovh.com
[Telephony]: https://api.ovh.com/console/#/telephony
[OVHTelecomControl]: ovh-telecom-control
[Client]: ovh-telecom-control/client.md
[Line]: ovh-telecom-control/line.md
[Agent]: ovh-telecom-control/agent.md
[Queue]: ovh-telecom-control/queue.md
[User]: ovh-telecom-control/user.md
