base_url 'http://localhost:4567'

sequence 'List all users' do
  get 'users'
  json['1']['firstname'].should == "John"
  json['2']['lastname'].should == "Helen"
  status.should == 200
end

sequence 'List one users' do
  get 'users/1'
  json['firstname'].should == "John"
  json['lastname'].should == "Doe"
  status.should == 200

  get 'users/2'
  json['firstname'].should == "Sue"
  json['lastname'].should == "Helen"
  status.should == 200
end

sequence 'Cannot find user' do
  get 'users/3'
  status.should == 404  
end

sequence 'Create new user' do
  post 'users', <<-BODY
    {"firstname":"James","lastname":"Bond"}
  BODY
  
  get 'users/3'
  status.should == 200 
  json['firstname'].should == "James"
  json['lastname'].should == "Bond"
end

sequence 'Create new user with body from file' do
  post 'users', :file => "new_user.json"
  
  get 'users/4'
  status.should == 200 
  json['firstname'].should == "Bob"
  json['lastname'].should == "Marley"
end

sequence 'Delete users' do
  delete 'users/3'
  status.should == 200
  get 'users/3'
  status.should == 404 

  delete 'users/4'
  status.should == 200
  get 'users/4'
  status.should == 404 
end

sequence 'Error when creating' do
  post 'users', <<-BODY
    {"firstname":"James"}
  BODY
    
  response.should =~ /lastname is missing/

  post 'users', <<-BODY
    {"lastname":"Bond"}
  BODY

  response.should =~ /firstname is missing/
end

