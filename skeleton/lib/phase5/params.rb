require 'uri'

module Phase5
  class Params
    # use your initialize to merge params from
    # 1. query string
    # 2. post body
    # 3. route params
    def initialize(req, route_params = {})
      if req.query_string.nil?
        @params = {}
      else
        query_string = req.query_string
        request_body = req.body
        @params = route_params
        self.parse_www_encoded_form(query_string, request_body)
      end
    end

    def [](key)
      if key.is_a?(Symbol)
        @params[key.to_s]
      else
        @params[key]
      end
    end

    def to_s
      @params.to_json.to_s
    end

    class AttributeNotFoundError < ArgumentError; end;

    # private
    # this should return deeply nested hash
    # argument format
    # user[address][street]=main&user[address][zip]=89436
    # should return
    # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
    def parse_www_encoded_form(query_string, request_body)
      unless query_string.blank?
        if query_string[/[\[\]]/]
          decoded_query = parse_key(query_string)
          @params.merge!(self.transform_array(decoded_query))
        else
          decoded_query = URI::decode_www_form(query_string)
          decoded_query.each do |inner_array|
            @params[inner_array[0]] = inner_array[1]
          end
      end

      unless request_body.blank?
        if request_body[/[\[\]]/]
          decoded_body = parse_key(decoded_body)
          @params.merge!(self.transform_array(decoded_body))
        else
          decoded_body = URI::decode_www_form(request_body)
          decoded_body.each do |inner_array|
            @params[inner_array[0]] = inner_array[1]
          end
      end

      # unless query_string.blank?
#         decoded_query = URI::decode_www_form(query_string)
#         decoded_array.each do |inner_array|
#           @params[inner_array[0]] = inner_array[1]
#         end
#       end
    end

    # this should return an array
    # user[address][street] should return ['user', 'address', 'street']
    def parse_key(key)
      key.split(/\]\[|\[|\]|&/)
    end

    def transform_array(array)
      original_hash = {}
      current_hash = original_hash

      array.each_with_index do |x, index|
        p x
        if x.include?("=")
          current_hash = original_hash
        elsif index < array.length-1 && array[index + 1].include?("=")
          current_hash[x] = array[index + 1][1..-1]
        else
          if current_hash.keys.include?(x)
            current_hash = current_hash[x]
          else
            current_hash[x] = {}
            current_hash = current_hash[x]
          end
        end
      end

      original_hash
    end
  end
end

