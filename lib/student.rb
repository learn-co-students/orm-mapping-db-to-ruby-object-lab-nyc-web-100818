class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    new_student = Student.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end

  def self.all
    students = DB[:conn].execute("SELECT * FROM students")
    students.map {|student| new_from_db(student)}
  end

  def self.first_student_in_grade_10
      student = DB[:conn].execute("SELECT * FROM students WHERE grade = 10 LIMIT 1;").flatten
      new_from_db(student)
  end

  def self.all_students_in_grade_9
    DB[:conn].execute("SELECT * FROM students WHERE grade = 9;")
  end

  def self.all_students_in_grade_X(grade)
    students = DB[:conn].execute("SELECT * FROM students WHERE grade = ?", grade)
    students.map {|student| new_from_db(student)}
  end

  def self.students_below_12th_grade
    students = DB[:conn].execute("SELECT * FROM students WHERE grade <= 11;")

     students.map {|student| new_from_db(student) }
  end

  def self.first_X_students_in_grade_10(number)
    DB[:conn].execute("SELECT * FROM students LIMIT ?", number)
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    student = DB[:conn].execute("SELECT * FROM students WHERE name = ?", name).flatten
    new_from_db(student)
    # return a new instance of the Student class
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

  # def self.new_from_db([1, "Pat", 12])
  #   Student.new()
  # end
end
