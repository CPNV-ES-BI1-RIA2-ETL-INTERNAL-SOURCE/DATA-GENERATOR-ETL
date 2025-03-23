# Data generation

* [Description](#description)
* [Getting Started](#getting-started)
  * [Prerequisites](#prerequisites)
  * [External Dependencies](#external-dependencies)
* [Deployment](#deployment)
  * [On dev environment](#on-dev-environment)
    * [Clone the repository](#clone-the-repository)
    * [Install the dependencies](#install-the-dependencies)
    * [Run the server](#run-the-server)
    * [Run the tests](#run-the-tests)
    * [Run the linter](#run-the-linter)
  * [On production environment](#on-production-environment)
    * [Deploy from source](#deploy-from-source)
    * [Docker](#docker)
* [Directory structure](#directory-structure)
* [Collaborate](#collaborate)
* [License](#license)
* [Contact](#contact)


# Description

The goals for this project is to:

- Centralize the data source for the BI project in a single API. Those data will be fetched from different external
  sources.
- Describe the purposes for which the data will be used.

More details can be found in the [project wiki](https://github.com/CPNV-ES-BI1-SBB/DATA-GENERATOR/wiki).

# Getting Started

## Prerequisites

* Ruby 3.0 or later [official doc](https://www.ruby-lang.org/fr/downloads/)
    * or use Rbenv 1.3.2 [official doc](https://github.com/rbenv/rbenv#readme)
* Git version 2.47.1 or later [official doc](https://git-scm.com/)
* Bundler 2.5.21 or later (already installed with ruby) [official doc](https://bundler.io/)

## External Dependencies

This service requires access to an external bucket service to function properly. This dependency is **mandatory** for the service to work correctly.

* Bucket Service: [CPNV-ES-BI1-RIA2-ETL-INTERNAL-SOURCE/BUCKET](https://github.com/CPNV-ES-BI1-RIA2-ETL-INTERNAL-SOURCE/BUCKET)

Please ensure you have access to this external service before deploying or running this application.

# Deployment

## On dev environment

```bash
# Clone the repository
git clone https://github.com/CPNV-ES-BI1-RIA2-ETL-INTERNAL-SOURCE/DATA-GENERATOR-ETL.git
cd DATA-GENERATOR-ETL
```

```bash
# Install the dependencies
bundle install
```

### Run the server

**index.rb** — Script pour démarrer le serveur Ruby

#### COMMAND

```bash
ruby bin/server [OPTIONS]
```

The **index.rb** script launches a Ruby server with various configuration options (port, development mode, test mode, etc.).

#### OPTIONS

**-p \<port>**
:   Sets the port on which the application listens.  
Default: `8000`  
Example: `ruby bin/server -p 8080` 

**-d**, **--dev**, **--development**
:   Starts the server in development mode.  
Default: **`production`**  
Example: `ruby bin/server --dev`

**-t**, **--test**
:   Starts the server in test mode.  
Example: `ruby bin/server -t`

#### NOTES
If no option is specified, the application will run with default settings (typically production mode and the default port).

You can also define the port using the `PORT` environment variable:

```bash
PORT=8080 ruby bin/server
```

or

```dotenv
# .env
PORT=8080
```


Test the API with the following command to retrieve the stationboard for Zurich on the 12th of December 2024 in PDF
format:

```shell
curl -X GET "http://localhost:8080/api/v1.1/stationboards/CH/zurich?date=01/13/2025" \
     -H "Accept: application/pdf" \
```

or in JSON format:

```shell
curl -X GET "http://localhost:8080/api/v1.1/stationboards/CH/zurich?date=01/13/2025" \
     -H "Accept: application/json"
```

### Run the tests

```bash
# Run all tests
rspec

# Run a specific test
rspec spec/services/stationboard_service_spec.rb
```

### Run the linter

This project uses [Rubocop](https://rubocop.org/) to enforce consistent code style. To run the linter:

```bash
# Run Rubocop on all files
bundle exec rubocop

# Run Rubocop with auto-correct
bundle exec rubocop -a

# Run Rubocop with safe auto-correct
bundle exec rubocop --safe-auto-correct
```

## On production environment

### Deploy from source

```bash
# Clone the repository
git clone https://github.com/CPNV-ES-BI1-RIA2-ETL-INTERNAL-SOURCE/DATA-GENERATOR-ETL.git
cd DATA-GENERATOR-ETL
```

```bash
# Install the dependencies
bundle install --without development test
```

#### Run the server

**index.rb** — Script pour démarrer le serveur Ruby

**COMMAND**

```bash
ruby bin/server [OPTIONS]
```

The **index.rb** script launches a Ruby server with various configuration options (port, development mode, test mode, etc.).

**OPTIONS**

**-p \<port>**
:   Sets the port on which the application listens.  
Default: `8000`  
Example: `ruby bin/server -p 8080`

**NOTES**

If no option is specified, the application will run with default settings (typically production mode and the default port).

You can also define the port using the `PORT` environment variable:

```bash
PORT=8080 ruby bin/server
```

or

```dotenv
# .env
PORT=8080
```

### Docker

#### Build the image

```bash
docker build -t data-generator .
```

#### Run the container

```bash
# You can override the default port (8000) by setting the PORT environment variable
docker run -e PORT=3000 -p 8000:3000 data-generator
# Or use the default port
docker run -p 8000:8000 data-generator
```

# Project Architecture

This project follows a modular Sinatra architecture with a clean separation of concerns:

## Directory Structure

```
.
├── app.rb                      # Main application file
├── config/                     # Configuration files
│   ├── config.yml              # Application configuration
├── bin/                        # Executable scripts
│   ├── console                 # Console script
│   └── server                  # Server script
├── src/                        # Source code
│   ├── controllers/            # Controllers for handling business logic
│   ├── middleware/             # Sinatra middleware
│   ├── models/                 # Domain models using dry-struct
│   ├── routes/                 # Route definitions
│   ├── services/               # Service layer
│   ├── formatters/             # Response formatters
│   ├── externalAPIs/           # External API clients
│   ├── helpers/                # Helper modules
│   ├── config.rb               # Configuration management
│   └── container.rb            # Dependency injection container
├── spec/                       # Tests
├── docs/                       # Documentation
├── .env.example                # Example environment variables
├── Gemfile                     # Ruby dependencies
└── Dockerfile                  # Docker configuration
```

## Key Components

1. **Controllers**: Handle the business logic for different endpoints
2. **Routes**: Define API endpoints and delegate to controllers
3. **Models**: Domain objects using dry-struct for type validation
4. **Services**: Encapsulate complex business operations
5. **Formatters**: Transform data into various formats (JSON, XML, PDF)
6. **ExternalAPIs**: Interface with third-party services
7. **Middleware**: Cross-cutting concerns like logging and error handling
8. **Container**: Dependency injection using dry-container and dry-auto_inject

## Request Flow

1. Request comes in through the Sinatra server
2. Middleware processes the request (logging, error handling)
3. Router matches the request to a route
4. Controller handles the business logic
5. Services perform operations and interact with external systems
6. Response is formatted and returned

This architecture provides a clean, maintainable, and testable codebase while following Ruby and Sinatra best practices.

# Collaborate

## Workflow

* [Gitflow](https://www.atlassian.com/fr/git/tutorials/comparing-workflows/gitflow-workflow#:~:text=Gitflow%20est%20l'un%20des,les%20hotfix%20vers%20la%20production.)
* [How to commit](https://www.conventionalcommits.org/en/v1.0.0/)
* [How to use your workflow](https://nvie.com/posts/a-successful-git-branching-model/)

* Propose a new feature in [Github issues](https://github.com/CPNV-ES-BI1-SBB/DATA-GENERATOR/issues)
* Pull requests are open to merge in the develop branch.
* Issues are added to the [github issues page](https://github.com/CPNV-ES-BI1-SBB/DATA-GENERATOR/issues)

## Commits

* [How to commit](https://www.conventionalcommits.org/en/v1.0.0/)

```bash
<type>(<scope>): <subject>
```

- **build**: Changes that affect the build system or external dependencies (e.g., npm, make, etc.).
- **ci**: Changes related to integration or configuration files and scripts (e.g., Travis, Ansible, BrowserStack, etc.).
- **feat**: Adding a new feature.
- **fix**: Bug fixes.
- **perf**: Performance improvements.
- **refactor**: Modifications that neither add a new feature nor improve performance.
- **docs**: Writing or updating documentation.
- **test**: Adding or modifying tests.
- **chore**: Changes to the build process or auxiliary tools and libraries such as documentation generation.

# License

The project is released under a [MIT license](./LICENSE).

# Contact

If needed you can create an issue on GitHub we will try to respond as quickly as possible.
