require "net/http"
require "json"

BASE = "https://www.themealdb.com/api/json/v1/1"

# Calls the API and turns the JSON text into a Ruby hash
def fetch_json(path)
  JSON.parse(Net::HTTP.get(URI("#{BASE}/#{path}")))
end

# Finds a record by name (ignoring upper/lower case), or creates it.
# FIXED: blank or nil names now become "Unknown" instead of crashing on .downcase
def by_name(model, name)
  name = name.to_s.strip                       # FIXED: nil becomes "" first
  name = "Unknown" if name.empty?              # FIXED: fallback name
  model.where("LOWER(name) = ?", name.downcase).first || model.create!(name: name)
end

# ---------- Source 1: categories ----------
puts "Importing categories..."
fetch_json("categories.php")["categories"].each do |d|
  c = Category.find_or_initialize_by(name: d["strCategory"])
  c.update(
    description:   d["strCategoryDescription"],
    thumbnail_url: d["strCategoryThumb"],
    external_id:   d["idCategory"]
  )
end

# ---------- Source 2: areas ----------
puts "Importing areas..."
fetch_json("list.php?a=list")["meals"].each do |d|
  next if d["strArea"].to_s.strip.empty?       # FIXED: skip blank area names
  by_name(Area, d["strArea"])
end

# ---------- Source 3: ingredients ----------
puts "Importing ingredients..."
fetch_json("list.php?i=list")["meals"].each do |d|
  next if d["strIngredient"].to_s.strip.empty? # FIXED: skip blank ingredient names
  i = by_name(Ingredient, d["strIngredient"])
  i.update(
    description:     d["strDescription"],
    ingredient_type: d["strType"],
    external_id:     d["idIngredient"]
  )
end

# ---------- Source 4: meals a-z, plus their ingredients and tags ----------
puts "Importing meals (a-z)... this takes a minute"
("a".."z").each do |letter|
  # The API returns {"meals": null} when no meal starts with that letter
  (fetch_json("search.php?f=#{letter}")["meals"] || []).each do |d|
    meal = Meal.find_or_initialize_by(external_id: d["idMeal"])
    meal.assign_attributes(
      name:          d["strMeal"],
      instructions:  d["strInstructions"],
      thumbnail_url: d["strMealThumb"],
      youtube_url:   d["strYoutube"],
      source_url:    d["strSource"],
      category:      by_name(Category, d["strCategory"]),  # one-to-many link
      area:          by_name(Area, d["strArea"])           # one-to-many link
    )

    # If validation fails, print why and move on to the next meal
    unless meal.save
      puts "Skipped #{d['strMeal']}: #{meal.errors.full_messages}"
      next
    end

    # Ingredients: the API uses numbered fields strIngredient1..20 / strMeasure1..20
    (1..20).each do |n|
      name = d["strIngredient#{n}"].to_s.strip
      next if name.empty?                        # unused slot
      MealIngredient.find_or_create_by!(meal: meal, ingredient: by_name(Ingredient, name)) do |mi|
        mi.measure = d["strMeasure#{n}"].to_s.strip
      end
    end

        # Tags: one comma separated string like "Meat,Casserole"
    d["strTags"].to_s.split(",").map(&:strip).reject(&:empty?).each do |t|
      MealTag.find_or_create_by!(meal: meal, tag: by_name(Tag, t))
    end
  end
  print "#{letter} "                             # progress indicator
end

# ---------- Summary ----------
puts "\nTotal rows: #{[Category, Area, Ingredient, Tag, Meal, MealIngredient, MealTag].sum(&:count)}"
# ---------- Map coordinates ----------
# TheMealDB only gives area NAMES, so we add the approximate centre of each
# country ourselves, as [latitude, longitude], for the Mapbox maps.
AREA_COORDINATES = {
  "American" => [39.8, -98.6], "British" => [54.0, -2.0], "Canadian" => [56.1, -106.3],
  "Chinese" => [35.9, 104.2], "Croatian" => [45.1, 15.2], "Dutch" => [52.1, 5.3],
  "Egyptian" => [26.8, 30.8], "Filipino" => [12.9, 121.8], "French" => [46.2, 2.2],
  "Greek" => [39.1, 21.8], "Indian" => [20.6, 78.9], "Irish" => [53.4, -8.2],
  "Italian" => [41.9, 12.6], "Jamaican" => [18.1, -77.3], "Japanese" => [36.2, 138.3],
  "Kenyan" => [-0.02, 37.9], "Malaysian" => [4.2, 102.0], "Mexican" => [23.6, -102.6],
  "Moroccan" => [31.8, -7.1], "Polish" => [51.9, 19.1], "Portuguese" => [39.4, -8.2],
  "Russian" => [61.5, 105.3], "Spanish" => [40.5, -3.7], "Thai" => [15.9, 101.0],
  "Tunisian" => [33.9, 9.5], "Turkish" => [39.0, 35.2], "Ukrainian" => [48.4, 31.2],
  "Uruguayan" => [-32.5, -55.8], "Vietnamese" => [14.1, 108.3], "Algerian" => [28.0, 1.7],
  "Argentinian" => [-38.4, -63.6], "Australian" => [-25.3, 133.8], "Norwegian" => [60.5, 8.5],
  "Saudi Arabian" => [23.9, 45.1], "Slovakian" => [48.7, 19.7], "Syrian" => [34.8, 39.0],
  "Venezulan" => [6.4, -66.6], "Venezuelan" => [6.4, -66.6]
}
AREA_COORDINATES.each do |name, (lat, lon)|
  Area.where(name: name).update_all(latitude: lat, longitude: lon)
end
puts "Areas with coordinates: #{Area.where.not(latitude: nil).count}"
