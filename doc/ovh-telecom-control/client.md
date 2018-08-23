###### > [Source](/lib/ovh-telecom-control/client.rb)

## Methods

- `new(application_key: nil, application_secret: nil, consumer_key: nil)`
  - [application-key]
  - [application-secret]
  - [consumer-key]
- `identifier`
- `account`
- `lines`: [Array] of [Line]
- `users`: [Array] of [User]
- `path`: [Path]
- `self.resource`: `/telephony`
- `resource`: `/telephony/%{identifier}`
- `request(path, method, parameters)`
- `request(path, method, parameters) block(message, error)`
- `get(path)`: _GET_ method
- `get(path) block(message, error)`
- `put(path, parameters)`: _PUT_ method
- `put(path, parameters) block(message, error)`
- `post(path, parameters)`: _POST_ method
- `post(path, parameters) block(message, error)`
- `delete(path)`: _DELETE_ method
- `delete(path) block(message, error)`
- `to_s`: Returns [String]
  - `identifier`
- `to_h`: Returns [Hash]
  - `identifier`
  - `account`
  - `lines`: [Array] of [Line] to [Hash]
  - `users`: [Array] of [User] to [Hash]

[Line]: ovh-telecom-control/line.md
[User]: ovh-telecom-control/user.md
[String]: https://ruby-doc.org/core/String.html
[Array]: https://ruby-doc.org/core/Array.html
[Hash]: https://ruby-doc.org/core/Hash.html
[Path]: https://ruby-doc.org/stdlib/libdoc/pathname/rdoc/Pathname.html
[application-key]: https://rubydoc.info/gems/ovh-api/OVHApi/Client#application_key-instance_method
[application-secret]: https://rubydoc.info/gems/ovh-api/OVHApi/Client#application_secret-instance_method
[consumer-key]: https://rubydoc.info/gems/ovh-api/OVHApi/Client#consumer_key-instance_method
