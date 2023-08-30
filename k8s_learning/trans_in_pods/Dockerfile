# Use an official Python runtime as a parent image
FROM python:3.5.7
# Set the working directory to /app
WORKDIR /app
# Install any needed packages specified in requirement.txt
RUN pip install flask flask_redis && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo 'Asia/Shanghai' >/etc/timezone
# Make port 6000 available to the world outside this container
EXPOSE 6000
# Define environment variable
ENV envname=k8s
# ADD application.py to /app
ADD application.py /app/
CMD ["python", "application.py"]