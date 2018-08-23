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

  def name= value
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

  def add_agent(agent, position: agents.count + 1)
    # Example: https://api.ovh.com/console/#/telephony/{billingAccount}/easyHunting/{serviceName}/hunting/queue/{queueId}/agent#POST
    path = self.path + 'agent'
    client.post(path, agentId: agent.identifier, position: position)
  end

  def remove_agent(agent)
    # Example: https://api.ovh.com/console/#/telephony/{billingAccount}/easyHunting/{serviceName}/hunting/queue/{queueId}/agent/{agentId}#DELETE
    path = self.path + 'agent' + String(agent.identifier)
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
      path = path + String(identifier)
      response = client.get(path)
      index = response['position'] - 1
      agents[index] = agent
    end
    agents
  end

  alias :agents :get_agents

  # User ───────────────────────────────────────────────────────────────────────

  def add_user(user, position: agents.count + 1)
    agent = user.agents.find { |agent| agent.line == line }
    add_agent(agent)
  end

  def remove_user(user)
    agent = user.agents.find { |agent| agent.line == line }
    remove_agent(agent)
  end

  def set_user(user, position:)
    agent = user.agents.find { |agent| agent.line == line }
    set_agent(agent, position: position)
  end

  def get_users
    agents.map(&:to_user)
  end

  alias :users :get_users

  # Exporting ──────────────────────────────────────────────────────────────────

  def to_s
    identifier.to_s
  end

  def to_h
    {
      identifier: identifier,
      name: name
    }
  end

end
