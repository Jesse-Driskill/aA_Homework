require 'sqlite3'
require 'singleton'

class PlayDBConnection < SQLite3::Database
  include Singleton

  def initialize
    super('plays.db')
    self.type_translation = true
    self.results_as_hash = true
  end
end

class PlaywrightsDBConnection < SQLite3::Database
  include Singleton

  def initialize
    super('plays.db')
    self.type_translation = true
    self.results_as_hash = true
  end
end

class Play
  attr_accessor :id, :title, :year, :playwright_id

  def self.find_by_title(title)
    data = PlayDBConnection.instance.execute("SELECT * FROM plays WHERE title = '#{title}' ")
    data.map { |datum| Play.new(datum) }
  end


  def self.all
    data = PlayDBConnection.instance.execute("SELECT * FROM plays")
    data.map { |datum| Play.new(datum) }
  end

  def initialize(options)
    @id = options['id']
    @title = options['title']
    @year = options['year']
    @playwright_id = options['playwright_id']
  end

  def create
    raise "#{self} already in database" if self.id
    PlayDBConnection.instance.execute(<<-SQL, self.title, self.year, self.playwright_id)
      INSERT INTO
        plays (title, year, playwright_id)
      VALUES
        (?, ?, ?)
    SQL
    self.id = PlayDBConnection.instance.last_insert_row_id
  end

  def update
    raise "#{self} not in database" unless self.id
    PlayDBConnection.instance.execute(<<-SQL, self.title, self.year, self.playwright_id, self.id)
      UPDATE
        plays
      SET
        title = ?, year = ?, playwright_id = ?
      WHERE
        id = ?
    SQL
  end

  # def self.find_by_playwright(name)
  #   data = PlayDBConnection.instance.execute("SELECT * FROM plays WHERE playwright_id = #{name}")
  #   data.map { |datum| Play.new(datum) }
  # end

end

class Playwright
  attr_accessor :name, :birth_year, :id
  def self.all
    data = PlaywrightsDBConnection.instance.execute("SELECT * FROM playwrights")
    data.map { |datum| Playwright.new(datum) }
  end

  def self.find_by_name(name)
    data = PlaywrightsDBConnection.instance.execute("SELECT * FROM playwrights WHERE name = '#{name}' ")
    data.map { |datum| Playwright.new(datum) }
  end

  def initialize(options)
    @id = options['id']
    @name = options['name']
    @birth_year = options['birth_year']
  end

  def create
    raise "Already in database" if @id
    PlaywrightsDBConnection.instance.execute(<<-SQL, @name, @birth_year)
    INSERT INTO
      playwrights (name, birth_year)
    VALUES
      (?, ?)
    SQL
    self.id = PlaywrightsDBConnection.instance.last_insert_row_id
  end

  def update
    raise "Does not exist in database" unless @id
    PlaywrightsDBConnection.instance.execute(<<-SQL, self.name, self.birth_year, self.id)
    UPDATE
      playwrights
    SET
      name = ?, birth_year = ?
    WHERE
      id = ?
    SQL
  end

  def get_plays
  end
end


#p Play.find_by_title("Long Day''s Journey Into Night")
#p Playwright.all
#p Playwright.find_by_name("Arthur Miller")

#p Playwright.all

# joe = Playwright.new("name" => "Joe", "birth_year" => 3000)
# joe.birth_year = 3
# p Playwright.all

# p joe
# joe.create
# p Playwright.all
# joe.birth_year = 2
# joe.update
p Playwright.all

