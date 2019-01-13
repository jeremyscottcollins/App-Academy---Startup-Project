require "employee"

class Startup
    def initialize(name, funding, salaries)
        @name = name
        @funding = funding
        @salaries = salaries
        @employees = []
    end

    attr_reader :name, :funding, :salaries, :employees

    def valid_title?(title)
        @salaries.has_key?(title)
    end

    def >(another_startup)
        self.funding > another_startup.funding
    end

    def hire(employee_name, title)
        raise "title does not exist" if !self.valid_title?(title)
        
        @employees << Employee.new(employee_name, title)
    end

    def size
        @employees.length
    end

    def pay_employee(employee)
        amount = self.salaries[employee.title]
        raise "not enough funding" if amount > @funding

        employee.pay(amount)
        @funding -= amount
    end

    def payday
        @employees.each { |employee| self.pay_employee(employee) }
    end

    def average_salary
        sum = 0
        @employees.each { |employee| sum += salaries[employee.title]}
        sum / @employees.length * 1.0
    end

    def close
        @employees = []
        @funding = 0
    end

    def acquire(other_startup)
        @funding += other_startup.funding

        other_startup.salaries.each do |title, amount|
            if !@salaries.has_key?(title)
                @salaries[title] = amount
            end
        end

        @employees += other_startup.employees
        other_startup.close()
    end
end
