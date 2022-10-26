# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'faker'


# Carreras
inst = Institution.create(name: "Universidad de Santiago de Chile")

program1 = Program.create!(name: "Administración Pública", institution: inst)#0
program2 = Program.create!(name: "Ingeniería Ambiental", institution: inst) #1
program3 = Program.create!(name: "Ingeniería Civil en Electricidad", institution: inst) #2
program4 = Program.create!(name: "Ingeniería Civil en Geografía", institution: inst) #3<
program5 = Program.create!(name: "Ingeniería Civil en Industria", institution: inst) #4
program6 = Program.create!(name: "Ingeniería Civil en Informática", institution: inst) #5
program7 = Program.create!(name: "Ingeniería Civil en Mecánica", institution: inst) #6
Program.create!(name: "Ingeniería Civil en Metalurgia", institution: inst) #7
Program.create!(name: "Ingeniería Civil en Minas", institution: inst) #8
Program.create!(name: "Ingeniería Civil en Obras Civiles", institution: inst) #9
Program.create!(name: "Ingeniería Civil en Química", institution: inst) #10
program = Program.create!(name: "Ingeniería de Ejecución en Computación e Informática", institution: inst) #11
Program.create!(name: "Ingeniería de Ejecución en Minas", institution: inst) #12
Program.create!(name: "Ingeniería de Ejecución en Electricidad", institution: inst) #13
Program.create!(name: "Ingeniería de Ejecución en Geomensura", institution: inst) #14
Program.create!(name: "Ingeniería de Ejecución en Industria", institution: inst) #15
Program.create!(name: "Ingeniería de Ejecución en Mecánica", institution: inst) #16
Program.create!(name: "Ingeniería de Ejecución en Metalurgia", institution: inst) #17
Program.create!(name: "Ingeniería de Ejecución en Química", institution: inst) #18

programs = Program.limit(10)

# Secciones
subject = Subject.create!(name: "Gobierno y Gestión usando NIST", code: "GGNIST")
#subject = Subject.last
#type = CourseType.find(3)
type = CourseType.create!(name: "Cátedra")
type1 = CourseType.create!(name: "Laboratorio")
course = Course.create!(subject: subject, course_type: type, code: 'TEST-1', semester: 2, year: 2017)

(1..20).each do |index|
    name = Faker::Name.first_name
    surname = Faker::Name.last_name
    email = name + surname + "@mail.com"
    gender = [0, 1].sample
    age = rand(25..50)
    user = User.create!(email: email,name: name ,surname: surname, rol: 3 ,status: true ,password: '111111',password_confirmation: '111111', sex: gender, age: age,  accept_model: true)
    user.courses << course
    user.programs << programs.sample
    user.save
    eneatype = rand(1..9)
    Eneatype.create!(user: user, number: eneatype, score: 69)
    for i in(1..3)
        test = user.tests.find_by(kind: i)
        test.answered = true
        test.save
        if i == 1
            Answer.create(test: test, element_kind: eneatype, number: 1, answer: eneatype)
        else
            type_test = i == 2 ? 1 : 0
            randomUsers = [1..20].sample(5)
            randomUsers.each do |u|
                Answer.create(test: test  , element_kind: type_test, number: u, answer: 1)
                Answer.create(test: test  , element_kind: type_test, number: u, answer: 0)
            end
        end
    end
end


# Coordinadores
coord = program.users.create!(email: 'coordinador@mail.com',name: 'Juan' ,surname: 'Gómez' , rol: 0 ,status: true ,password: '111111',password_confirmation: '111111')
coord.courses << course
# Profesores
profe = program.users.create!(email: 'profesor@mail.com',name: 'Juan' ,surname: 'Araya' , rol: 1 ,status: true ,password: '111111',password_confirmation: '111111')
profe.courses << course
# Ayudantes
ayu = program.users.create!(email: 'ayudante@mail.com',name: 'Emma' ,surname: 'Watson' , rol: 2 ,status: true ,password: '111111',password_confirmation: '111111')
ayu.courses << course
# Estudiantes
estu = program.users.create!(email: 'estudiante@mail.com',name: 'Franco' ,surname: 'Gotelli' , rol: 3 ,status: true ,password: '111111',password_confirmation: '111111')
estu.courses << course

