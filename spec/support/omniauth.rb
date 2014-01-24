OmniAuth.config.test_mode = true

# mocking return authetication
OmniAuth.config.add_mock(:facebook,
  {"provider"=>"facebook",
   "uid"=>"123456",
   "info"=>
    {"email"=>"user@top5.com",
     "name"=>"Alma Azhari",
     "first_name"=>"Alma",
     "last_name"=>"Azhari",
     "image"=>"http://graph.facebook.com/123456/picture?type=square",
     "urls"=>{"Facebook"=>"http://www.facebook.com/profile.php?id=123456"}},
   "credentials"=>
    {"token"=>"VtffY0UCXyg31XZBezNpa",
     "expires"=>false},
   "extra"=>
    {"raw_info"=>
      {"id"=>"123456",
       "name"=>"Alma Azhari",
       "first_name"=>"Alma",
       "last_name"=>"Azhari",
       "link"=>"http://www.facebook.com/profile.php?id=123456",
       "gender"=>"female",
       "email"=>"user@top5.com",
       "timezone"=>7,
       "locale"=>"en_US",
       "verified"=>true,
       "updated_time"=>"2011-10-22T16:09:53+0000"}}})

OmniAuth.config.add_mock(:twitter,
  {"provider"=>"twitter",
   "uid"=>"123456",
   "info"=>
    {"nickname"=>"alma",
     "name"=>"Alma Azhari",
     "location"=>"Jakarta",
     "image"=>
      "http://a3.twimg.com/profile_images/123456/1816_normal.jpg",
     "description"=>"",
     "urls"=>{"Website"=>nil, "Twitter"=>"http://twitter.com/alma"}
    },
   "credentials"=>
    {"token"=>"Parm24AZXKyEKgO8",
     "secret"=>"Fjvv08lIGPBw0YDUWBA"},
   "extra"=> {"lot" => "of data"}})

