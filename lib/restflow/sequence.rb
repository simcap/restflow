module Restflow

  class Sequences

    def parse_flow_file(path)
      instance_eval(File.read(path), path)
    end

    def sequence(description, &block)
      puts "Running < #{description} >"
      sequence = Sequence.new(description, @base_url, &block)
      sequence.responses.each.with_index { |response, index|
        puts "#{index+1}. Called: #{response.request.path}, status: #{response.code}"
      }
    end

    def base_url(url)
      @base_url = url
    end

  end

  class Sequence

    attr_reader :description, :responses

    def initialize(description, base_url = nil, &block)
      @responses = []
      @base_url = base_url if base_url
      @description =  description
      raise "Sequence block is empty!!" unless block
      instance_eval &block
    end

    def base_url(url)
      @base_url = url
    end

    def get(path)
      @response = HTTParty.get("#{@base_url}/#{path}")
      @responses << @response
      @response
    end

    def html
      Nokogiri::HTML(@response.body)
    end

    def json
      JSON.parse(@response.body)
    end

    def status
      @response.code
    end

  end

end