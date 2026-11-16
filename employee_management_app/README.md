# Employee Management (Ruby on Rails)

A small Rails MVC application to manage employees, managers, departments, and reporting relationships.

## Features

- Create, list, view, update, and delete employees
- Create, list, update, and delete managers and departments
- Employee ID, name, work email, phone, department, job title, salary, and joining date
- Employees belong to a department and can optionally report to a manager
- Initial setup requires creating a manager before employees
- Model validations, case-normalized unique emails, and email/phone format checks
- SQLite database and basic model/controller tests

## Requirements

- Ruby 3.2.x
- Bundler
- A working Rails 7.1-compatible environment

## Run locally

From this directory:

```bash
bundle install
bin/rails db:prepare
bin/rails server
```

Open http://localhost:3000.

Run tests with:

```bash
bin/rails test
```

## Routes

```bash
bin/rails routes
```

Main routes are `GET /employees`, `GET /employees/new`, `POST /employees`, `GET /employees/:id`, `GET /employees/:id/edit`, `PATCH /employees/:id`, and `DELETE /employees/:id`. The root page is the employee list.

## Manager and department associations

`employees.manager_id` is a nullable foreign key to `managers.id`, and `employees.department_id` points to `departments.id`. Employees may be top-level and therefore have no assigned manager, but every employee must belong to a department. Deleting a manager clears the manager assignment on their employees; departments with employees cannot be deleted until those employees are reassigned.

## Important notes

- This is a starter application, not a production-hardened HR system. Authentication/authorization, audit history, pagination, and production database configuration should be added before real organizational use.
- Managers are maintained as their own records rather than being represented by employees.
- The salary field is optional and shown in Indian rupees in the detail view; adapt currency/precision to your organization's requirements.
