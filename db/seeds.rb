# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#

Admin.destroy_all
Admin.create!(:email => 'admin@thetop5.com', :password => 'thetop5', :password_confirmation => 'thetop5')

Category.destroy_all
games = Category.create!(:name => "Games")
movies = Category.create!(:name => "Movies")
sports = Category.create!(:name => "Sports")
music = Category.create!(:name => "Music")
television = Category.create!(:name => "Television")
misc = Category.create!(:name => "Miscellaneous")
foods = Category.create!(:name => "Foods")
computers = Category.create!(:name => "Computers and the Internet")

User.destroy_all
user = User.new(:email => 'john_smith@thetop5.com', :password => 'thetop5', :password_confirmation => 'thetop5')
user.skip_confirmation!
user.save!
user.profile.first_name = "John"
user.profile.last_name = "Smith"
user.save!

# Generate List Criteria
ListCriteria.destroy_all
ListCriteria.create(name: :newest_lists, criteria: "List.where(:state => 'approved').order('created_at DESC')")
ListCriteria.create(name: :popular_lists, criteria: "List.select('lists.id, lists.name, lists.description, lists.category_id, lists.user_id, sum(COALESCE(rs_reputations.value, 0)) AS total_item_votes').joins('INNER JOIN listings ON lists.id = listings.list_id LEFT JOIN rs_reputations ON listings.id = rs_reputations.target_id').where('lists.state = ? AND rs_reputations.target_type = ? AND rs_reputations.reputation_name = ? AND rs_reputations.active = ? AND (COALESCE(rs_reputations.value, 0) > 0)', 'approved', 'Listing', 'item_votes', 't').group('lists.id, lists.name, lists.description, lists.category_id, lists.user_id').order('total_item_votes DESC')")
ListCriteria.create(name: :random_lists, criteria: "List.where(:state => 'approved').order('RANDOM()')")
ListCriteria.create(name: :trending_lists, criteria: "List.where(:state => 'approved').order('updated_at DESC')")
ListCriteria.create(name: :list_type, criteria: "List.where(:state => 'approved')")

# Create initial app_settings
Setting.create(:name => "Application Settings", :preferences => { :top_scrolling_list => ListCriteria.last.name })

# Generate Lists and Items
List.destroy_all
Item.destroy_all

sample_comments = [
  "BEST! Only word that I know for this!",
  "This is the Best",
  "This is the best EVER!",
  "I Love it, THANKS!",
  "Very Nice!!!!!",
  "this is Truly a masterpiece",
  "This is very Awesome!",
  "I think this is one of the best...",
  "This is very very very COOL!!!",
  "I love this, this is totally the BEST!",
  "Brilliant.",
  "really like this !!!",
  "Very Great Ever!",
  "actually, this is the best in the world",
  "This is the Best, Please VOTE this!",
  "Certainly better than the others",
  "So Good...",
  "Love it, Really recommended for every one!",
  "Awesome, I highly Recommended this"
]

list = user.lists.build(name: "Best Wii Games Of All Time", description: 'list description for best Wii games of all time', category: games)
[
Item.create!(name:"2010 FIFA World Cup South Africa"),
Item.create!(name:"A Boy and His Blob"),
Item.create!(name:"AC/DC Live: Rock Band Track Pack"),
Item.create!(name:"Academy Of Champions: Soccer"),
Item.create!(name:"Action Girlz Racing"),
Item.create!(name:"Active Life: Explorer"),
Item.create!(name:"Active Life: Extreme Challenge"),
Item.create!(name:"The Adventures of Pinocchio[2]"),
Item.create!(name:"The Adventures of Tintin: The Secret of the Unicorn (video game)[3]"),
Item.create!(name:"AFL"),
Item.create!(name:"Agatha Christie: And Then There Were None"),
Item.create!(name:"Agatha Christie: Evil Under the Sun"),
Item.create!(name:"Agent Hugo: Lemon Twist"),
Item.create!(name:"Aladdin Magic Racer"),
Item.create!(name:"Alan Hansen's Sports Challenge"),
Item.create!(name:"Alice in Wonderland"),
Item.create!(name:"Alien Monster Bowling League"),
Item.create!(name:"Alien Syndrome"),
Item.create!(name:"Aliens In The Attic"),
Item.create!(name:"All Round Hunter"),
Item.create!(name:"All Star Cheer Squad"),
Item.create!(name:"All Star Cheer Squad 2"),
Item.create!(name:"All Star Karate"),
Item.create!(name:"Alone in the Dark"),
Item.create!(name:"Alvin and the Chipmunks"),
Item.create!(name:"Alvin and the Chipmunks: The Squeakquel"),
Item.create!(name:"Amazing Animals"),
Item.create!(name:"The Amazing Race")
].each { |item|
  list.listings.build(item_id: item.id).comments.build(user: user, content: Faker::Lorem.paragraphs(rand(3)+1).join(" "))
}
list.save!
list.approve!

list = user.lists.build(name: "Best American Games Of All Time", description: 'list description for best American games of all time', category: games)
[
Item.create!(name:"American Pool Deluxe"),
Item.create!(name:"American Mensa Academy"),
Item.create!(name:"AMF Bowling Pinbusters!"),
Item.create!(name:"AMF Bowling World Lanes"),
Item.create!(name:"Animal Crossing: City Folk"),
Item.create!(name:"Animal Kingdom: Wildlife Expedition"),
Item.create!(name:"Animal Planet: Vet Life"),
Item.create!(name:"Anime Slot Revolution: Pachi-Slot Kidou Senshi Gundam II - Ai Senshi Hen"),
Item.create!(name:"Angry Birds Trilogy[4]"),
Item.create!(name:"Another Code: R - A Journey into Lost Memories"),
Item.create!(name:"The Ant Bully"),
Item.create!(name:"Anubis II"),
Item.create!(name:"Aqua Panic!"),
Item.create!(name:"Aquatic Tales"),
Item.create!(name:"Arcade Shooter: Ilvelo"),
Item.create!(name:"Baseball Blast!")
].each { |item|
  list.listings.build(item_id: item.id).comments.build(user: user, content: Faker::Lorem.paragraphs(rand(3)+1).join(" "))
}
list.save!
list.approve!

list = user.lists.build(name: "Best Sports Nintendo Games Of All Time", description: 'list description for best sports video games in Nintendo.', category: games)
[
Item.create!(name:"Basketball Hall of Fame: Ultimate Hoops Challenge"),
Item.create!(name:"Bass Pro Shops: The Hunt"),
Item.create!(name:"Bass Pro Shops: The Strike"),
Item.create!(name:"Batman: The Brave And The Bold"),
Item.create!(name:"Battalion Wars 2"),
Item.create!(name:"Battle of Giants: Dinosaurs Strike"),
Item.create!(name:"Battle of the Bands"),
Item.create!(name:"Battle Rage: The Robot Wars"),
Item.create!(name:"Battleship"),
Item.create!(name:"Beach Fun Summer Challenge"),
Item.create!(name:"The Beatles: Rock Band"),
Item.create!(name:"Beastly"),
Item.create!(name:"Bee Movie Game"),
Item.create!(name:"Ben 10: Protector of Earth"),
Item.create!(name:"Ben 10: Alien Force"),
Item.create!(name:"Ben 10 Ultimate Alien: Cosmic Destruction"),
Item.create!(name:"Ben 10: Omniverse"),
Item.create!(name:"Bermuda Triangle"),
Item.create!(name:"Beyblade: Metal Fusion Battle Fortress"),
Item.create!(name:"Big Beach Sports"),
Item.create!(name:"Big Beach Sports 2"),
Item.create!(name:"Big Brain Academy: Wii Degree"),
Item.create!(name:"Big Catch Bass Fishing 2"),
Item.create!(name:"The Biggest Loser Challenge"),
Item.create!(name:"Buck Fever")
].each { |item|
  list.listings.build(item_id: item.id).comments.build(user: user, content: Faker::Lorem.paragraphs(rand(3)+1).join(" "))
}
list.save!
list.approve!

list = user.lists.build(name: "Best Baby Games Of All Time", description: 'list description for the best games for infant.', category: games)
[
Item.create!(name:"Build-A-Bear Workshop: A Friend Fur All Seasons"),
Item.create!(name:"Build-A-Bear Workshop: Friendship Valley"),
Item.create!(name:"Build 'N Race"),
Item.create!(name:"Burger Bot"),
Item.create!(name:"Burger Island[7]"),
Item.create!(name:"Bully: Scholarship Edition"),
Item.create!(name:"Bust-A-Move Bash!"),
Item.create!(name:"Busy Scissors"),
Item.create!(name:"Cabela's Big Game Hunter"),
Item.create!(name:"Cabela's Big Game Hunter 2010"),
Item.create!(name:"Cabela's Dangerous Hunts 2009"),
Item.create!(name:"Cabela's Dangerous Hunts 2011: Special Edition"),
Item.create!(name:"Cabela's Legendary Adventures"),
Item.create!(name:"Cabela's Monster Buck Hunter"),
Item.create!(name:"Cabela's North American Adventures 2011"),
Item.create!(name:"Cabela's Dangerous Hunts 2013"),
Item.create!(name:"Cabela's Outdoor Adventures 2010"),
Item.create!(name:"Cabela's Trophy Bucks"),
Item.create!(name:"The Cages: Pro Style Batting Practice"),
Item.create!(name:"Cake Mania: In the Mix!"),
Item.create!(name:"Call for Heroes: Pompolic Wars"),
Item.create!(name:"Call of Duty 3"),
Item.create!(name:"Call of Duty: Black Ops"),
Item.create!(name:"Call of Duty: Modern Warfare 3"),
Item.create!(name:"Call of Duty: Modern Warfare: Reflex Edition"),
Item.create!(name:"Call of Duty: World at War"),
Item.create!(name:"Club Penguin: Game Day!")
].each { |item|
  list.listings.build(item_id: item.id).comments.build(user: user, content: Faker::Lorem.paragraphs(rand(3)+1).join(" "))
}
list.save!
list.approve!

list = user.lists.build(name: "Best RPG Games Of All Time", description: 'list description for best RPG / Strategy games of all time', category: games)
[
Item.create!(name:"Cocoto Magic Circus"),
Item.create!(name:"Cocoto Kart Racer"),
Item.create!(name:"Code Lyoko: Quest for Infinity"),
Item.create!(name:"Coldstone Creamery Scoop It Up"),
Item.create!(name:"The Conduit"),
Item.create!(name:"Conduit 2"),
Item.create!(name:"Cook Wars"),
Item.create!(name:"Cooking Mama: Cook Off"),
Item.create!(name:"Cooking Mama: World Kitchen"),
Item.create!(name:"Coraline"),
Item.create!(name:"Cosmic Family"),
Item.create!(name:"Counter Force"),
Item.create!(name:"Cradle of Rome"),
Item.create!(name:"Cranium Kabookii"),
Item.create!(name:"Crash: Mind over Mutant"),
Item.create!(name:"Crash Dummy Vs. The Evil D-Troit"),
Item.create!(name:"Crash of the Titans"),
Item.create!(name:"Crayola Colorful Journey"),
Item.create!(name:"Crazy Chicken Tales"),
Item.create!(name:"Crazy Climber Wii"),
Item.create!(name:"Crazy Mini Golf 2"),
Item.create!(name:"Create"),
Item.create!(name:"Cruise Ship Resort"),
Item.create!(name:"Cruise Ship Vacation Games"),
Item.create!(name:"Cruis'n"),
Item.create!(name:"CSI: Deadly Intent"),
Item.create!(name:"CSI: Fatal Conspiracy"),
Item.create!(name:"CSI: Hard Evidence"),
Item.create!(name:"Cursed Mountain"),
Item.create!(name:"Deer Drive")
].each { |item|
  list.listings.build(item_id: item.id).comments.build(user: user, content: Faker::Lorem.paragraphs(rand(3)+1).join(" "))
}
list.save!
list.approve!

list = user.lists.build(name: "Best PS3 Games Of All Time", description: 'list description for best PS3 games of all time', category: games)
[
Item.create!(name:"Def Jam Rapstar"),
Item.create!(name:"Defenders of Law, Inc.: Crime in Willburg"),
Item.create!(name:"Defendin' de Penguin"),
Item.create!(name:"Densha de Go! Sanyo- Shinkansen EX"),
Item.create!(name:"Despicable Me: The Game"),
Item.create!(name:"The Destiny of Zorro"),
Item.create!(name:"Destroy All Humans! Big Willy Unleashed"),
Item.create!(name:"Dewy's Adventure"),
Item.create!(name:"Diabolik: The Original Sin"),
Item.create!(name:"Diva Girls: Princess on Ice"),
Item.create!(name:"Dirt 2"),
Item.create!(name:"Disaster: Day of Crisis"),
Item.create!(name:"Disney Channel All Star Party"),
Item.create!(name:"Disney Epic Mickey"),
Item.create!(name:"Epic Mickey 2: The Power of Two"),
Item.create!(name:"Disney Guilty Party"),
Item.create!(name:"Disney Infinity"),
Item.create!(name:"Disney Princess: Enchanted Journey"),
Item.create!(name:"Disney Sing It"),
Item.create!(name:"Disney Sing It: Family Hits"),
Item.create!(name:"Disney Sing It: Party Hits"),
Item.create!(name:"Disney Sing It: Pop Hits"),
Item.create!(name:"Disney Tangled"),
Item.create!(name:"Disney The Princess And The Frog"),
Item.create!(name:"Disney Princess: My Fairytale Adventure"),
Item.create!(name:"Disney Th!nk Fast: The Ultimate Trivia Showdown"),
Item.create!(name:"Disney's Bolt"),
Item.create!(name:"Disney's Chicken Little: Ace in Action"),
Item.create!(name:"Diva Girls: Divas On Ice"),
Item.create!(name:"FaceBreaker KO Party")
].each { |item|
  list.listings.build(item_id: item.id).comments.build(user: user, content: Faker::Lorem.paragraphs(rand(3)+1).join(" "))
}
list.save!
list.approve!

list = user.lists.build(name: "Best Action Games Of All Time", description: 'list description for best Action video games of all time', category: games)
[
Item.create!(name:"Fantastic Four: Rise of the Silver Surfer"),
Item.create!(name:"Fantasy Aquarium World"),
Item.create!(name:"Far Cry Vengeance"),
Item.create!(name:"Fast Food Panic"),
Item.create!(name:"Ferrari Challenge: Trofeo Pirelli"),
Item.create!(name:"FIFA Soccer 08"),
Item.create!(name:"FIFA 09 All-Play"),
Item.create!(name:"FIFA 10 WORLD CLASS SOCCER"),
Item.create!(name:"FIFA 11"),
Item.create!(name:"FIFA 13"),
Item.create!(name:"Final Fantasy Crystal Chronicles: The Crystal Bearers"),
Item.create!(name:"Final Fantasy Crystal Chronicles: Echoes of Time"),
Item.create!(name:"Final Fantasy Fables: Chocobo's Dungeon"),
Item.create!(name:"Fire Emblem: Radiant Dawn"),
Item.create!(name:"Fishing Master"),
Item.create!(name:"Fishing Master World Tour"),
Item.create!(name:"Fit & Fun"),
Item.create!(name:"Fit in Six"),
Item.create!(name:"FlingSmash"),
Item.create!(name:"Flip's Twisted World"),
Item.create!(name:"Food Network: Cook or Be Cooked"),
Item.create!(name:"Ford Racing: Off Road"),
Item.create!(name:"Fortune Street"),
Item.create!(name:"Fragile Dreams: Farewell Ruins of the Moon"),
Item.create!(name:"Freddi Fish in Kelp Seed Mystery"),
Item.create!(name:"Free Running"),
Item.create!(name:"Fritz Chess"),
Item.create!(name:"High School Musical 3: Senior Year Dance")
].each { |item|
  list.listings.build(item_id: item.id).comments.build(user: user, content: Faker::Lorem.paragraphs(rand(3)+1).join(" "))
}
list.save!
list.approve!

list = user.lists.build(name: "Best Racing Games Of All Time", description: 'list description for best Motorsport Racing Video Games of all time', category: games)
[
Item.create!(name:"The History Channel: Battle for the Pacific"),
Item.create!(name:"Hollywood Squares"),
Item.create!(name:"Honda ATV Fever"),
Item.create!(name:"Hooked! Real Motion Fishing"),
Item.create!(name:"Big Catch Bass FishingPAL"),
Item.create!(name:"Hooked! Again: Real Motion Fishing"),
Item.create!(name:"Horse Life 2"),
Item.create!(name:"Horse Life Adventures"),
Item.create!(name:"Horrible Histories: Ruthless Romans"),
Item.create!(name:"Hot Wheels: Battle Force 5"),
Item.create!(name:"Hot Wheels: Beat That!"),
Item.create!(name:"Hot Wheels: Track Attack"),
Item.create!(name:"Hotel for Dogs"),
Item.create!(name:"The House of the Dead 2 & 3 Return"),
Item.create!(name:"The House of the Dead: Overkill"),
Item.create!(name:"Hudson's Puzzle Series Vol.2 Illustlogic + Colorful Logic"),
Item.create!(name:"Hula Wii: Minna de Hula wo Odorou"),
Item.create!(name:"Hyper Fighters"),
Item.create!(name:"Hysteria Hospital: Emergency Ward"),
Item.create!(name:"I SPY Spooky Mansion"),
Item.create!(name:"iCarly"),
Item.create!(name:"Kizuna")
].each { |item|
  list.listings.build(item_id: item.id).comments.build(user: user, content: Faker::Lorem.paragraphs(rand(3)+1).join(" "))
}
list.save!
list.approve!

list = user.lists.build(name: "Best Italian dishes Of All Time", description: 'list description for best Italian dishes of all time', category: foods)
[
Item.create!(name:"Braciole"),
Item.create!(name:"Bruschetta"),
Item.create!(name:"Bresaola"),
Item.create!(name:"Crostini con condimenti misti"),
Item.create!(name:"Capicollo"),
Item.create!(name:"Culatello"),
Item.create!(name:"Curried Braised Rabbit stew"),
Item.create!(name:"Insalata caprese"),
Item.create!(name:"Insalata russa"),
Item.create!(name:"Mozzarelline fritte (fried small mozzarellas)"),
Item.create!(name:"Nervetti (pressed beef cartilage seasoned with onions)"),
Item.create!(name:"Olives"),
Item.create!(name:"Peperoni imbottiti"),
Item.create!(name:"Prosciutto e melone"),
Item.create!(name:"Pizzette e salatini"),
Item.create!(name:"Salami"),
Item.create!(name:"Strolghino"),
Item.create!(name:"Tortano"),
Item.create!(name:"Verdure in pinzimonio"),
Item.create!(name:"Vezione verro"),
Item.create!(name:"Acquacotta"),
Item.create!(name:"Garmugia"),
Item.create!(name:"Ginestrata"),
Item.create!(name:"Minestrone"),
Item.create!(name:"Pasta e fagioli"),
Item.create!(name:"Risi e bisi"),
Item.create!(name:"Sugo al Pomodoro"),
Item.create!(name:"Fonduta (fondue)"),
Item.create!(name:"Grine Sauce"),
Item.create!(name:"Stracciatella"),
Item.create!(name:"Chinga")
].each { |item|
  list.listings.build(item_id: item.id).comments.build(user: user, content: Faker::Lorem.paragraphs(rand(3)+1).join(" "))
}
list.save!
list.approve!

list = user.lists.build(name: "Best Japanese rice foods Of All Time", description: 'list description for the best Japanese serve with rice', category: foods)
[
Item.create!(name:"sushi"),
Item.create!(name:"onigiri"),
Item.create!(name:"donburi"),
Item.create!(name:"takikomi-gohan", description: "boiled rice served with various ingredients and seasonings, such as soy sauce."),
Item.create!(name:"o-kayu"),
Item.create!(name:"o-chazuke"),
Item.create!(name:"furikake"),
Item.create!(name:"mochi"),
Item.create!(name:"sekihan")
].each { |item|
  list.listings.build(item_id: item.id).comments.build(user: user, content: Faker::Lorem.paragraphs(rand(3)+1).join(" "))
}
list.save!
list.approve!

list = user.lists.build(name: "Best Legendary Rappers of All time", description: 'list description for best legendary rappers', category: music)

list.listings.build(item: Item.create!(name: "NAS", description: "Nasir bin Olu Dara Jones aka Nas is an American rapper who was born in Crown Heights Brooklyn, New York on September 14, 1973 and was raised in Queens, New York.  His father is Olu Dara a jazz and blues musician and Nas is believed by many to be one of the greatest rappers and lyricists of all time.  MTV, MTV 2, The Source, and About.com all ranked Nas in the top 5 of their lists of the all-time best MC's.  Nas' debut album was 'Illmatic' which was released in 1994 under the Columbia label.  It received a 5 mic rating from The Source which was a prestigious honor and unheard of from debuting artists at the time.  Some of the singles from Illmatic include 'The World is Yours', 'One Love', and 'It Ain't Hard To Tell'. Illmatic has been named by many as the top debut hip hop album of all-time.  Nas' second album 'It Was Written' helped to solidify Nas as one of the top people in hip hop.  Nas had two very popular singles on this album which were made into two very big music videos as well.  One of the singles was 'If I Ruled The World (Imagine That)'"))
list.listings.build(item: Item.create!(name: "Jadakiss", description: "Whose original name is Jason Phillips.  He is a member of the group The LOX along with Sheek Louch and Styles P. They were originally signed with Bad Boy Records, but are not a part of Ruff Ryders Entertainment which is where Jadakiss go a start from an early age.  Jadakiss was mentioned by Eminem in his song 'Till I Collapse' as one of the best rappers in the industry.  His debut album was Kiss Tha Game Goodbye which featured his single 'Put Ya Hands Up' and was released in 2001.  His next album was Kiss of Death which was released in 2004 and included the hit single 'Why?' which also came with much controversy as part of the lyrics suggested George W. Bush was responsible for the 9/11 planes crashing into the twin towers.  Bill O' Reilly was very outspoken about calling the lyrics slander and many radio stations either banned the song or bleeped out the lyrics from that part of the song due to the controversy created by the remarks. His most recent album titled 'The Last Kiss' was released in 2009 and included the singles 'By My Side' which included Ne-Yo, 'Can't Stop Me', 'Death Wish' which featured Lil Wayne, and also 'Who's Real' which featured OJ da Juiceman and Swizz Beats."))
list.listings.build(item: Item.create!(name: "Ras Kass", description: "West Coast Rapper whose debut album Soul On Ice was released on October 1st, 1996. His biggest song from that track was Nature of the Threat. He was a former member of hip hop group The HRSMN which also included Kurupt, Killah Priest, and Canibus.  His second debut album was Rasassination. "))

[
Item.create!(name: "Tupac Shakur"),
Item.create!(name: "Eminem"),
Item.create!(name: "Biggie Small/Notorious BIG"),
Item.create!(name: "Jay-Z"),
Item.create!(name: "Rakim"),
Item.create!(name: "Ice Cube"),
Item.create!(name: "Scarface"),
Item.create!(name: "Lil Wayne"),
Item.create!(name: "Twista"),
Item.create!(name: "Dr. Dre"),
Item.create!(name: "Run DMC"),
Item.create!(name: "Public Enemy"),
Item.create!(name: "Ol Dirty Bastard"),
Item.create!(name: "Method Man"),
Item.create!(name: "Redman"),
Item.create!(name: "The Sugar Hill Gang"),
Item.create!(name: "LL Cool J"),
Item.create!(name: "Outkast")
].each { |item|
  list.listings.build(item_id: item.id).comments.build(user: user, content: Faker::Lorem.paragraphs(rand(3)+1).join(" "))
}
list.save!
list.approve!

list = user.lists.build(name: "Best Musicians in the World", description: 'This is description for best male / female musicians in the world.', category: music)
[
Item.create!(name: "A Tribe Called Quest"),
Item.create!(name: "Beastie Boys"),
Item.create!(name: "Snoop Dogg"),
Item.create!(name: "Kanye West"),
Item.create!(name: "P Diddy/Puff Daddy/Diddy"),
Item.create!(name: "Queen Latifah"),
Item.create!(name: "Ice T"),
Item.create!(name: "KRS-one"),
Item.create!(name: "50 Cent"),
Item.create!(name: "De La Soul"),
Item.create!(name: "Grandmaster Flash and the Furious Five"),
Item.create!(name: "Master P"),
Item.create!(name: "Big Daddy Kane"),
Item.create!(name: "MC Hammer"),
Item.create!(name: "Salt n Pepa"),
Item.create!(name: "Lil Kim"),
Item.create!(name: "2 Live Crew"),
Item.create!(name: "Will Smith/The Fresh Prince"),
Item.create!(name: "Too Short"),
Item.create!(name: "Gang Starr"),
Item.create!(name: "Missy 'Misdemeanor' Elliot"),
Item.create!(name: "Bone Thugs N Harmony"),
Item.create!(name: "UGK"),
Item.create!(name: "DMX"),
Item.create!(name: "Pastor Troy"),
Item.create!(name: "Three Six Mafio"),
Item.create!(name: "Juicy J"),
Item.create!(name: "Project Pat"),
Item.create!(name: "Miracle"),
Item.create!(name: "Busta Rhymes"),
Item.create!(name: "Slick Rick")
].each { |item|
  list.listings.build(item_id: item.id).comments.build(user: user, content: Faker::Lorem.paragraphs(rand(3)+1).join(" "))
}
list.save!
list.approve!

list = user.lists.build(name: "Best Rappers of All time", description: 'This is description for best rappers.', category: music)
[
Item.create!(name: "MC Lyte"),
Item.create!(name: "Kool G Rap"),
Item.create!(name: "Kurtis Blow"),
Item.create!(name: "Schoolly D"),
Item.create!(name: "Treacherous Three"),
Item.create!(name: "Soulja Boy"),
Item.create!(name: "Big Pun"),
Item.create!(name: "Common"),
Item.create!(name: "Andre 3000"),
Item.create!(name: "Raekwon"),
Item.create!(name: "Mos Def"),
Item.create!(name: "Talib Kweli"),
Item.create!(name: "Chuck D"),
Item.create!(name: "Black Thought"),
Item.create!(name: "Lauryn Hill"),
Item.create!(name: "A.Z."),
Item.create!(name: "TI"),
Item.create!(name: "T.I.P."),
Item.create!(name: "The GZA"),
Item.create!(name: "Canibus"),
Item.create!(name: "Kurupt"),
Item.create!(name: "Prodigy"),
Item.create!(name: "Spice 1"),
Item.create!(name: "Masta Ace"),
Item.create!(name: "DJ Quik"),
Item.create!(name: "Ghostface Killah"),
Item.create!(name: "Bun B"),
Item.create!(name: "Guru"),
Item.create!(name: "Pharell"),
Item.create!(name: "Fat Joe"),
Item.create!(name: "Rick Ross"),
Item.create!(name: "Swizz Beats"),
Item.create!(name: "DJ Khaled"),
Item.create!(name: "Nate Dogg"),
Item.create!(name: "Young Jeezy"),
Item.create!(name: "Lloyd Banks"),
Item.create!(name: "Gucci Mane")
].each { |item|
  list.listings.build(item_id: item.id).comments.build(user: user, content: Faker::Lorem.paragraphs(rand(3)+1).join(" "))
}
list.save!
list.approve!


list = user.lists.build(name: "Best Drama Series of All Time", description: 'list description for best of drama series of all time', category: television)
[
  Item.create!(name: "Dexter"),
  Item.create!(name: "Breaking Bad"),
  Item.create!(name: "24"),
  Item.create!(name: "Deadwood"),
  Item.create!(name: "Family Guy"),
  Item.create!(name: "The Simpsons"),
  Item.create!(name: "Weeds"),
  Item.create!(name: "Walking Dead"),
  Item.create!(name: "Mad Men"),
  Item.create!(name: "Friday Night Lights"),
  Item.create!(name: "Colbert Report"),
  Item.create!(name: "Freaks and Geeks"),
  Item.create!(name: "Arrested Development"),
  Item.create!(name: "30 Rock"),
  Item.create!(name: "Curb Your Enthusiasm"),
  Item.create!(name: "I Love Lucy"),
  Item.create!(name: "Buffy the Vampire Slayer"),
  Item.create!(name: "Lost"),
  Item.create!(name: "Battlestar Galactica"),
  Item.create!(name: "The Sopranos"),
  Item.create!(name: "The Office"),
  Item.create!(name: "The Daily Show with Jon Steward"),
  Item.create!(name: "The West Wing"),
  Item.create!(name: "The Wire"),
  Item.create!(name: "Firefly"),
  Item.create!(name: "Doctor Who"),
  Item.create!(name: "Mystery Science Theater 3000"),
  Item.create!(name: "The OC"),
  Item.create!(name: "One Tree Hill"),
  Item.create!(name: "Entourage"),
  Item.create!(name: "It's Always Sunny in Philadelphia"),
  Item.create!(name: "The League"),
  Item.create!(name: "Star Trek: The Next Generation"),
  Item.create!(name: "Knight Rider"),
  Item.create!(name: "Supernatural"),
  Item.create!(name: "Vampire Diaries"),
  Item.create!(name: "Criminal Minds"),
  Item.create!(name: "The Mentalist"),
  Item.create!(name: "Duck Dynasty"),
  Item.create!(name: "Pawn Stars"),
  Item.create!(name: "Hardcore Pawn"),
  Item.create!(name: "The Andy Griffith Show")
].each { |item|
  list.listings.build(item_id: item.id).comments.build(user: user, content: Faker::Lorem.paragraphs(rand(3)+1).join(" "))
}
list.save!
list.approve!

list = user.lists.build(name: "Best Comedy Series of All Time", description: 'list description for best comedy series of all time', category: television)
[
  Item.create!(name: "MASH"),
  Item.create!(name: "Saturday Night Live (SNL)"),
  Item.create!(name: "E.R."),
  Item.create!(name: "Grey's Anatomy"),
  Item.create!(name: "Law & Order"),
  Item.create!(name: "Dancing With the Stars"),
  Item.create!(name: "Hill Street Blues"),
  Item.create!(name: "Columbo"),
  Item.create!(name: "Deadliest Catch"),
  Item.create!(name: "Amazing Race"),
  Item.create!(name: "Veronica Mars"),
  Item.create!(name: "Star Trek: Deep Space Nine"),
  Item.create!(name: "Sex and the City"),
  Item.create!(name: "Farscape"),
  Item.create!(name: "Cracker"),
  Item.create!(name: "Only Fools and Horses"),
  Item.create!(name: "Life on Mars"),
  Item.create!(name: "Monty Python's Flying Circus"),
  Item.create!(name: "Father Ted"),
  Item.create!(name: "Frasier"),
  Item.create!(name: "Fawlty Towers"),
  Item.create!(name: "Red Dwarf"),
  Item.create!(name: "Angel"),
  Item.create!(name: "Blackadder"),
  Item.create!(name: "Spaced"),
  Item.create!(name: "60 Minutes"),
  Item.create!(name: "NCIS"),
  Item.create!(name: "NCIS: Los Angeles"),
  Item.create!(name: "2 Broke Girls"),
  Item.create!(name: "Touch"),
  Item.create!(name: "The Bachelor"),
  Item.create!(name: "The Bachelorette"),
  Item.create!(name: "Glee"),
  Item.create!(name: "America's Next Top Model"),
  Item.create!(name: "Hart of Dixie"),
  Item.create!(name: "Cheers"),
  Item.create!(name: "Family Ties"),
  Item.create!(name: "Home Improvement"),
  Item.create!(name: "The Cosby Show")
].each { |item|
  list.listings.build(item_id: item.id).comments.build(user: user, content: Faker::Lorem.paragraphs(rand(3)+1).join(" "))
}
list.save!
list.approve!

list = user.lists.build(name: "Best Action Series of All Time", description: 'list description for best action series of all time', category: television)
[
  Item.create!(name: "Gunsmoke"),
  Item.create!(name: "Newhart"),
  Item.create!(name: "The Golden Girls"),
  Item.create!(name: "St. Elsewhere"),
  Item.create!(name: "Growing Pains"),
  Item.create!(name: "The Wonder Years"),
  Item.create!(name: "The Fresh Prince of Bel-Air"),
  Item.create!(name: "Macgyver"),
  Item.create!(name: "ALF"),
  Item.create!(name: "Miami Vice"),
  Item.create!(name: "L.A. Law"),
  Item.create!(name: "Mad About You"),
  Item.create!(name: "Knots Landing"),
  Item.create!(name: "General Hospital"),
  Item.create!(name: "One Life to Live"),
  Item.create!(name: "Matlock"),
  Item.create!(name: "Will & Grace"),
  Item.create!(name: "Bonanza"),
  Item.create!(name: "NYPD Blue"),
  Item.create!(name: "Doogie Howser M.D."),
  Item.create!(name: "Top Chef")
].each { |item|
  list.listings.build(item_id: item.id).comments.build(user: user, content: Faker::Lorem.paragraphs(rand(3)+1).join(" "))
}
list.save!
list.approve!

list = user.lists.build(name: "Best Sci-fi Series of All Time", description: 'list description for best science-fiction series of all time', category: television)
[
  Item.create!(name: "The X-Files"),
  Item.create!(name: "Hercules: The Legendary Journeys"),
  Item.create!(name: "Ghost Whisperer"),
  Item.create!(name: "Teen Wolf"),
  Item.create!(name: "Jeopardy"),
  Item.create!(name: "Wipeout"),
  Item.create!(name: "Cougar Town"),
  Item.create!(name: "American Gladiators"),
  Item.create!(name: "Saved By the Bell"),
  Item.create!(name: "Saved By the Bell: The College Years"),
  Item.create!(name: "Beverly Hills, 90210"),
  Item.create!(name: "Highlander"),
  Item.create!(name: "Tales from the Crypt"),
  Item.create!(name: "Xena: Princess Warrior"),
  Item.create!(name: "Renegade"),
  Item.create!(name: "Charmed"),
  Item.create!(name: "La Femme Nikita"),
  Item.create!(name: "The View")
].each { |item|
  list.listings.build(item_id: item.id).comments.build(user: user, content: Faker::Lorem.paragraphs(rand(3)+1).join(" "))
}
list.save!
list.approve!

list = user.lists.build(name: "Best TV Shows of All Time", description: 'list description for best TV shows of all time', category: television)
[
  Item.create!(name: "Deal or No Deal"),
  Item.create!(name: "Good Morning America"),
  Item.create!(name: "Bizarre Foods with Andrew Zimmern"),
  Item.create!(name: "MythBusters"),
  Item.create!(name: "Anthony Bourdain: No Reservations"),
  Item.create!(name: "Archer"),
  Item.create!(name: "True Life"),
  Item.create!(name: "16 and Pregnant"),
  Item.create!(name: "The First 48"),
  Item.create!(name: "The Soup with Joel Mchale"),
  Item.create!(name: "Revenge"),
  Item.create!(name: "Pretty Little Liars"),
  Item.create!(name: "Up All Night"),
  Item.create!(name: "Whitney"),
  Item.create!(name: "The Real Housewives of Beverly Hills"),
  Item.create!(name: "The Real Housewives of Orange County"),
  Item.create!(name: "The Real Housewives of Miami"),
  Item.create!(name: "The Real Housewives of Atlanta"),
  Item.create!(name: "The Real Housewives of New York"),
  Item.create!(name: "The Real Housewives of New Jersey"),
  Item.create!(name: "Jersey Shore"),
  Item.create!(name: "Giuliana & Bill"),
  Item.create!(name: "Greek"),
  Item.create!(name: "The Love Boat"),
  Item.create!(name: "Gilligan's Island")
].each { |item|
  list.listings.build(item_id: item.id).comments.build(user: user, content: Faker::Lorem.paragraphs(rand(3)+1).join(" "))
}
list.save!
list.approve!

list = user.lists.build(name: "Best Scary Movies Of All Time", description: 'list description for best scary movies of all time', category: movies)
[
  Item.create!(name: "It (1990)"),
  Item.create!(name: "Halloween (1978)"),
  Item.create!(name: "Halloween II (1981)"),
  Item.create!(name: "Halloween III: Season of the Witch (1982)"),
  Item.create!(name: "Halloween 4: The Return of Michael Myers (1988)"),
  Item.create!(name: "Halloween 5: The Revenge of Michael Myers (1989)"),
  Item.create!(name: "Halloween: The Curse of Michael Myers (1995)"),
  Item.create!(name: "Halloween H20: 20 Years Later (1998)"),
  Item.create!(name: "Halloween: Resurrection (2002)"),
  Item.create!(name: "Halloween (2007)"),
  Item.create!(name: "Halloween II (2009)"),
  Item.create!(name: "Friday the 13th (1980)"),
  Item.create!(name: "Friday the 13th Part 2 (1981)"),
  Item.create!(name: "Friday the 13th Part III (1982)"),
  Item.create!(name: "Friday the 13th: The Final Chapter (1984)"),
  Item.create!(name: "Friday the 13th: A New Beginning (1985)"),
  Item.create!(name: "Friday the 13th Part VI: Jason Lives (1986)"),
  Item.create!(name: "Friday the 13th Part VII: The New Blood (1988)"),
  Item.create!(name: "Friday the 13th Part VIII: Jason Take Manhattan (1989)"),
  Item.create!(name: "Jason Goes to Hell: The Final Friday (1993)"),
  Item.create!(name: "Jason X (2002)"),
  Item.create!(name: "The Dentist (1996)")
].each { |item|
  list.listings.build(item_id: item.id).comments.build(user: user, content: Faker::Lorem.paragraphs(rand(3)+1).join(" "))
}
list.save!
list.approve!

# need to generate random 10 users with the profile full_name as the email address
# need to loop all lists and vote on the top 5 listings and give comments


# need to generate user with first_name and last_name
# re-generate again if email already exists
20.times do
  profile = Fabricate.build(:profile, user: nil)
  email = "#{profile.first_name}_#{profile.last_name}@thetop5.com".underscore
  unless User.find_by_email(email)
    Fabricate(:user, email: email, password: 'thetop5', password_confirmation: 'thetop5', confirmed_at: Time.now.utc, profile: profile)
  end
end

# sample voting on list
List.all.each do |list|
  list.listings.take(5).each do |listing|
    # need to get all users exclude the owner list
    # get random number to votes this listing rand(5) + 1
    # need to get random users from the array if user already voted for this listing then shuffle it again
    num = rand(5) + 1
    users = User.find(:all, :conditions => ["id <> ?", list.user.id]).delete_if {|u| u.voted_for? list }.take(num)
    users.each do |user|
      user.vote_for(listing, 10)
      comment = user.add_comment_for(listing, Fabricate.attributes_for(:comment, user: user, content: Faker::Lorem.paragraphs(rand(3)+1).join(" ")))
      user.vote_for(comment, 1)
    end
  end
end

# sample voting on comment
Comment.all.each do |comment|
  # need to get all existing comments
  # get random number to votes on each comment rand(10) + 1
  # need to get random number of users and vote on the comment with 1 / -1
  num = rand(7) + 1
  users = User.find(:all, :conditions => ["id <> ?", comment.commentable.list.user.id]).take(num)
  users.each do |user|
    user.vote_for(comment, [1, -1].shuffle.first)
  end
end

# Forums sample seed data
ForumCategory.destroy_all
ForumCategory.create!(
  [
    { :title => "General Discussion", :position => 0 },
    { :title => "Programming Discussions", :position => 1 }
  ]
)

Forum.destroy_all
Forum.create!(
  [
    { :title => "General Discussion", :description => "Discuss any topic in this forum.", :forum_category_id => ForumCategory.find_by_title("General Discussion").id, :position => 0 },
    { :title => "Ruby on Rails", :description => "Discuss Ruby on Rails.", :forum_category_id => ForumCategory.find_by_title("Programming Discussions").id, :position => 0 },
    { :title => "PHP", :description => "Discuss PHP.", :forum_category_id => ForumCategory.find_by_title("Programming Discussions").id, :position => 1 },
    { :title => "Javascript", :description => "Discuss Javascript.", :forum_category_id => ForumCategory.find_by_title("Programming Discussions").id, :position => 2 },
    { :title => "CSS", :description => "Discuss CSS.", :forum_category_id => ForumCategory.find_by_title("Programming Discussions").id, :position => 3 }
  ]
)

# Had to do this to appease validations...
@user = User.first
@user.topics.create!( :title => "Welcome to the Forum Monster Demo.", :forum_id => Forum.find_by_title("General Discussion").id, :body => "Forum Monster is a simple forum generator written in rails 3. The goal of Forum Monster, is to provide a simple, and easy to setup forum application without having to dictate how your site it setup.\r\n\r\nLive Demo: [url]http://forum-monster.heroku.com[/url]\r\nGithub Repo for Demo: [url]http://github.com/gitt/forum_monster_demo[/url]\r\n\r\n[b]A few things about what Forum Monster is, and is not:[/b]\r\n\r\n[li]Forum Monster does not do any sort of authentication, or authorization. However, it does rely on the current_user method.[/li]\r\n[li]Forum Monster while trying to assume as little as possible, currently assumes that the following columns are available from your user model: username, and created_at.[/li]\r\n[li]Forum Monster does no authorization. By default all actions are available to all users. Even logged out users. ( Although, users who are not logged in cannot post, or create topics. )[/li]\r\n\r\n[b]Authentication[/b]\r\nForum Monster, as stated before, does not come with any authentication built in. The reason for this is so you can add a forum to your existing application without having to change the way your application works. Forum Monster knows about your user model from the moment you run the installation command.\r\n\r\n[b]Authorization[/b]\r\nForum Monster, by default, allows all access to all users. Even those that are not currently logged in. This was by design, because of the vast number of authorization methods out there. If I tried to cover all of them it would just get out of hand. Not to mention that as soon as an API changes, Forum Monster would be broken. This also provides a large amount of flexibility. For example, if you wanted to use CanCan, you can! declarative_authorization? Yep. Aegis? Indeed! Since you have Forum Monster's controllers in your main application, you can customize them for your specific solution just like the rest of your application!\r\n\r\n[b]Avatars[/b]\r\nI did not include support for avatars into Forum Monster for the same reason that authentication, and authorization were not included. Flexibility! You can use whatever you like, associate it with your user model, and put the corresponding image tag in the topic show view.\r\n\r\n[b]Markdown[/b]\r\nForum Monster has no forced support for markdown. Again, it's for flexibility.\r\n\r\n[b]Modifying the views, style, and adding your own images[/b]\r\nForum Monster will install the forum-monster.css stylesheet into your public/stylesheets directory. The views will be installed in your application app/views directory." )
@user.topics.create!( :title => "Sample Forum topic.", :forum_id => Forum.find_by_title("General Discussion").id, :body => "Forum Monster is a simple forum generator written in rails 3." )

# create requested user name
user = User.new(:email => 'james_roos@thetop5.com', :password => 'thetop5', :password_confirmation => 'thetop5')
user.skip_confirmation!
user.save!
user.profile.first_name = "James"
user.profile.last_name = "Roos"
user.save!

list = user.lists.build(name: "Top 5 Anti-Virus Software", description: 'list description for best anti-virus software', category: computers)
[
  Item.create!(name: "Kaspersky Anti-Virus"),
  Item.create!(name: "Kaspersky Lab  Kaspersky Internet Security"),
  Item.create!(name: "Symantec Norton AntiVirus"),
  Item.create!(name: "Symantec Norton Internet Security"),
  Item.create!(name: "Symantec PC Tools Free AntiVirus Protection"),
  Item.create!(name: "F-Secure Antivirus"),
  Item.create!(name: "F-Secure Internet Security"),
  Item.create!(name: "ESET NOD32 Antivirus"),
  Item.create!(name: "ESET ESET Smart Security"),
  Item.create!(name: "Softwin  Bitdefender Antivirus Plus"),
  Item.create!(name: "Softwin  Bitdefender Internet Security")
].each { |item|
  list.listings.build(item_id: item.id).comments.build(user: user, content: Faker::Lorem.paragraphs(rand(3)+1).join(" "))
}
list.save!

list = user.lists.build(name: "Top 5 Operating Systems 2013", description: 'list description for best operating systems 2013', category: computers)
[
  Item.create!(name: "Mac Apple Mountain Lion"),
  Item.create!(name: "Novell Red Hat"),
  Item.create!(name: "Atari MultiTOS"),
  Item.create!(name: "Windows 7"),
  Item.create!(name: "Linux Ubuntu")
].each { |item|
  list.listings.build(item_id: item.id).comments.build(user: user, content: Faker::Lorem.paragraphs(rand(3)+1).join(" "))
}
list.save!
