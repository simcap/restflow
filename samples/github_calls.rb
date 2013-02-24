base_url 'https://api.github.com'

sequence 'Retrieve info of a Github user' do
  get 'users/simcap'
  json['login'].should == "simcap"
  status.should == 200
end

sequence 'Retrieve info of a Github repo' do
  get 'users/simcap/repos'
  json[0]['full_name'].should == "simcap/anagram-kata"
  status.should == 200

  get 'repos/simcap/anagram-kata'
  json['name'].should == "anagram-kata"
end