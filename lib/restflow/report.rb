module Restflow

  module Report
    
    require 'builder'

    def self.run(sequences)
      report = File.new("sequences-report.html", "w")
      b = Builder::XmlMarkup.new :target => report, :indent => 2
      b.instruct!
      b.html {
        b.head { b.title("Sequences")}
        b.style(self.css_content)
        b.body {
          sequences.each { |sequence|
            b.section(:class => "sequence") {
              b.h2(sequence.description)
              sequence.responses.each { |response|
                b.p(:class => "request"){
                  b.span(response.request.http_method.to_s.split("::").last, :class => "verb")
                  b.span(response.request.path, :class => "original-request")
                  b.span(response.code, :class => "status")
                }
                b.code(response.body)           
              }
            }

          }
        }
      }
      report.close
    end

    private

    def self.css_content
      <<-CSS
        body { }
        .request { }
        span.verb { font-weight: bold; text-transform: uppercase;}
        span.original-request { text-align: center;}
        span.status { font-weight: bold; float: right;}
      CSS
    end 

  end  

end

