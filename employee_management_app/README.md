# Employee Management (Ruby on Rails)

A small Rails MVC application to manage employees and their reporting relationships.

## Features

- Create, list, view, update, and delete employees
- Employee ID, name, work email, phone, department, job title, salary, and joining date
- Optional manager field pointing to another employee
- Direct reports listed on the manager's employee page
- Model validations, case-normalized unique emails, and self/cycle reporting checks
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

## Manager association

`employees.manager_id` is a nullable foreign key to `employees.id`. In `Employee`, `belongs_to :manager, class_name: "Employee", optional: true` links one employee to their manager; `has_many :subordinates` retrieves their direct reports. A manager can be left blank for top-level employees. Deleting a manager leaves their direct reports in the system and clears their manager assignment.

## Important notes

- This is a starter application, not a production-hardened HR system. Authentication/authorization, audit history, pagination, and production database configuration should be added before real organizational use.
- The manager dropdown excludes the employee being edited, and model validations guard against self-management and reporting cycles.
- The salary field is optional and shown in Indian rupees in the detail view; adapt currency/precision to your organization's requirements.
