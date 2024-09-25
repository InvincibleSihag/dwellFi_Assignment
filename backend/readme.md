# DwellFi Assignment

## Overview

This project is a file processing system built using FastAPI, Celery, SQLAlchemy, and Redis. The system allows users to upload JSON files, processes them asynchronously, and notifies users about the processing status via WebSockets.

## Table of Contents

1. [Architecture](#architecture)
2. [Components](#components)
   - [Backend](#backend)
   - [Database](#database)
   - [Task Queue](#task-queue)
   - [Notification System](#notification-system)
3. [Setup](#setup)
4. [Usage](#usage)
5. [Diagrams](#diagrams)

## Architecture

The architecture of this project is divided into several components:

1. **Backend**: FastAPI is used to handle HTTP requests and WebSocket connections.
2. **Database**: PostgreSQL is used as the primary database, managed via SQLAlchemy ORM.
3. **Task Queue**: Celery is used for asynchronous task processing, with Redis as the message broker.
4. **Notification System**: Redis Pub/Sub is used to notify users about the status of file processing.

## Components

### Backend

The backend is built using FastAPI and includes several routes for file operations and notifications.

#### Main Application

The main application is defined in `src/main.py`:


#### Routes

File-related routes are defined in `src/files_app/routes.py`:


### Notification System

The notification system uses Redis Pub/Sub and websockets to notify users about the status of file processing.

#### Redis Pub/Sub Manager

The Redis Pub/Sub manager is defined in `src/notification/redis_pub_sub_connection.py`:


#### Event Subscription

The event subscription handler is defined in `src/notification/subscription_handler.py`:


## Setup

To set up the project, follow these steps:

1. Clone the repository:
   ```sh
   git clone <repository-url>
   cd <repository-directory>
   ```

2. Create a virtual environment and activate it:
   ```sh
   python -m venv venv
   source venv/bin/activate  # On Windows use `venv\Scripts\activate`
   ```

3. Install the dependencies:
   ```sh
   pip install -r requirements.txt
   ```

4. Set up the database:
   ```sh
   alembic upgrade head
   ```

5. Start the FastAPI server:
   ```sh
   uvicorn src.main:app --reload
   ```

6. Start the Celery worker:
   ```sh
   celery -A src.tasks.celery_app worker --loglevel=info
   ```

## Usage

1. **Upload a File**: Use the `/files/uploadfile/` endpoint to upload a JSON file.
2. **Check File Status**: Use the `/files/{file_id}` endpoint to check the status of a file.
3. **WebSocket Notifications**: Connect to the `/notification/events` WebSocket endpoint to receive real-time notifications.

## Flow

1. User uploads a JSON file via FastAPI.
2. FastAPI saves the file metadata to PostgreSQL.
3. FastAPI sends a task to Celery to process the file.
4. Celery processes the file and updates the status in PostgreSQL.
Celery publishes a notification to Redis Pub/Sub.
6. FastAPI WebSocket endpoint receives the notification and sends it to the user.
