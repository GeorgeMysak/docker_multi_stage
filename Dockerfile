# Stage 1: Build stage
FROM python:3.7-slim AS build

# Set the working directory
WORKDIR /app

# Install dependencies
RUN pip install networkx dash plotly

# Copy the application files
COPY . .

# Stage 2: Runtime stage
FROM python:3.7-slim

# Set the working directory
WORKDIR /app

# Copy only the necessary files from the build stage
COPY --from=build /app /app

# Create a non-root user
RUN groupadd -r webservice && useradd --no-log-init -r -g webservice webservice

# Change ownership of the app directory
RUN chown -R webservice:webservice /app

# Switch to the non-root user
USER webservice:webservice

# Expose the port
EXPOSE 8050

# Set the entry point
ENTRYPOINT ["python", "GraphAnalysis.py"]
CMD ["obj_dependency_data.csv"]