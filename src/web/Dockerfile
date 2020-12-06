# The first instruction is what image we want to base our container on
# We Use an official Python runtime as a parent image
FROM python:alpine3.7

# The enviroment variable ensures that the python output is set straight
# to the terminal with out buffering it first
ENV PYTHONUNBUFFERED 1

# Required to successfully install psycopg2
RUN apk update && apk add postgresql-dev gcc python3-dev musl-dev

# create root directory for our project in the container
RUN mkdir /app

# Set the working directory to /music_service
WORKDIR /app

# Copy the current directory contents into the container at /music_service
COPY app /app/

# Install any needed packages specified in requirements.txt
RUN pip install -r requirements.txt
EXPOSE 5000
ENTRYPOINT ["python"]
CMD ["main.py"]
