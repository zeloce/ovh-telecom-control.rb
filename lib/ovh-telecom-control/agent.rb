class OVHTelecomControl::Agent

  # Attributes ─────────────────────────────────────────────────────────────────

  attr_reader :client
  attr_reader :line
  attr_reader :identifier
  attr_reader :number
  attr_reader :status
  attr_reader :queues

  # Creating ───────────────────────────────────────────────────────────────────

  def initialize(line:, identifier:)
    @client = line.client
    @line = line
    @identifier = identifier
    response = client.get(path)
    @number = response['number']
    @status = response['status'] == 'available' ? 1 : 0
  end

  # Deleting ───────────────────────────────────────────────────────────────────

  def delete
    client.delete(path)
    line.agents.delete(self)
  end

  # Properties ─────────────────────────────────────────────────────────────────

  def number= value
    client.put(path, number: value)
    @number = value
  end

  # Represent OVH’s internal status – which is a string – as a number
  #
  # [ON] → 1, available
  # [OFF] → 0, loggedOut
  # [Toggle] → -1
  def status= value
    on, off = [1, 'available'], [0, 'loggedOut']
    internal, external = case value
    when 1
      on
    when 0
      off
    when -1
      if status.zero?
        on
      else
        off
      end
    else
      raise "Invalid value: #{value}"
    end
    client.put(path, status: external)
    @status = internal
  end

  # Resources ──────────────────────────────────────────────────────────────────

  def path
    line.path + 'hunting' + 'agent' + String(identifier)
  end

  def self.resource
    'hunting/agent'
  end

  def resource
    'hunting/agent/%{identifier}'
  end

  # Queue ──────────────────────────────────────────────────────────────────────

  def get_queues
    # Example: https://api.ovh.com/console/#/telephony/{billingAccount}/easyHunting/{serviceName}/hunting/agent/{agentId}/queue#GET
    # Response:
    # Array of queue identifiers
    path = self.path + 'queue'
    identifiers = client.get(path)
    line.queues.select do |queue|
      identifiers.include? queue.identifier
    end
  end

  alias :queues :get_queues

  # Exporting ──────────────────────────────────────────────────────────────────

  def to_s
    identifier.to_s
  end

  def to_h
    {
      identifier: identifier,
      number: number,
      status: status
    }
  end

  def to_user
    OVHTelecomControl::User.new(client: client, identifier: number)
  end

end
