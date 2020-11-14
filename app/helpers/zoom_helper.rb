
module ZoomHelper

  def self.create_meeting(topic, start_time, password, agenda, user_id)
    params = {
      "topic": topic,
      "type": 2,
      "start_time": start_time.strftime('%Y-%m-%d %H:%M:00Z'),
      "duration": 120,
      "schedule_for": nil,
      "timezone": "America/Bogota",
      "password": password,
      "agenda": agenda,
      "recurrence": {
        "type":1
      },
      "settings": {
        "host_video": "false",
        "participant_video": "true",
        "cn_meeting": "false",
        "in_meeting": "false",
        "join_before_host": "true",
        "mute_upon_entry": "false",
        "watermark": "false",
        "use_pmi": "false",
        "audio": "both",
        "auto_recording": "none",
        "enforce_login": false,
        "enforce_login_domains": "false"
      }
    }
    puts "PARAMS:#{params.to_json}"
    response = HTTParty.post("https://api.zoom.us/v2/users/#{user_id}/meetings",
    {
      body: params.to_json.to_s,
      headers: {
        'Authorization': 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOm51bGwsImlzcyI6InZtczBNeGpUUXUtTjlmcGVtQ3hwZVEiLCJleHAiOjE3MzU3MDc2MDAsImlhdCI6MTU5MDI3Njc4NX0.zgScGnhGTObCcfAUJp09iZRn7wazNdExBT2iApL24Sc',
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      }
    })
    {response:JSON.parse(response.body), code:response.code}
  end

  def self.create_user(first_name, last_name, email)
    params = {
      "action": "create",
      "user_info": {
        "email": email,
        "type": 1,
        "first_name": first_name,
        "last_name": last_name
      }
    }
    puts "PARAMS:#{params.to_json}"
    response = HTTParty.post("https://api.zoom.us/v2/users",
    {
      body: params.to_json.to_s,
      headers: {
        'Authorization': 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOm51bGwsImlzcyI6InZtczBNeGpUUXUtTjlmcGVtQ3hwZVEiLCJleHAiOjE3MzU3MDc2MDAsImlhdCI6MTU5MDI3Njc4NX0.zgScGnhGTObCcfAUJp09iZRn7wazNdExBT2iApL24Sc',
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      }
    })
    {response:JSON.parse(response.body), code:response.code}
  end

  def self.get_user(id)
    response = HTTParty.get("https://api.zoom.us/v2/users/#{id}",
    {
      headers: {
        'Authorization': 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOm51bGwsImlzcyI6InZtczBNeGpUUXUtTjlmcGVtQ3hwZVEiLCJleHAiOjE3MzU3MDc2MDAsImlhdCI6MTU5MDI3Njc4NX0.zgScGnhGTObCcfAUJp09iZRn7wazNdExBT2iApL24Sc',
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      }
    })
    {response:JSON.parse(response.body), code:response.code}
  end

end
