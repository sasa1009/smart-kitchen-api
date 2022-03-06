# coding: utf-8

Relationship.destroy_all

followUser = User.find(1)
for num in 1..6 do
  if followUser[:id] != num
    followedUser = User.find(num)
    followUser.follow(followedUser)
  end
end

followUser = User.find(2)
for num in 3..7 do
  if followUser[:id] != num
    followedUser = User.find(num)
    followUser.follow(followedUser)
  end
end

followUser = User.find(3)
for num in 1..4 do
  if followUser[:id] != num
    followedUser = User.find(num)
    followUser.follow(followedUser)
  end
end

followUser = User.find(4)
for num in 1..10 do
  if followUser[:id] != num
    followedUser = User.find(num)
    followUser.follow(followedUser)
  end
end

followUser = User.find(5)
for num in 1..3 do
  if followUser[:id] != num
    followedUser = User.find(num)
    followUser.follow(followedUser)
  end
end

followUser = User.find(6)
for num in 5..10 do
  if followUser[:id] != num
    followedUser = User.find(num)
    followUser.follow(followedUser)
  end
end

followUser = User.find(7)
for num in 4..8 do
  if followUser[:id] != num
    followedUser = User.find(num)
    followUser.follow(followedUser)
  end
end

followUser = User.find(8)
for num in 1..3 do
  if followUser[:id] != num
    followedUser = User.find(num)
    followUser.follow(followedUser)
  end
end

followUser = User.find(9)
for num in 7..10 do
  if followUser[:id] != num
    followedUser = User.find(num)
    followUser.follow(followedUser)
  end
end

followUser = User.find(10)
for num in 4..7 do
  if followUser[:id] != num
    followedUser = User.find(num)
    followUser.follow(followedUser)
  end
end
