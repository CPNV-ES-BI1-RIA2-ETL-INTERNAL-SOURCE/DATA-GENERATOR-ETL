# Data generation

* [Description](#description)
* [Getting Started](#getting-started)
  * [Prerequisites](#prerequisites)
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
ruby ./src/index.rb [OPTIONS]
```

The **index.rb** script launches a Ruby server with various configuration options (port, development mode, test mode, etc.).

#### OPTIONS

**-p \<port>**
:   Sets the port on which the application listens.  
Default: `8000`  
Example: `ruby ./src/index.rb -p 8080` 

**-d**, **--dev**, **--development**
:   Starts the server in development mode.  
Default: **`production`**  
Example: `ruby ./src/index.rb --dev`

**-t**, **--test**
:   Starts the server in test mode.  
Example: `ruby ./src/index.rb -t`

#### NOTES
If no option is specified, the application will run with default settings (typically production mode and the default port).

You can also define the port using the `PORT` environment variable:

```bash
export PORT=8080
ruby ./src/index.rb
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
ruby ./src/index.rb [OPTIONS]
```

The **index.rb** script launches a Ruby server with various configuration options (port, development mode, test mode, etc.).

**OPTIONS**

**-p \<port>**
:   Sets the port on which the application listens.  
Default: `8000`  
Example: `ruby ./src/index.rb -p 8080`

**NOTES**

If no option is specified, the application will run with default settings (typically production mode and the default port).

You can also define the port using the `PORT` environment variable:

```bash
export PORT=8080
ruby ./src/index.rb
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

# Directory structure

```shell
├── config.yaml
├── Gemfile                       # Dependencies
├── Gemfile.lock                  
├── Dockerfile                    # Docker image configuration                  
├── README.md                     
├── assets                        # Images or other assets
│   └── images
├── docs                          # Documentation
├── logs                          # Log's file directory (not versioned)
├── spec                          # Tests
└── src                           # Source code 
    ├── config.rb
    ├── externalAPIs              # External APIs
    ├── formatters                # Formatters
    ├── helpers
    ├── index.rb                  # Entrypoint    
    ├── server.rb
    └── services                  # Services
```

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
