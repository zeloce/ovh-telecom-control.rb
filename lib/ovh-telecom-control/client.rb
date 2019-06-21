# frozen_string_literal: true

require 'json'
require 'pathname'
require 'ovh-telecom-control/user'

class OVHTelecomControl::Client < OVHApi::Client
  # Attributes ─────────────────────────────────────────────────────────────────

  attr_reader :lines

  # Creating ───────────────────────────────────────────────────────────────────

  def initialize(application_key: nil, application_secret: nil, consumer_key: nil)
    super(
      application_key: application_key,
      application_secret: application_secret,
      consumer_key: consumer_key
    )
    @lines = get_lines
  end

  # Properties ─────────────────────────────────────────────────────────────────

  # Page: https://api.ovh.com/console/#/me#GET
  def identifier
    get('/me')['nichandle']
  end

  # Page: https://api.ovh.com/console/#/telephony#GET
  # Account is {identifier}-1
  def account
    get('/telephony').first
  end

  # Resources ──────────────────────────────────────────────────────────────────

  # Page: https://api.ovh.com/console/#/telephony/{billingAccount}#GET
  def path
    Pathname format(resource, identifier: account)
  end

  def self.resource
    '/telephony'
  end

  def resource
    '/telephony/%{identifier}'
  end

  # Request ────────────────────────────────────────────────────────────────────

  # Prototypes:
  # request(path, method, parameters)
  # request(path, method, parameters) block(message, error)
  def request(path, method, parameters, &block)
    body = parameters&.to_json
    response = super(path, method, body)
    message = if response.body == "null"
                "null"
              else
                JSON.parse(response.body) end
    code = response.code.to_i
    error = code != 200 && {
      path: path,
      method: method,
      parameters: parameters,
      code: code,
      message: message['message'],
    }
    if block
      block.(message, error)
    else
      if not error
        message
      else
        raise String(error)
      end
    end
  end

  def get(path, &block)
    request(path, 'GET', nil, &block)
  end

  def put(path, parameters, &block)
    request(path, 'PUT', parameters, &block)
  end

  def post(path, parameters, &block)
    request(path, 'POST', parameters, &block)
  end

  def delete(path, &block)
    request(path, 'DELETE', nil, &block)
  end

  # Line ───────────────────────────────────────────────────────────────────────

  def get_lines
    OVHTelecomControl::Line::Types.reduce([]) do |list, type|
      # Example: https://api.ovh.com/console/#/telephony/{billingAccount}/easyHunting#GET
      # Response:
      # Array of line identifiers
      path = self.path + format(OVHTelecomControl::Line.resource, type: type)
      identifiers = get(path)
      lines = identifiers.map do |identifier|
        OVHTelecomControl::Line.new(client: self, identifier: identifier)
      end
      list + lines
    end
  end

  # User ───────────────────────────────────────────────────────────────────────

  def get_users
    numbers = lines.map do |line|
      line.agents.map(&:number)
    end.flatten.uniq
    users = numbers.collect do |number|
      OVHTelecomControl::User.new(client: self, identifier: number)
    end
  end

  alias users get_users

  # Exporting ──────────────────────────────────────────────────────────────────

  delegate :to_s, to: :identifier

  def to_h
    {
      identifier: identifier,
      account: account,
      lines: lines.map(&:to_h),
      users: users.map(&:to_h),
    }
  end
end
