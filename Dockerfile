# Use the `python:3.8` as a source image from the Amazon ECR Public Gallery
FROM public.ecr.aws/sam/build-python3.8:latest

# Set up an app directory for your code
COPY . /app
WORKDIR /app

# Install `pip` and needed Python packages from `requirements.txt`
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

# Define an entrypoint which will run the main app using the Gunicorn WSGI server.
ENTRYPOINT ["gunicorn", "-b", ":8080", "main:APP"]
