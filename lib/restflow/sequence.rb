module Restflow

  class Sequences

    def parse_flow_file(path)
      @sequences = []
      @execution_dir = File.dirname(path)
      instance_eval(File.read(path), path)
      Restflow::Report.run(@sequences)
    end

    def sequence(description, &block)
      puts "Running < #{description} >"
      @sequences << Sequence.new(@execution_dir, description , @base_url, &block)
    end

    def base_url(url)
      @base_url = url
    end

  end

  class Sequence

    attr_reader :description, :responses

    def initialize(execution_dir, description, base_url = nil, &block)
      @responses = []
      @execution_dir = execution_dir
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

    def post(path, data)
      @response = send_post_data(:post, path, data)
      @responses << @response
      @response
    end

    def delete(path, data = nil)
      @response = send_post_data(:delete, path, data)
      @responses << @response
      @response
    end

    def put(path, data)
      @response = send_post_data(:put, path, data)
      @responses << @response
      @response
    end

    def response
      @response.body
    end

    def html
      Nokogiri::HTML(@response.body) 
    end

    def json
      JSON.parse(@response.body) if @response.body
    end

    def status
      @response.code
    end

    private

    def send_post_data(verb, path, post_data)
      if post_data.is_a?(Hash)
        file_path = File.expand_path(post_data[:file], @execution_dir)
        body = File.new(file_path).read
      else
        body = post_data
      end
      HTTParty.send(verb, "#{@base_url}/#{path}", :body => body)
    end

  end

end