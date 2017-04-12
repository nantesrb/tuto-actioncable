print 'Delete database...'
Message.destroy_all
Room.destroy_all
User.destroy_all
puts 'ok'

print 'Creating users...'
alice = User.create!(
  name:     "alice",
  email:    "alice@example.com",
  password: "password"
)

bob = User.create!(
  name:     "bob",
  email:    "bob@example.com",
  password: "password"
)
puts 'ok'

print 'Creating rooms...'
random_room = Room.create!(name: "random")
puts 'ok'

print 'creating messages...'
Message.create!(
  content: "hello Bob!",
  room: random_room,
  user: alice
)

Message.create!(
  content: "how are you Alice?",
  room: random_room,
  user: bob
)
puts 'ok'
