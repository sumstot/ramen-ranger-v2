puts 'Destroying all reviews and restaurants'
Restaurant.destroy_all
RamenReviews.destroy_all

puts 'Generating new restaurants'

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
index = 1
address_index = 0
names_index = 0

names = ['Zen Laboratory', 'Buta no Hoshi', 'Kobe Gyu Ramen Yazawa', 'Kamigata Rainbow', 'Tonkotsu Mazesoba Kozou+', 'Menya Teru Nakatsu', 'Strike Ken', 'Menya New Classic', 'SPICExRAMEN SUSUSU', 'Moeyo Mensuke' ]
jpn_names = ['(善ラボラトリー)', ' (ぶたのほし)', '(神戸牛らーめん八坐)', '(上方レインボー)', '(豚骨まぜそばKOZOU＋)', '(麺や輝中津店)', '(ストライク軒)', '(メンヤニュークラシック)', '(SPICExRAMENススス)',  '(燃えよ麺助)' ]
10.times do
  restaurant = Restaurant.create!(
    name: names[names_index],
    jpn_name: jpn_names[names_index],
    year_opened: rand(1970..2022)
  )
  restaurant.address = addresses[address_index]
  restaurant.prefecture = %w[Osaka Wakayama Kyoto Hyogo Tokyo].sample
  restaurant.station = %w[Sannomiya Umeda Fukushima Shibuya Kawaramachi Amagasaki].sample
  restaurant.save
  names_index += 1
  address_index += 1
end

puts 'Generating reviews'
soup = %w[niboshi tonkotsu shoyu shio tantanmen miso chukasoba sokisoba]
20.times do
  ramen_review = RamenReview.create!(
    soup: soup.sample,
    score: rand(3.0..5.0),
    restaurant_id: Restaurant.all.sample.id
  )
  ramen_review.description = "This is a unique #{ramen_review.soup} ramen"
  ramen_review.review = "A solid bowl of #{ramen_review.soup} ramen"
  ramen_review.score = ramen_review.score.round(1)
  ramen_review.images.attach(
    io: File.open(File.join(Rails.root, "app/assets/images/ramen/ramen#{index}.jpg")),
    filename: "ramen#{index}.jpg"
  )
  index += 1
  ramen_review.save
end

puts "Generated #{Restaurant.all.count} restaurants and #{RamenReview.all.count} bowls of ramen"
