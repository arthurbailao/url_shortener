require 'httparty'
require 'thread'

$q = SizedQueue.new(128)

def generate_url
  height = rand(100..768)
  width = (1024.0/768 * height).to_i

  "https://placekitten.com/g/#{width}/#{height}"
end

t = Thread.new do 
  loop do 
    begin
      body = { url: generate_url() }
      headers = { 'Content-Type' =>  'application/json' }
      resp = HTTParty.post('http://localhost:4000/api/urls', body: body.to_json, headers: headers)
      resp = JSON.parse(resp.body)

      $q.push(resp['data']['short_url'])

      puts "#{resp['data']['short_url']} -> #{resp['data']['url']}"
    rescue Exception => ex
      puts ex
    ensure
      sleep 0.1
    end
  end
  puts "saindo"
end


t2 = Thread.new do 
  loop do
    begin
      url = $q.pop
      HTTParty.get(url, follow_redirects: false)
    rescue Exception => ex
      puts ex
    end
  end
end

t.join
t2.join
