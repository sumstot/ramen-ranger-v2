puts 'Destroying admin'
User.where(admin: true).destroy_all

puts 'Destroying all reviews and restaurants'
Restaurant.destroy_all
RamenReview.destroy_all

puts 'Generating admin'
User.find_or_create_by!(email: 'soren@example.com') do |user|
  user.username = 'the_ramen_ranger'
  user.password = 'securepassword'
  user.password_confirmation = 'securepassword'
  user.admin = true
end

# puts 'Generating new restaurants'

# addresses = [
#   "3-1-15 Mitsuyakita Yodogawa Ku, Osaka", # kirimen
#   "1-2-2 Minamimorimachi Kita Ku, Osaka", # hayato
#   "25-4 Mibuaiaicho Nakagyo Ku, Kyoto", #X seabura no kami
#   "1-5-1 Nakatsu Kita Ku, Osaka", # menya new classic
#   "5-12-21 Fukushima Fukushima Ku, Osaka", # moeyo mensuke
#   "1-16 Nagasunishidori Amagasaki, Hyogo", #X buta no hoshi
#   "1-11-5 Shibata Kita Ku, Osaka", # zen labs
#   "1-2 Fukushima Fukushima Ku, Osaka", #X kozou +
#   "4-6-3 Katsuyama Tennoji Ku, Osaka", # kamigata rainbow
#   "2-11-1 Sannomiyacho Chuo Ku, Kobe" # kobe gyu ramen yazawa
# ]
# index = 1
# address_index = 0
# names_index = 0

# names = ['Zen Laboratory', 'Buta no Hoshi', 'Kobe Gyu Ramen Yazawa', 'Kamigata Rainbow', 'Tonkotsu Mazesoba Kozou+', 'Menya Teru Nakatsu', 'Strike Ken', 'Menya New Classic', 'SPICExRAMEN SUSUSU', 'Moeyo Mensuke' ]
# jpn_names = ['善ラボラトリー', 'ぶたのほし', '神戸牛らーめん八坐', '上方レインボー', '豚骨まぜそばKOZOU＋', '麺や輝中津店', 'ストライク軒', 'メンヤニュークラシック', 'SPICExRAMENススス',  '燃えよ麺助' ]
# 10.times do
#   restaurant = Restaurant.new(
#     name: names[names_index],
#     jpn_name: jpn_names[names_index],
#     date_opened: Date.new(rand(1970..2022)),
#     address: addresses[address_index],
#     prefecture: %w[Osaka Wakayama Kyoto Hyogo Tokyo].sample,
#     station: %w[Sannomiya Umeda Fukushima Shibuya Kawaramachi Amagasaki].sample
#   )

#   selected_days = %i[monday tuesday wednesday thursday friday saturday sunday holiday].sample(2)
#   restaurant.days_closed = selected_days

#   unless restaurant.save!
#     puts "Failed to save restaurant: #{restaurant.errors.full_messages.join(', ')}"
#   end
#   names_index += 1
#   address_index += 1
# end

puts 'Generating new restaurants with debugging'

addresses = [
  "3-1-15 Mitsuyakita Yodogawa Ku, Osaka", # kirimen
  "1-2-2 Minamimorimachi Kita Ku, Osaka", # hayato
  "25-4 Mibuaiaicho Nakagyo Ku, Kyoto", #X seabura no kami
  "1-5-1 Nakatsu Kita Ku, Osaka", # menya new classic
  "5-12-21 Fukushima Fukushima Ku, Osaka", # moeyo mensuke
  "1-16 Nagasunishidori Amagasaki, Hyogo", #X buta no hoshi
  "1-11-5 Shibata Kita Ku, Osaka", # zen labs
  "1-2 Fukushima Fukushima Ku, Osaka", #X kozou +
  "4-6-3 Katsuyama Tennoji Ku, Osaka", # kamigata rainbow
  "2-11-1 Sannomiyacho Chuo Ku, Kobe" # kobe gyu ramen yazawa
]

names = ['Zen Laboratory', 'Buta no Hoshi', 'Kobe Gyu Ramen Yazawa', 'Kamigata Rainbow', 'Tonkotsu Mazesoba Kozou+', 'Menya Teru Nakatsu', 'Strike Ken', 'Menya New Classic', 'SPICExRAMEN SUSUSU', 'Moeyo Mensuke']
jpn_names = ['善ラボラトリー', 'ぶたのほし', '神戸牛らーめん八坐', '上方レインボー', '豚骨まぜそばKOZOU＋', '麺や輝中津店', 'ストライク軒', 'メンヤニュークラシック', 'SPICExRAMENススス', '燃えよ麺助']

index = 1
address_index = 0
names_index = 0

# Test enumerize configuration first
puts "Testing enumerize configuration:"
puts "Available days: #{Restaurant.days_closed.values}"
puts "Default value: #{Restaurant.new.days_closed}"

10.times do
  puts "\n=== Creating restaurant #{names_index + 1} ==="

  restaurant = Restaurant.new(
    name: names[names_index],
    jpn_name: jpn_names[names_index],
    date_opened: Date.new(rand(1970..2022)),
    address: addresses[address_index],
    prefecture: %w[Osaka Wakayama Kyoto Hyogo Tokyo].sample,
    station: %w[Sannomiya Umeda Fukushima Shibuya Kawaramachi Amagasaki].sample
  )

  puts "Restaurant created, initial days_closed: #{restaurant.days_closed.inspect}"
  puts "Raw attribute before assignment: #{restaurant.read_attribute(:days_closed)}"

  selected_days = %i[monday tuesday wednesday thursday friday saturday sunday holiday].sample(2)
  puts "Selected days: #{selected_days.inspect}"

  # Try different assignment methods
  restaurant.days_closed = selected_days
  puts "After assignment - days_closed: #{restaurant.days_closed.inspect}"
  puts "Raw attribute after assignment: #{restaurant.read_attribute(:days_closed)}"

  # Check if restaurant is valid
  puts "Restaurant valid? #{restaurant.valid?}"
  if !restaurant.valid?
    puts "Validation errors: #{restaurant.errors.full_messages}"
  end

  if restaurant.save
    puts "Restaurant saved successfully"
    restaurant.reload
    puts "After reload - days_closed: #{restaurant.days_closed.inspect}"
    puts "Raw attribute after reload: #{restaurant.read_attribute(:days_closed)}"
  else
    puts "Failed to save restaurant: #{restaurant.errors.full_messages.join(', ')}"
  end

  names_index += 1
  address_index += 1
end

# Test with a simple example
puts "\n=== Testing simple assignment ==="
test_restaurant = Restaurant.new(
  name: "Test Restaurant",
  jpn_name: "テスト",
  address: "Test Address",
  prefecture: "Test"
)

puts "Before assignment: #{test_restaurant.days_closed.inspect}"
test_restaurant.days_closed = [:monday, :friday]
puts "After assignment: #{test_restaurant.days_closed.inspect}"

if test_restaurant.save
  puts "Test restaurant saved"
  test_restaurant.reload
  puts "After reload: #{test_restaurant.days_closed.inspect}"
end

puts 'Generating reviews'
soup = %w[Niboshi Tonkotsu Shoyu Shio Tantanmen Miso Chukasoba Sokisoba]
20.times do
  ramen_review = RamenReview.create!(
    soup: soup.sample,
    score: rand(3.0..5.0),
    restaurant_id: Restaurant.all.sample.id
  )
  ramen_review.review = "A solid bowl of #{ramen_review.soup} ramen"
  ramen_review.score = ramen_review.score.round(1)
  3.times do
    ramen_review.review_images.build.image.attach(
      io: File.open(File.join(Rails.root, "app/assets/images/ramen/ramen#{index}.jpg")),
      filename: "ramen#{index}.jpg"
    )
    index == 20 ? index = 1 : index += 1
  end
  ramen_review.save
end

puts "Generated #{Restaurant.all.count} restaurants and #{RamenReview.all.count} bowls of ramen"
