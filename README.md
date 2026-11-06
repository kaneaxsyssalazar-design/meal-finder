1.1 Dataset description

Data source: TheMealDB (https://www.themealdb.com/api.php), a free JSON recipe API. I use the public test key 1, so no sign-up is needed.

Endpoints used

Endpoint	What it returns	Becomes
categories.php	About 14 meal categories with description and picture	categories
list.php?a=list	About 30 areas (cuisines)	areas
list.php?i=list	Several hundred ingredients with descriptions	ingredients
search.php?f=a to f=z	Every meal, with instructions, picture, tags and up to 20 ingredient/measure pairs	meals, meal_ingredients, tags, meal_tags

How the data is structured: each meal is a flat JSON object. Ingredients are numbered fields (strIngredient1, strMeasure1, up to 20), and tags are one comma-separated string like "Meat,Casserole". My seed script turns these into relational tables.

Tables and columns

categories: name, description, thumbnail_url, external_id
areas: name, latitude, longitude
ingredients: name, description, ingredient_type, external_id
tags: name
meals: name, instructions, thumbnail_url, youtube_url, source_url, external_id, category_id, area_id
meal_ingredients (join table): meal_id, ingredient_id, measure
meal_tags (join table): meal_id, tag_id

How the sources are related and integrated

Each meal has a category name and an area name. The seed script matches them to rows from the categories and areas sources and stores category_id and area_id (one-to-many).
Each numbered ingredient field in a meal is matched by name, ignoring case, to a row from the ingredients source. This creates a meal_ingredients row that also keeps the measure (many-to-many).
The tags string is split on commas, creating tags and meal_tags rows (many-to-many).
The API’s own ids are stored only as external_id. Rails creates its own primary and foreign keys.