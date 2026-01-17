# Capital Family Clinic

## Clinic Appointment Management System

A Flask-based web application for managing patients, appointments, tests, and clinics with a MySQL database backend.

## Technologies
- Python, Flask
- MySQL
- GitHub Actions (CI/CD) 

## Setup

### Environment Variables

Create a `.env` file in your project root and populate it with your database credentials and secret key. Example:

```env
HOST=""
PORT=""
USER=""
PASSWORD=""
DB=""
SECRET_KEY=""
```

In this project, the MySQL database is hosted on Aiven.

### Populate database
1. DDL.sql → Creates tables and schema
2. CALL sp_load_clinicdb(); → Loads stored procedures
3. DML.sql → Populates initial data
4. PL.sql → Additional procedures or triggers

### Set up Environment
```
# Create virtual environment
python -m venv .venv

# Activate environment
source .venv/Scripts/activate  # Windows
# or
source .venv/bin/activate      # Linux/macOS

# Install dependencies
pip install -r requirements.txt
```