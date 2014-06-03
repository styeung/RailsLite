require 'uri'

class Params
  # use your initialize to merge params from
  # 1. query string
  # 2. post body
  # 3. route params
  def initialize(req, route_params = {})
    @params = req.query_string.nil? ? {} : parse_www_encoded_form(req.query_string)
    @params = @params.merge(parse_www_encoded_form(req.body)) unless req.body.nil?
  end

  def [](key)
    @params[key]
  end

  def permit(*keys)
  end

  def require(key)
  end

  def permitted?(key)
  end

  def to_s
    @params.to_s
  end

  class AttributeNotFoundError < ArgumentError; end;

  private
  # this should return deeply nested hash
  # argument format
  # user[address][street]=main&user[address][zip]=89436
  # should return
  # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
  def parse_www_encoded_form(www_encoded_form)
    parsed_form = URI.decode_www_form(www_encoded_form)
    new_hash = {}

    parsed_form.each do |keys, value|
      keys = parse_key(keys)
      key_nest = {}
      while keys.any?
        val = key_nest.empty? ? value : key_nest
        key_nest = { keys.pop => val }
      end
      new_hash[key_nest.keys.first] = key_nest.values.first
    end
    
    new_hash
  end

  # this should return an array
  # user[address][street] should return ['user', 'address', 'street']
  def parse_key(key)
    key.split(/\]\[|\[|\]/)
  end
end
