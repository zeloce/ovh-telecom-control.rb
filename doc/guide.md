# Guide

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

Loading:

``` ruby
require 'ovh-telecom-control'
```

Initializing:

``` ruby
client = OVHTelecomControl::Client.new(
  application_key: ENV['OVH_APPLICATION_KEY'],
  application_secret: ENV['OVH_APPLICATION_SECRET'],
  consumer_key: ENV['OVH_CONSUMER_KEY']
)
```

Get a line:

``` ruby
line = client.lines.find do |line|
  line.identifier == ENV['OVH_TEST_LINE']
end
```

Add some data:

- `User` ([Hash])
  - [All Might] ([User])
  - [Tashigi] ([User])
  - [Eren] ([User])
  - [Father] ([User])

``` ruby
User = {}
User['All Might'] = line.create_agent(number: '0033100000000').to_user
User['Tashigi'] = line.create_agent(number: '0033111111111').to_user
User['Eren'] = line.create_agent(number: '0033122222222').to_user
User['Father'] = line.create_agent(number: '0033133333333').to_user
```

- `Queue` ([Hash])
  - `Week` ([Queue])
  - `Week-end` ([Queue])
  - `On-call` ([Queue])

``` ruby
Queue = {}
Queue['Week'] = line.create_queue(name: 'Week')
Queue['Week-end'] = line.create_queue(name: 'Week-end')
Queue['On-call'] = line.create_queue(name: 'On-call')
```

- `Queue`
  - `Week`
    - [All Might]
    - [Tashigi]
    - [Eren]
    - [Father]
  - `Week-end`
    - [All Might]
  - `On-call`
    - [All Might]

``` ruby
Queue['Week'].add_user User['All Might']
Queue['Week'].add_user User['Tashigi']
Queue['Week'].add_user User['Eren']
Queue['Week'].add_user User['Father']
```

``` ruby
Queue['Week-end'].add_user User['All Might']
```

``` ruby
Queue['On-call'].add_user User['All Might']
```

__Give [All Might] less work.__
Remove [All Might] from `Week` [Queue]:

``` ruby
Queue['Week'].remove_user User['All Might']
```

__Status: Retired.__
Set [All Might] off from all [Line]:

``` ruby
User['All Might'].status = 0
```

To turn-off on a specific [Line]:

``` ruby
User['All Might'].to_agent(line).status = 0
```

__Erase [Father] from the existence.__
Delete [Father] from all [Line]:

``` ruby
User['Father'].delete
```

To delete on a specific [Line]:

``` ruby
User['Father'].to_agent(line).delete
```

__Top ranking.__
Display [Agent] collection in `Week` [Queue]:

``` ruby
Queue['Week'].agents.each.with_index(1) do |agent, position|
  name, user = User.find do |name, user|
    user.identifier == agent.number
  end
  puts '[#%{position}] %{name} [#{status}]' % {
    name: name,
    position: position,
    status: agent.status == 1 ? 'ON' : 'OFF'
  }
end
```

__Note__

We use [Queue]#agents instead of [Queue]#users,
as [Agent]#status returns [Agent] status on the associated [Line] – that we want –
whereas [User]#status returns the way [User] is active on at least one [Line].

[OVHTelecomControl]: ovh-telecom-control.md
[Client]: ovh-telecom-control/client.md
[Line]: ovh-telecom-control/line.md
[Agent]: ovh-telecom-control/agent.md
[Queue]: ovh-telecom-control/queue.md
[User]: ovh-telecom-control/user.md
[Hash]: https://ruby-doc.org/core/Hash.html
[All Might]: http://bokunoheroacademia.wikia.com/wiki/Toshinori_Yagi
[Tashigi]: http://onepiece.wikia.com/wiki/Tashigi
[Eren]: http://attackontitan.wikia.com/wiki/Eren_Yeager
[Father]: http://fma.wikia.com/wiki/Father
