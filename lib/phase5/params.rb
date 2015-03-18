require 'uri'
require 'byebug'

module Phase5
  class Params
    # use your initialize to merge params from
    # 1. query string
    # 2. post body
    # 3. route params
    #
    # You haven't done routing yet; but assume route params will be
    # passed in as a hash to `Params.new` as below:
    def initialize(req, route_params = {})
      @params = route_params
      parse_www_encoded_form(req.query_string) unless req.query_string.nil?
      parse_www_encoded_form(req.body) unless req.body.nil?
    end

    def [](key)
      @params[key.to_s]
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
    def parse_www_encoded_form(www_encoded_form)
      URI.decode_www_form(www_encoded_form).each do |param|
        outer_hash = {}
        current_hash = outer_hash
        current_keys = parse_key(param[0])

        current_keys.each do |key|
          if key == current_keys.last
            current_hash[key] = param[1]
          else
            current_hash[key] = {}
            current_hash = current_hash[key]
          end
        end

        @params.deep_merge(outer_hash)
      end

      @params
    end

    # this should return an array
    # user[address][street] should return ['user', 'address', 'street']
    def parse_key(key)
      keys_arr = []
      remaining_keys = key

      if /(\w+)(\]\[|\[|\])/.match(remaining_keys)
        loop do
          current_match_data = /(\w+)(\]\[|\[|\])/.match(remaining_keys)
          keys_arr << current_match_data[1]
          remaining_keys.slice!(current_match_data[0])
          break if remaining_keys == ""
        end
      else
        keys_arr << remaining_keys
      end

      keys_arr
    end
  end
end

class Hash
  def deep_merge(other_hash)
    common_keys = self.keys.select { |key| other_hash.has_key?(key) }

    other_hash.each do |key, value|
      if self.has_key?(key)
        self[key].deep_merge(other_hash[key])
      else
        self[key] = value
      end
    end
  end
end
