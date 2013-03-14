require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

USERS = { 1 => { "firstname" => "John", "lastname" => "Doe"},
          2 => { "firstname" => "Sue", "lastname" => "Helen"}}


describe "Restflow" do

  it "runs getting users sequence file" do
    stub_request(:get, "http://localhost:80/users")
      .to_return(:body => JSON.generate(USERS), :status => 200)
    stub_request(:get, "http://localhost:80/users/1")
      .to_return(:body => JSON.generate({ "firstname" => "John", "lastname" => "Doe"}), 
                  :status => 200)
    stub_request(:get, "http://localhost:80/users/2")
      .to_return(:body => JSON.generate({ "firstname" => "Sue", "lastname" => "Helen"}), 
                  :status => 200)
    stub_request(:get, "http://localhost:80/users/3")
      .to_return(:status => 404)
    run_restflow_file("getting_users.sequence")
  end

  it "runs creating users sequence file" do
    stub_request(:post, "http://localhost:80/users")
      .with(:body => "{\"firstname\":\"James\",\"lastname\":\"Bond\"}\n")
    stub_request(:get, "http://localhost:80/users/3")
      .to_return(:body => JSON.generate({ "firstname" => "James", "lastname" => "Bond"}), 
                  :status => 200)
    stub_request(:post, "http://localhost:80/users")
      .with(:body => "{\"firstname\":\"Bob\",\"lastname\":\"Marley\"}")
    stub_request(:get, "http://localhost:80/users/4")
      .to_return(:body => JSON.generate({ "firstname" => "Bob", "lastname" => "Marley"}), 
                  :status => 200)
    run_restflow_file("creating_users.sequence")
  end

  it "runs deleting users sequence file" do
    stub_request(:delete, "http://localhost:80/users/3")
      .to_return(:status => 200)
    stub_request(:get, "http://localhost:80/users/3")
      .to_return(:status => 404)
    stub_request(:delete, "http://localhost:80/users/4")
      .to_return(:status => 200)
    stub_request(:get, "http://localhost:80/users/4")
      .to_return(:status => 404)
    run_restflow_file("deleting_users.sequence")
  end

  it "runs error users sequence file" do
    stub_request(:post, "http://localhost:80/users")
      .with(:body => "{\"firstname\":\"James\"}\n")
      .to_return(:body => "The lastname is missing")
    stub_request(:post, "http://localhost:80/users")
      .with(:body => "{\"lastname\":\"Bond\"}\n")
      .to_return(:body => "The firstname is missing")
    run_restflow_file("error_users.sequence")
  end

end

def run_restflow_file(sequence_file_name)
  full_path = File.expand_path("../../samples/#{sequence_file_name}", __FILE__)
  sequences = Restflow::Sequences.new
  sequences.parse_flow_file(full_path)
end
