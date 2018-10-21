class Student
  attr_accessor :id, :name, :grade

  # create a new Student object given a row from the database
  def self.new_from_db(row)
    new_student = self.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end

  # retrieve all the rows from the "Students" database
  # remember each row should be a new instance of the Student class
  def self.all
    sql = <<-SQL
    SELECT *
    FROM students
    SQL

    DB[:conn].execute(sql).map {|row| self.new_from_db(row)}
  end

  # find the student in the database given a name
  # return a new instance of the Student class
  def self.find_by_name(name)
    self.all.find {|student| student.name == name}
  end

  # returns an array of all students in grades 9
  def self.all_students_in_grade_9
    self.all_students_in_grade_X(9)
  end

  # returns an array of all students in grades 11 or below
  def self.students_below_12th_grade
    self.all.select {|student| student.grade.to_i < 12}
  end

  # returns an array of the first X students in grade 10
  def self.first_X_students_in_grade_10(x)
    i =  0
    array = []
    loop do
      array.push(self.all_students_in_grade_X(10)[i])
      i +=1
      if i >= x
        break
      end
    end
    array
  end

  # returns the first student in grade 10
  def self.first_student_in_grade_10
    self.all_students_in_grade_X(10).first
  end

  # returns an array of all students in a given grade X
  def self.all_students_in_grade_X(x)
      self.all.select {|student| student.grade.to_i == x}
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
