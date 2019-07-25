# frozen_string_literal: true

class OVHTelecomControl::Queue
  # Attributes ─────────────────────────────────────────────────────────────────

  attr_reader :client
  attr_reader :line
  attr_reader :identifier
  attr_reader :name
  attr_reader :agents

  # Creating ───────────────────────────────────────────────────────────────────

  def initialize(line:, identifier:)
    @client = line.client
    @line = line
    @identifier = identifier
    response = client.get(path)
    @name = response['description']
  end

  # Deleting ───────────────────────────────────────────────────────────────────

  def delete
    client.delete(path)
    line.queues.delete(self)
  end

  # Properties ─────────────────────────────────────────────────────────────────

  def name=(value)
    client.put(path, description: value)
    @name = value
  end

  # Resources ──────────────────────────────────────────────────────────────────

  def path
    line.path + 'hunting' + 'queue' + String(identifier)
  end

  def self.resource
    'hunting/queue'
  end

  def resource
    'hunting/queue/%{identifier}'
  end

  # Agent ──────────────────────────────────────────────────────────────────────

  def add_agent(agent, queue, position: agents.count + 1)
    # Example: https://api.ovh.com/console/#/telephony/{billingAccount}/easyHunting/{serviceName}/hunting/queue/{queueId}/agent#POST
    #<Pathname:/telephony/kl40243-ovh-1/ovhPabx/0033535547110/hunting/queue/242913/agent>
    #/telephony/{billingAccount}/ovhPabx/{serviceName}/hunting/agent/{agentId}/queue
    path = line.path + 'hunting' + 'agent' + String(agent.identifier) + 'queue'
    Rails.logger.debug(path)
    client.post(path, queueId: queue.identifier, position: position)
  end

  def remove_agent(agent, queue)
    # Example: https://api.ovh.com/console/#/telephony/{billingAccount}/easyHunting/{serviceName}/hunting/queue/{queueId}/agent/{agentId}#DELETE
    path = line.path + 'hunting' + 'agent' + String(agent.identifier) + 'queue' + String(queue.identifier)
    client.delete(path)
  end

  def set_agent(agent, position:)
    # Example: https://api.ovh.com/console/#/telephony/{billingAccount}/easyHunting/{serviceName}/hunting/queue/{queueId}/agent/{agentId}#PUT
    path = self.path + 'agent' + String(agent.identifier)
    client.put(path, position: position)
  end

  def get_agents
    # Example: https://api.ovh.com/console/#/telephony/{billingAccount}/easyHunting/{serviceName}/hunting/queue/{queueId}/agent#GET
    # Response:
    # Array of agent identifiers
    path = self.path + 'agent'
    identifiers = client.get(path)
    # Initialize an array filled with nil
    agents = Array.new identifiers.count
    # Fill agents by their position
    identifiers.each do |identifier|
      agent = line.agents.find do |agent|
        agent.identifier == identifier
      end
      # Example: https://api.ovh.com/console/#/telephony/{billingAccount}/easyHunting/{serviceName}/hunting/queue/{queueId}/agent/{agentId}#GET
      # Response:
      # agentId
      # queueId
      # position (Start: 1)
      path += String(identifier)
      response = client.get(path)
      index = response['position'] - 1
      agents[index] = agent
    end
    agents
  end

  alias agents get_agents

  # User ───────────────────────────────────────────────────────────────────────

  def add_user(user, queue, position: agents.count + 1)
    agent = user.agents.find { |agent| agent.line == line }
    add_agent(agent, queue)
  end

  def remove_user(user, queue)
    agent = user.agents.find { |agent| agent.line == line }
    remove_agent(agent, queue)
  end

  def set_user(user, position:)
    agent = user.agents.find { |agent| agent.line == line }
    set_agent(agent, position: position)
  end

  def get_users
    agents.map(&:to_user)
  end

  # /telephony/{billingAccount}/ovhPabx/{serviceName}/hunting/queue/{queueId}/liveCalls
  def get_live_calls
    path = self.path + 'liveCalls'
    live_calls = client.get(path)
    return live_calls
  end

  # GET /telephony/{billingAccount}/ovhPabx/{serviceName}/hunting/queue/{queueId}/liveCalls/{id}
  def get_live_call(id:)
    path = self.path + "liveCalls/#{id}"
    live_call = client.get(path)
    return live_call
  end

  alias users get_users

  # Exporting ──────────────────────────────────────────────────────────────────

  delegate :to_s, to: :identifier

  def to_h
    {
      identifier: identifier,
      name: name,
    }
  end
end
