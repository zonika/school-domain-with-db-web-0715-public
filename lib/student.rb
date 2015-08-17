require 'pry'
class Student
  attr_accessor :id, :name, :tagline, :github, :twitter, :blog_url, :image_url, :biography

  def self.create_table
    sql = <<-SQL
    CREATE TABLE students (
    id INTEGER PRIMARY KEY,
    name TEXT,
    tagline TEXT,
    github TEXT,
    twitter TEXT,
    blog_url TEXT,
    image_url TEXT,
    biography TEXT
    );
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
    DROP TABLE IF EXISTS students;
    SQL
    DB[:conn].execute(sql)
  end

  def insert
    sql = <<-SQL
    INSERT INTO students (name,tagline,github,twitter,blog_url,image_url,biography)
    VALUES ("#{@name}","#{@tagline}","#{@github}","#{@twitter}","#{@blog_url}","#{@image_url}","#{@biography}");
    SQL
    DB[:conn].execute(sql)
    @id = DB[:conn].execute("SELECT id FROM students WHERE name = '#{@name}';")[0][0]
  end

  def self.new_from_db(row)
    new.tap do |instance|
      instance.id = row[0]
      instance.name = row[1]
      instance.tagline = row[2]
      instance.github = row[3]
      instance.twitter = row[4]
      instance.blog_url = row[5]
      instance.image_url = row[6]
      instance.biography = row[7]
    end
  end

  def self.find_by_name(name)
    sql = <<-SQL
    SELECT * FROM students WHERE name = "#{name}";
    SQL
    row = DB[:conn].execute(sql)
    return nil if row[0] == nil
    stu = new_from_db(row[0])
  end

  def update
    sql = <<-SQL
    UPDATE students SET name = '#{@name}'
    WHERE id = #{@id};
    SQL
    DB[:conn].execute(sql)
  end

  def save
    
  end
end
