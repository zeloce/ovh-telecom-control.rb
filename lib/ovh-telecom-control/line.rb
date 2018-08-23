require 'celluloid/current'

class OVHTelecomControl::Line

  Types = %w[
    easyHunting
    easyPabx
    miniPabx
    ovhPabx
  ]

  # Attributes ─────────────────────────────────────────────────────────────────

  attr_reader :client
  attr_reader :type
  attr_reader :identifier
  attr_reader :name
  attr_reader :agents
  attr_reader :queues

  # Creating ───────────────────────────────────────────────────────────────────

  def initialize(client:, identifier:)
    @client = client
    @identifier = identifier
    # For each line type,
    # Get: /telephony/{type}/{identifier}
    # Error → Next
    # Success → Break
    #
    # Example: https://api.ovh.com/console/#/telephony/{billingAccount}/easyHunting/{serviceName}#GET
    #
    # Why: new(client:, identifier:)
    # Instead of: new(client:, type:, identifier:)
    #
    # Because {identifier} corresponds to a line – which is unique –
    # and {type} an implementation detail.
    matching_line = Types.find do |type|
      path = client.path + resource % {
        type: type,
        identifier: identifier
      }
      client.get(path) do |message, error|
        next if error
        @type = type
        @name = message['description']
      end
    end
    unless matching_line
      raise "No matching line for identifier: #{identifier}"
    end
    @agents = get_agents
    @queues = get_queues
  end

  # Properties ─────────────────────────────────────────────────────────────────

  def name= value
    client.put(path, description: value)
    @name = value
  end

  # Resources ──────────────────────────────────────────────────────────────────

  def path
    client.path + type + String(identifier)
  end

  def self.resource
    '%{type}'
  end

  def resource
    '%{type}/%{identifier}'
  end

  # Agent ──────────────────────────────────────────────────────────────────────

  def create_agent number:
    # Example: https://api.ovh.com/console/#/telephony/{billingAccount}/easyHunting/{serviceName}/hunting/agent#POST
    path = self.path + OVHTelecomControl::Agent.resource
    parameters = {
      number: number,
      simultaneousLines: 1,
      status: :loggedOut,
      timeout: 20,
      wrapUpTime: 20
    }
    response = client.post(path, parameters)
    agent = OVHTelecomControl::Agent.new(line: self, identifier: response['agentId'])
    agents << agent
    agent
  end

  def get_agents
    # Example: https://api.ovh.com/console/#/telephony/{billingAccount}/easyHunting/{serviceName}/hunting/agent#GET
    # Response:
    # Array of agent identifiers
    path = self.path + OVHTelecomControl::Agent.resource
    identifiers = client.get(path)
    futures = identifiers.map do |identifier|
      Celluloid::Future.new(identifier) do |identifier|
        OVHTelecomControl::Agent.new(line: self, identifier: identifier)
      end
    end
    futures.map(&:value)
  end

  # Queue ──────────────────────────────────────────────────────────────────────

  def create_queue name:
    # Example: https://api.ovh.com/console/#/telephony/{billingAccount}/easyHunting/{serviceName}/hunting/queue#POST
    path = self.path + OVHTelecomControl::Queue.resource
    parameters = {
      description: name,
      strategy: :sequentiallyByAgentOrder
    }
    response = client.post(path, parameters)
    queue = OVHTelecomControl::Queue.new(line: self, identifier: response['queueId'])
    queues << queue
    queue
  end

  def get_queues
    # Example: https://api.ovh.com/console/#/telephony/{billingAccount}/easyHunting/{serviceName}/hunting/queue#GET
    # Response:
    # Array of queue identifiers
    path = self.path + OVHTelecomControl::Queue.resource
    identifiers = client.get(path)
    futures = identifiers.map do |identifier|
      Celluloid::Future.new(identifier) do |identifier|
        OVHTelecomControl::Queue.new(line: self, identifier: identifier)
      end
    end
    futures.map(&:value)
  end

  # Exporting ──────────────────────────────────────────────────────────────────

  def to_s
    identifier.to_s
  end

  def to_h
    {
      type: type,
      identifier: identifier,
      name: name,
      agents: agents.map(&:to_h),
      queues: queues.map(&:to_h),
    }
  end

  # Helpers ────────────────────────────────────────────────────────────────────

  def self.types
    telephony = JSON.parse `curl --silent --show-error --location https://api.ovh.com/1.0/telephony.json`
    types = telephony['apis'].reduce([]) do |list, api|
      path = api['path']
      match = /^.telephony.{billingAccount}.(.+).{serviceName}.hunting$/.match(path)
      list + if match
        [$1]
      else
        []
      end
    end
  end

end
