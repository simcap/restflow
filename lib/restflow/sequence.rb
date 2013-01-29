module Restflow

  class Sequences

    def parse_flow_file(path)
      instance_eval(File.read(path), path)
    end

    def sequence(description, &block)
      Sequence.new(description, &block)
    end

  end

  class Sequence

    attr_reader :description

    def initialize(description, &block)
      @description =  description
      raise "Sequence block is empty!!" unless block
      instance_eval &block
    end

    def base_url(url)
      @base_url = url
    end

    def get(path)
      puts "Calling #{@base_url}/#{path}"
      @response = HTTParty.get("#{@base_url}/#{path}")
    end

    def html
      Nokogiri::HTML(@response.body)
    end

    def code
      @response.code
    end

  end

end