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

## Class Methods

### `::create_table`

This method will create a table called students with the appropriate columns.

```ruby
describe '::create_table' do
  it 'creates a table within the database' do
    table_check_sql = "SELECT tbl_name FROM sqlite_master WHERE type='table' AND tbl_name='students';"
    expect(DB[:conn].execute(table_check_sql)[0]).to be_nil

    Student.create_table
    expect(DB[:conn].execute(table_check_sql)[0]).to 'students'
  end
end
```

### `::drop_table`


### `::new_from_db`

### `::find_by_name`
### `::find_by_id`

### `::all`



`#save`
`#update`
`#insert`
`#delete`
`#attributes`
