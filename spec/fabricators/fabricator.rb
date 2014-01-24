# => this is for Admin user
Fabricator(:admin) do
  email { Faker::Internet.email }
  password 'secret'
end

# => this is for User, Profile
Fabricator(:user) do
  email { Faker::Internet.email }
  password 'secret'
end

  Fabricator(:profile) do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    birthday { Time.now.utc }
    sex { [true, false].shuffle.take(1) }
    city { Faker::Address.city }
    state { Faker::AddressUS.state }
    website { "http://#{Faker::Internet.domain_name}" }
    user
  end

# => this is for List, Item and Listing
Fabricator(:list) do
  name { sequence(:name) { |i| Faker::Lorem.words.join(" ") + i.to_s } }
  description { Faker::Lorem.paragraphs(rand(5)+1).join(" ") }
  category
  user
end

  Fabricator(:category) do
    name { sequence(:name) { |i| Faker::Lorem.word + i.to_s } }
  end

  Fabricator(:item) do
    transient :with_image
    name { sequence(:name) { |i| Faker::Lorem.words.join(" ") + i.to_s } }
    description { Faker::Lorem.paragraphs(rand(5)+1).join(" ") }
    after_create { |item, transient| item.image = File.open(File.join(Rails.root,'spec','support','assets','rails.png')) if transient[:with_image] }
  end

  Fabricator(:listing) do
    list
    item
    position { sequence(:position, 1) }
  end

  Fabricator(:comment) do
    content { Faker::Lorem.paragraphs(rand(3)+1).join(" ") }
    user
    position { sequence(:position, 1) }
  end

  Fabricator(:list_criteria) do
    name { [:newest_lists, :popular_lists, :random_lists, :trending_lists].shuffle.take(1) }
    criteria { "List.all" }
  end

  Fabricator(:comment_listing, :from => :comment) do
    content { Faker::Lorem.paragraphs(rand(3)+1).join(" ") }
    commentable!(:fabricator => :listing)
    user
    position { sequence(:position, 1) }
  end

Fabricator(:contact) do
  email { Faker::Internet.email }
  content { Faker::Lorem.paragraphs(rand(5)+1).join(" ") }
end

# Application Settings
Fabricator(:setting) do
  name { Faker::Lorem.word }
  preferences { { :support_email => Faker::Internet.email, :notify_email => [true,false].shuffle.take(1) } }
end
