module RBattlenet
  @@region = "eu"
  @@locale = "en_gb"
  @@raw = false
  @@concurrency = 20
  @@timeout = 120

  #Set Access Token for requests. Required
  def self.authenticate(client_id:, client_secret:)
    oauth_region = ["kr", "tw"].include?(@@region.downcase) ? "apac" : @@region
    response = Typhoeus.post("https://#{oauth_region}.battle.net/oauth/token",
      body: { grant_type: :client_credentials },
      userpwd: "#{client_id}:#{client_secret}",
    )
    raise RBattlenet::Errors::Unauthorized.new if response.code == 401
    @@token = JSON.parse(response.body)['access_token']
    true
  end

  def self.set_options(region: @@region, locale: @@locale, raw_response: @@raw, concurrency: @@concurrency, timeout: @@timeout)
    @@region, @@locale, @@raw, @@concurrency, @@timeout = region, locale, raw_response, concurrency, timeout
    true
  end

  private

  class << self
    def get(subjects)
      store = @@raw ? [] : RBattlenet::ResultCollection.new

      headers = {}
      headers['Authorization'] = "Bearer #{@@token}" if @@token

      # Limit concurrency to prevent hitting the API request per-second cap.
      hydra = Typhoeus::Hydra.new(max_concurrency: @@concurrency)
      subjects.each do |uris, subject|
        uris.each do |field, uri|
          request = Typhoeus::Request.new(URI.encode(uri), headers: headers, timeout: @@timeout)

          request.on_complete do |response|
            if @@raw
              store << response
            else
              store.add(subject, field, response)
              if data = store.complete(subject, uris.size)
                yield subject, data
              end
            end
          end


          hydra.queue request
        end
      end

      hydra.run
      store.size == 1 ? store.first : store
    end

    def uri(path)
      "https://#{@@region}.api.blizzard.com/#{path}#{@@region}&locale=#{@@locale}"
    end
  end
end
