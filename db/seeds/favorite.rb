# coding: utf-8

Favorite.destroy_all

# 絶品☆トマトチキンカレー
recipe = Recipe.find_by(title: '絶品☆トマトチキンカレー')
for num in 1..10 do
  Favorite.create(user_id: num, recipe_id: recipe[:id])
end

# ご飯が進む！豚肉の生姜焼き
recipe = Recipe.find_by(title: 'ご飯が進む！豚肉の生姜焼き')
for num in 1..9 do
  Favorite.create(user_id: num, recipe_id: recipe[:id])
end

# 基本の筑前煮
recipe = Recipe.find_by(title: '基本の筑前煮')
for num in 1..7 do
  Favorite.create(user_id: num, recipe_id: recipe[:id])
end

# 簡単！煮込みハンバーグ
recipe = Recipe.find_by(title: '簡単！煮込みハンバーグ')
for num in 1..6 do
  Favorite.create(user_id: num, recipe_id: recipe[:id])
end

# ツナときのこのトマトパスタ
recipe = Recipe.find_by(title: 'ツナときのこのトマトパスタ')
for num in 1..6 do
  Favorite.create(user_id: num, recipe_id: recipe[:id])
end

# 本格餃子
recipe = Recipe.find_by(title: '本格餃子')
for num in 1..5 do
  Favorite.create(user_id: num, recipe_id: recipe[:id])
end

# ザクザク食感が楽しい♡鶏の唐揚げ
recipe = Recipe.find_by(title: 'ザクザク食感が楽しい♡鶏の唐揚げ')
for num in 1..5 do
  Favorite.create(user_id: num, recipe_id: recipe[:id])
end

# 家で本格の味!吉野家の牛丼を再現
recipe = Recipe.find_by(title: '家で本格の味!吉野家の牛丼を再現')
for num in 1..4 do
  Favorite.create(user_id: num, recipe_id: recipe[:id])
end

# 王道のさばのみそ煮
recipe = Recipe.find_by(title: '王道のさばのみそ煮')
for num in 1..3 do
  Favorite.create(user_id: num, recipe_id: 10)
end

# ぶり大根
recipe = Recipe.find_by(title: 'ぶり大根')
Favorite.create(user_id: 1, recipe_id: 11)

# 豆腐入りフワフワお好み焼き
recipe = Recipe.find_by(title: '豆腐入りフワフワお好み焼き')
Favorite.create(user_id: 1, recipe_id: 14)
