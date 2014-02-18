class Student

  def self.create_table
    sql = "CREATE TABLE IF NOT EXISTS students (id INTEGER PRIMARY KEY, name TEXT)"
    DB[:conn].execute(sql)
  end
end
