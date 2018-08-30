class OVHTelecomControl::User

  # Attributes ─────────────────────────────────────────────────────────────────

  attr_reader :client
  attr_reader :identifier
  attr_reader :agents

  # Creating ───────────────────────────────────────────────────────────────────

  def initialize(client:, identifier:)
    @client = client
    @identifier = identifier
    @agents = client.lines.collect(&:agents).flatten.select do |agent|
      agent.number == identifier
    end
  end

  # Deleting ───────────────────────────────────────────────────────────────────

  def delete
    agents.each(&:delete)
  end

  # Properties ─────────────────────────────────────────────────────────────────

  def identifier= value
    agents.each do |agent|
      agent.number = value
    end
    @identifier = value
  end

  # Any active?
  def status
    if agents.any? { |agent| agent.status == 1 }
      1
    else
      0
    end
  end

  def status= value
    agents.each do |agent|
      agent.status = value
    end
  end

  # Line ───────────────────────────────────────────────────────────────────────

  def lines
    agents.collect(&:line)
  end

  # Queue ──────────────────────────────────────────────────────────────────────

  def queues
    agents.collect(&:queues).flatten
  end

  # Exporting ──────────────────────────────────────────────────────────────────

  def to_s
    identifier.to_s
  end

  def to_h
    {
      identifier: identifier,
      agents: agents.map(&:to_h)
    }
  end

  def to_agent(line)
    agents.find do |agent|
      agent.line == line
    end
  end

end
