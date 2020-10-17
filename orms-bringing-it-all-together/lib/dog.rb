require "pry"

class Dog
  attr_accessor :id, :name, :breed

  def self.create_table
    sql = <<-SQL
CREATE TABLE dogs (
    id INTEGER PRIMARY KEY, 
    name TEXT, 
    breed TEXT
);
SQL
    DB[:conn].execute(sql)
  end
  def self.drop_table
    sql = <<-SQL
    DROP TABLE dogs
    SQL
    DB[:conn].execute(sql)
  end
  def self.new_from_db(row)
    Dog.new(name: row[1], breed: row[2], id: row[0])
  end
  def self.create(name:, breed:)
    new_dog = Dog.new(name: name, breed: breed)
    new_dog.save
    new_dog
  end
  def self.find_by_id(id)
    sql = <<-SQL
    SELECT * FROM dogs
    WHERE id = ?
    SQL
    dogs = DB[:conn].execute(sql, id)
    new_special_dog_instance = dogs.map do |row|
      Dog.new(id: row[0], name: row[1], breed: row[2])
    end
    new_special_dog_instance.first
  end
  def self.find_or_create_by
    if Dog
      Dog.create
    else
    end
  end

  def initialize(id: nil, name:, breed:)
    @name = name
    @id = id
    @breed = breed
  end

  def save
    sql = <<-SQL
    INSERT INTO dogs(name, breed)
    VALUES (?, ?)
    SQL
    DB[:conn].execute(sql, @name, @breed)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
    return self
  end
end
