require "csv"

Movie.delete_all
ProductionCompany.delete_all
Page.delete_all
Genre.delete_all
MovieGenre.delete_all

# get the path to the csv file
filename = Rails.root.join("db/top_movies.csv")

puts "Loading Movies from the CSV file: #{filename}"

csv_data = File.read(filename)
movies = CSV.parse(csv_data, headers: true, encoding: "UTF-8")

movies.each do |m|
  #puts m["original_title"]
  #find_or_create_by doesnt create duplicates
  production_company = ProductionCompany.find_or_create_by(name: m["production_company"])

  if production_company && production_company.valid?
    #create our movie
    movie = production_company.movies.create(
      title: m["original_title"],
      year: m["year"],
      duration: m["duration"],
      description: m["description"],
      average_vote: m["avg_vote"]
    )
    puts "invalid movie #{m['original_title']}" unless movie&.valid?

    genres = m["genre"].split(",").map(&:strip) #collection.map { |item| }
    genres.each do |genre_name|
      # puts genre_name
      genre = Genre.find_or_create_by(name: genre_name)
      # puts genre
      MovieGenre.create(movie:movie, genre: genre)
    end

  else
    puts "invalid production company #{m["production_company"]} for movie #{m['original_title']}"
  end
end
puts "Created #{ProductionCompany.count} Production companies"
puts "Created #{Movie.count} Movies"
puts "Created #{Genre.count} Genres"
puts "Created #{MovieGenre.count} Movie Genres"

Page.create(
  title: 'About the data',
  content: 'The data powering this website is brought to you by Kaggle.',
  permalink: 'About'
)
Page.create(
  title: 'Contact Us',
  content: 'If you like this site, reach out to obvsiouslyfake@fake.com',
  permalink: 'contact'
)