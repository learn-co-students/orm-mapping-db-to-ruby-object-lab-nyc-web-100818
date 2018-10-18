class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
      new_student = self.new  # self.new is the same as running Student.new
      new_student.id = row[0]
      new_student.name =  row[1]
      new_student.grade = row[2]
      new_student

    # create a new Student object given a row from the database
  end


  def self.all
    # retrieve all the rows from the "Students" database

 #value of {} = new instance of SQLite3::Database class &how we connect to our db. db instance responds to a method 'execute' that accepts raw SQL as string
    DB[:conn].execute("SELECT * FROM STUDENTS").map do|row| 
      new_from_db(row)
    end
       #eturn [] of rows from db, matches our query--then iterate over e/ row, use self.new_from_db to CREATE new obj for e/ row!
    # remember each row should be a new instance of the Student class

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


  def self.all_students_in_grade_9

    students_arr = DB[:conn].execute("SELECT *
    FROM students WHERE grade = 9;")

  end


  def self.students_below_12th_grade

    students_arr = DB[:conn].execute("SELECT * FROM students WHERE grade < 12;")
    students_arr.map {|student| new_from_db(student) }
  end


  def self.first_X_students_in_grade_10(x)

    DB[:conn].execute("SELECT * FROM students LIMIT ?", x)

  end


  def self.first_student_in_grade_10
  student = DB[:conn].execute("SELECT * FROM students WHERE grade = 10 LIMIT 1;").flatten
  new_from_db(student)
  end
  

  def self.all_students_in_grade_X(grade)
    students_arr = DB[:conn].execute("SELECT * FROM students WHERE grade = ?", grade)
    students_arr.map {|student| new_from_db(student)}
  end

end
