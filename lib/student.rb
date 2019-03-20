require 'pry'
class Student
  # @@all =[]
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    # binding.pry
    # Student.new(row[0],row[1],row[2])
    # self.new(row[0],row[1],row[2])
    # @id = row[0]
    # @name = row[1]
    # @grade = row[2]
    stude = self.new
    stude.id = row[0]
    stude.name = row[1]
    stude.grade = row[2]
    stude

  end

  # def initialize(id, name, grade)
  #   @id = id
  #   @name = name
  #   @grade = grade
  #   @@all << self
  # end
  def self.all_students_in_grade_9
    yeet = self.all
    # binding.pry
    yeet.select{|stude| stude.grade == '9'}
  end

  def self.all_students_in_grade_X(x)
    self.all.select{|stude| stude.grade.to_i == x.to_i}
  end

  def self.students_below_12th_grade
    self.all.select{|stude| stude.grade.to_i <= 11}
  end

  def self.first_student_in_grade_10
    self.all_students_in_grade_X(10).first
  end

  def self.first_X_students_in_grade_10(x)
    self.all_students_in_grade_X(10)[0...x]
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
      SELECT * FROM students
    SQL
    all_students = DB[:conn].execute(sql)
    all_students.map{|stude| self.new_from_db(stude)}
    # binding.pry
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
      SELECT * FROM students
      WHERE name = ?
    SQL
    yeet = DB[:conn].execute(sql, name)[0]
    # binding.pry
    self.new_from_db(yeet)

  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
