require 'csv'

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :user_sections
  has_many :sections, :through => :user_sections
  has_many :tests
  has_one :eneatype, dependent: :destroy
  has_and_belongs_to_many :programs

  before_create :init_tests_conf
  after_create :init_tests

  def group
    self.user_sections.first.group_number
  end

  def self.import(file)
    $m = 0
    count_errors = 0
    $mark_import = false
    #name,rut,email,password,user_type
    CSV.foreach(file.path, headers: true) do |row|
      $m = $m + 1     
      valid_name = false
      valid_surname = false
      valid_email = false
      valid_password = false
      valid_program = false
      valid_section = false
      valid_gender = false
      valid_age = false

      if row["name"] != nil && row["name"] != "" && row["name"] != " "
        valid_name = true
      end

      if row["surname"] != nil && row["surname"] != "" && row["surname"] != " "
        valid_surname = true
      end

      if row["email"] =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
        valid_email = true
      end

      if row["password"] != nil && row["password"] != "" && row["password"] != " "
        valid_password = true
      end

      if row["program"] != nil && row["program"] != "" && row["program"] != " "
        valid_program = true
      end

      if row["section"] != nil && row["section"] != "" && row["section"] != " "
        valid_section = true
      end

      if row["gender"] != nil && row["gender"] != "" && row["gender"] != " "
        valid_section = true
      end

      if row["age"] != nil && row["age"] != "" && row["age"] != " "
        valid_section = true
      end

      if valid_name == true && valid_surname == true && valid_email == true && valid_password == true && valid_program && valid_section == true
        $mensaje_numero = $m
        $mensaje_nombre = row["name"]
        $mensaje_apellido = row["surname"]
        $mensaje_correo = row["email"]
        $mensaje_clave = row["password"]
        $mensaje_section = row["section"]
        $mensaje_program = row["program"]
        $mensaje_gender = row["gender"]
        $mensaje_age = row["age"]
      else
        $mark_import = true
        #$mensaje = row
        #$mensaje = $mensaje.map(&:inspect).join(', ')
        count_errors = count_errors + 1
        @mensaje_numero = $m
        $mensaje_nombre = row["name"]
        $mensaje_apellido = row["surname"]
        $mensaje_correo = row["email"]
        $mensaje_clave = row["password"]
        $mensaje_section = row["section"]
        $mensaje_program = row["program"]
        $mensaje_gender = row["gender"]
        $mensaje_age = row["age"]
        #raise "Problemas con fila"
      end
    end

    begin
      CSV.foreach(file.path, headers: true) do |row|
        if count_errors == 0
          section = Section.find_by(code: row["section"])
          program = Program.find(row["program"])
          program.users.create!(name: row["name"], surname: row["surname"], email: row["email"], password: row["password"], sex: row["gender"].to_i, age: row["age"].to_i)
          UserSection.create!(section_id: section.id, user_id: User.last.id)
        end
      end
    rescue ActiveRecord::RecordInvalid
      $mark_import = true
      #raise "El archivo contiene datos inválidos, verifique que en las columnas 'rut' sea un RUN válido, 'email' sea un correo válido y 'user_type' contenga un rol válido (Alumno, Ayudante con permisos básicos, Ayudante con permisos intermedios, Ayudante con permisos completos, Profesor o Administrador)."
    end
  end

  def self.check(file)
    @header_csv = ["email","name","surname","password","section","program", "gender", "age"]
    csv = CSV.open(file.path, :col_sep => ",", :headers => true)
    @header_file = csv.read.headers
    @users = User.all
    i = 0
    j = 0
    $persons = []
    $mark = 0
    if @header_file == @header_csv
      CSV.foreach(file.path, headers: true) do |row|  
        @users.each do |user|
          if user.email == row["email"]
            $persons[i] = user.email
            i = i + 1
            $problem = true
            $mark = 1
          end
        end

        if !Section.find_by(code: row["section"])
          $persons[i] = row["email"]
          i = i + 1
          $problem = true
          $mark = 3
        end

      end
      $persons = $persons.map(&:inspect).join(', ')
    else
      $problem = true
      $mark = 2
    end   
  end

  def sections=(value)
    @sections = value
  end

  def init_tests
    if self.rol == 3
        for i in(1..3)
            self.tests.create(kind: i, status: true, answered: false)
        end
    end
  end

  def init_tests_conf
    if self.rol == 3
        self.accept_model = true
        self.test_count = 1
    end
end

  private  
  def self.search(search, search_rol, search_status)
    if search
      #where("UPPER(email) LIKE :q OR rol LIKE :q", q: "%#{params[:search].upcase}%")
      where([" email LIKE ? AND cast(rol as text) LIKE ? AND cast(status as text) LIKE ?",
            "%#{search}%","%#{search_rol}%","%#{search_status}%"])
    else
      all
    end
  end
end
