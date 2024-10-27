# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV POETRY_VERSION=1.5.1

# Set the working directory in the container
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install Poetry
RUN pip install "poetry==$POETRY_VERSION"

# Create empty pyproject.toml and poetry.lock files if they don't exist
RUN touch pyproject.toml poetry.lock

# Copy the current directory contents into the container at /app
COPY . /app/

# Initialize Poetry project if pyproject.toml is empty
RUN if [ ! -s pyproject.toml ]; then poetry init --no-interaction; fi

# Install dependencies
RUN poetry install --no-interaction --no-ansi

# Make port 8888 available to the world outside this container
EXPOSE 8888

# Run Jupyter when the container launches
CMD ["poetry", "run", "jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]
