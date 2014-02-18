---
  tags: sqlite, orm, object orientation
  languages: sql, ruby
---

# Basic Student ORM

This lab involves building a basic ORM for a Student. As you've learned, an ORM is an Object Relational Mapper, basically a class that acts as an analogy for how our instances correspond to rows in a database. It wraps the functionality of the database into our class.

Will define a `Student` class that includes behaviors of a basic ORM.

## Environment

Our environment is going to be a single point of requires and loads. 

### `DB[:conn]`

Additionally, our environment is going to define a constant, `DB`, that will be equal to a hash, with a single key, `:conn`, that represents our database connection. This key will have a value of a connection to a sqlite3 database in the db directory. However, in our spec_helper, our testing environment, we're going to redefine the value of that key (not of the constant though) to point to an in-memory database. This will allow our tests to run in isolation of our production database. Whenever we want to refer to the applications connection to the database, we will simply rely on `DB[:conn]`.

## The Spec Suite

### Attributes

The first test is just about making sure that our students have all the required attributes and that they are readable and writeable.

#### BONUS

1. How can this be refactored, both in the test and within the Student class? There is a powerful pattern here, see if you can see it.

### `::create_table`

This method will create a table called students with the appropriate columns.

```ruby
describe '::create_table' do
  it 'creates a student table' do
    Student.drop_table
    Student.create_table

    table_check_sql = "SELECT tbl_name FROM sqlite_master WHERE type='table' AND tbl_name='students';"
    expect(DB[:conn].execute(table_check_sql)[0]).to eq(['students'])
  end
end
```

In our test, we first basically make sure that our database is blank by calling the soon to be defined `drop_table` method. It sort of makes sense to get these two tests to pass together. Imagine if the `create_table` method did nothing but for whatever reason, the table already existed. Simply testing the existence of the table is not enough, we must first explicitly check that the table didn't exist to begin and that it only exists after.

How we're testing whether a table exists is sort of SQLite3 specific, but basically, sqlite keeps a table called `sqlite_master` that describes the rest of the database / schema. Thus if there is another table in the SQLite database, it will be represented as a row within sqlite_master.

![sqlite_master](http://dl.dropboxusercontent.com/s/j98mxmd5d4uec9g/2014-02-18%20at%2011.21%20AM.png)

We just query that the sqlite_master table is empty at the start of the test,
and then after calling `Student.create_table`, we expect the same query we ran at first to return the value of the tbl_name column, which should be `students`.

Your job is to define a class method on `Student` that will execute the correct SQL to create a students table.

### `::drop_table`

This method will drop the students table from the database.

```ruby
describe '::drop_table' do
  it "drops the student table" do
    Student.create_table
    Student.drop_table

    table_check_sql = "SELECT tbl_name FROM sqlite_master WHERE type='table' AND tbl_name='students';"
    expect(DB[:conn].execute(table_check_sql)[0]).to be_nil
  end
end
```

It basically is the exact opposite of the previous test, in fact, it relies on the `create_table` method to ensure that the table exists before we attempt to drop it (again, preventing false positives). 

Your job is to define a class method on `Student` that will execute the correct SQL to drop a students table.

#### BONUS

1. Think about removing the duplication from these tests.
2. Is there a useful method missing from the `Student` class that would further simplify this test?
3. How does the order the tests run in impact the results? In fact, this is a big problem that has actually be solved in this code base - find the solution.

### `#insert` do

This method will do the heavy lifting of inserting a student instance into the database.

The test simply instantiates a student and then calls insert. The expectation is that if we then run a simple SELECT looking for that student by name (I know, not the best thing to measure, but it'll do), we should find a row with that very data.

The second test in the insert describe block is a bit more abstract. The basic premise is that after we insert a student into the database, the database has assigned it an auto-incrementing primary key. We have to update the current instance with this ID value otherwise this instance does not fully mirror the current state in the DB. To implement this behavior, you will need to know how to ask SQLite3 for the last inserted ID in a table, which would be: `SELECT last_insert_rowid() FROM students` [law_insert_rowid()](http://www.sqlite.org/lang_corefunc.html#last_insert_rowid)

#### BONUS

1. How many times do you think we'll repeat and collect the various attributes of a student? How many places does that information live right now (so if we wanted to add an attribute, how many changes to our code would we need)? Can you think of a better way?

### `::new_from_db`

This is an interesting method. Ultimately, the database is going to return an array representing a student's data. We need a way to cast that data into the appropriate attributes of a student. This method encapsulates that functionality. You can even think of it as new_from_array. Methods like this, that return instances of the class, are known as constructors, just like `::new`, except that they extend the functionality of `::new` without overwriting `initializee`

#### BONUS

1. Why do we build new_from_db and not just use initialize?

### `::find_by_name`

This spec will first insert a student into the database and then attempt to find it by calling the find_by_name method. The expectations are that an instance of the student class that has all the properties of a student is returned, not primitive data.

Internally, what will the find_by_name method do to find a student, which SQL statement must it run? Additionally, what method might find_by_name use internally to quickly take a row and create an instance to represent that data?

### `#update`

This spec will create and insert a student and after will change the name of the student instance and call update. The expectations are that after this operation there is no student left over in the database with the old name. If we query the database for a student with the new name, we should find that student and the ID of that student should be the same as the original, signifying this is the same student, they just changed their name.

`#save`

This spec ensures that given an instance of a student, simply calling save will trigger the correct operation. To implement this, you will have to figure out a way for an instance to determine whether it has been persisted into the DB.

In the first test we create an instance, specify, since it has never been saved before, that the instance will receive a method call to `insert`.

In the next test, we create an instane, save it, change it's name, and then specify that a call to the save method should trigger an `update`.

### BONUSES

#### `::all`

Implement and test a `Student.all` method that returns all instance.

#### `#delete`

Implement and test deleting a student.

#### `#==`

Teach and test that students coming out of the database are equal to each other even though the objects are different.

#### Prevent ID manipulation

Students should not be allowed to change their ids.

#### More Finders

Build a find_by method for every attribute, find_by_id, find_by_github, etc. Deal with multiple matches