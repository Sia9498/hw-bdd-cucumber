# Add a declarative step here for populating the DB with movies.

Given (/the following movies exist/ ) do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(movie)
  end
  # fail "Unimplemented"
end

Then (/(.*) seed movies should exist/) do | n_seeds |
  expect(Movie.count).to eq n_seeds.to_i
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then (/I should see "(.*)" before "(.*)"/) do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  m1 = e1.delete_prefix('"').delete_suffix('"')
  m2 = e2.delete_prefix('"').delete_suffix('"')
  expect(/#{m1}.*#{m2}/m).to match(page.body)
  # fail "Unimplemented"
end

When (/I click on 'Refresh' button/) do
  click_button('Refresh')
end

Then (/I should (not )?see the movies: (.*)$/) do |x, movies_list|
  movies = movies_list.split(', ')
  movies.each do |movie|
    movie_name = movie.delete_prefix('"').delete_suffix('"')
    if x
      expect(page).not_to have_content(movie_name)
    else
      expect(page).to have_content(movie_name)
    end
  end
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When (/I (un)?check the following ratings: (.*)/) do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  selected_ratings = rating_list.split(', ')
  selected_ratings.each do |rating|
    if uncheck 
        uncheck("ratings[#{rating}]")
    else
        check("ratings[#{rating}]")
    end
  end
  # fail "Unimplemented"
end

Then (/I should see all the movies/) do
  # Make sure that all the movies in the app are visible in the table
  total_movies = Movie.count
  total_rows = page.all('table#movies tbody tr').count
  expect(total_rows).to eq total_movies
  # fail "Unimplemented"
end
