require 'pry'
class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    student = Student.new

    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.all
    sql = <<-SQL
      SELECT * FROM students
    SQL

    table_array = DB[:conn].execute(sql)
    table_array.map {|row| self.new_from_db(row)}
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students
      WHERE name = ? LIMIT 1
    SQL
    row = DB[:conn].execute(sql, name)[0]
    self.new_from_db(row)
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

  def self.all_students_in_grade_9
    grade = 9
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = ?
    SQL

    student_array = DB[:conn].execute(sql, grade)
    student_array.map {|row| Student.new_from_db(row)}
  end

  def self.students_below_12th_grade
    grade = 12
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade != ?
    SQL

    student_array = DB[:conn].execute(sql, grade)
    student_array.map {|row| Student.new_from_db(row)}
  end

  def self.first_X_students_in_grade_10(x)
    grade = 10
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = ?
      LIMIT ?
    SQL

    student_array = DB[:conn].execute(sql, grade, x)
    student_array.map {|row| Student.new_from_db(row)}
  end

  def self.first_student_in_grade_10
    grade = 10
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = ?
      LIMIT 2
    SQL

    student = Student.new_from_db(DB[:conn].execute(sql, grade)[0])
  end

  def self.all_students_in_grade_X(grade)
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = ?
    SQL

    student_array = DB[:conn].execute(sql, grade)
    student_array.map {|row| Student.new_from_db(row)}
  end
  
end
