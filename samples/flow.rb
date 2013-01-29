sequence 'Check definition of voiture' do
  #puts "Evaluting #{description}"
  base_url 'http://www.cnrtl.fr/definition'

  get 'voiture'
  word = html.at_css('//div#vtoolbar ul li a span').text
  word.should == "VOITURE"
  puts word
end

sequence 'Check definition of chaussure' do
  #puts "Evaluting #{description}"
  base_url 'http://www.cnrtl.fr/definition'

  get 'chaussure'
  word = html.at_css('//div#vtoolbar ul li a span').text
  word.should == "CHAUSSURE"
  puts word
end