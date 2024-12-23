# Use an official Python runtime as a parent image
FROM python:3.12-slim

# Install pipenv
RUN pip install pipenv

# Set the working directory in the container
WORKDIR /app

# Copy the Pipfile and Pipfile.lock first (this improves Docker cache utilization)
COPY Pipfile Pipfile.lock /app/

# Install dependencies from Pipfile using pipenv
RUN pipenv install --deploy --ignore-pipfile

# Copy the rest of the application
COPY . /app

# Expose port 5000 for Flask app
EXPOSE 5001

# Set environment variable to ensure Flask runs in production mode
ENV FLASK_APP=flaskr:create_app
ENV FLASK_RUN_HOST=0.0.0.0

# Use Gunicorn to run the Flask app in production mode
CMD ["pipenv", "run", "gunicorn", "--bind", "0.0.0.0:5001", "flaskr:create_app()"]
