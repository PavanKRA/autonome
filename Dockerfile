# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Set environment variables
ENV PATH /opt/conda/bin:$PATH

# Install dependencies
RUN apt-get update --fix-missing && \
    apt-get install -y wget bzip2 ca-certificates curl git && \
    apt-get clean

# Install Miniconda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh 
RUN  /bin/bash Miniconda3-latest-Linux-x86_64.sh -b -p /opt/conda
RUN    rm Miniconda3-latest-Linux-x86_64.sh
#RUN    /opt/conda/bin/conda clean -tipsy

# Set the working directory
WORKDIR /usr/src/app

# Copy the environment file and install dependencies
COPY environment.yml ./
RUN conda env create -f environment.yml

# Activate the environment
SHELL ["conda", "run", "-n", "myenv", "/bin/bash", "-c"]

# Copy the rest of the application code
COPY . .

# Define the command to run the application
CMD ["conda", "run", "-n", "myenv", "python", "main.py"]