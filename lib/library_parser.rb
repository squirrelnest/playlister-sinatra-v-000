class LibraryParser

  def self.parse
    self.new.call
  end

  def call
    files.each do |filename|
      parts = parse_filename(filename)
      build_objects(*parts)
    end
  end

  def files
    data_path = File.join(File.dirname(__FILE__), '..', 'db', 'data')
    Dir.entries(data_path)[2..-1]
  end

  def parse_filename(filename)

    # artist_match = filename.match(/^(.*)(?= -)/)
    # song_match   = filename.match(/(?<=\- )(.*)(?= \[)/)
    # genre_match  = filename.match(/(?<=\[)(.*?)(?=\])/)

    combo_match = filename.match(/(?<artist>.*) - (?<song>.*) \[(?<genre>.*)\].mp3/)
    [combo_match[:artist], combo_match[:song], combo_match[:genre]]
  end

  def build_objects(artist_name, song_name, genre_name)
    song = Song.create(name: song_name)
    genre = Genre.find_or_create_by(name: genre_name)
    artist = Artist.find_or_create_by(name: artist_name)

    song.song_genres.build(genre: genre)
    song.artist = artist

    song.save
  end
end
