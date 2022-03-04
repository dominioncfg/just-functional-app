# Just Functional

This is an app to showcase [Just Functional](https://dominioncfg.github.io/just-functional-read-the-docs/pages/getting-started.html).

## Requirements

- Flutter Sdk 2.8
- Docker/Docker Desktop

## Getting Started

The app is built with flutter and is currently in development.

### Run the Backend

This app uses a version of [Just Functional Web](https://github.com/dominioncfg/just-functional-web) as a backend. For trying out the app in development you are going to need a running version of its backend.

1. Open a terminal in the src folder.
2. Start the backend using docker

```bash
docker-compose -f ./backend/local/docker-compose.yml -p just-functional-app-local up --build --detach
```
