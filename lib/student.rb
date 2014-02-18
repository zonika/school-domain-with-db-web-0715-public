class Student
  attr_accessor :id, :name, :tagline, :github, :twitter, :blog_url, :image_url, :biography

  def self.create_table
    sql = "CREATE TABLE IF NOT EXISTS students (id INTEGER PRIMARY KEY, name TEXT, tagline TEXT, github TEXT, twitter TEXT, blog_url TEXT, image_url TEXT, biography TEXT)"
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end    

  def self.new_from_db(row)
    s = self.new
    s.id = row[0]
    s.name = row[1]
    s.tagline = row[2]
    s.github = row[3]
    s.twitter = row[4]
    s.blog_url = row[5]
    s.image_url = row[6]
    s.biography = row[7]
    s
  end

  def self.find_by_name(name)
    sql = "SELECT * FROM students WHERE name = ?"
    result = DB[:conn].execute(sql, name)[0]
    if result
      self.new_from_db(result)
    else
      nil
    end
  end

  def insert
    sql = "INSERT INTO students (name, tagline, github, twitter, blog_url, image_url, biography) VALUES (?,?,?,?,?,?,?)"
    DB[:conn].execute(sql, name, tagline, github, twitter, blog_url, image_url, biography)

    id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    self.id = id
  end

  def update
    sql = "UPDATE students SET name = ?, tagline = ?, github = ?, twitter = ?, blog_url = ?, image_url = ?, biography = ? WHERE id = ?"
    DB[:conn].execute(sql, name, tagline, github, twitter, blog_url, image_url, biography, id)
  end    

  def save
    if self.id
      update
    else
      insert
    end
  end
end
