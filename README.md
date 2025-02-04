# Data generation

* [Description](#description)
* [Getting Started](#getting-started)
    * [Prerequisites](#prerequisites)
* [Deployment](#deployment)
    * [On dev environment](#on-dev-environment)
* [Directory structure](#directory-structure)
* [Collaborate](#collaborate)
* [License](#license)
* [Contact](#contact)

## Description

The goals for this project is to:

- Centralize the data source for the BI project in a single API. Those data will be fetched from different external
  sources.
- Describe the purposes for which the data will be used.

More details can be found in the [project wiki](https://github.com/CPNV-ES-BI1-SBB/DATA-GENERATOR/wiki).

## Getting Started

### Prerequisites

* Ruby 3.0 or later [official doc](https://www.ruby-lang.org/fr/downloads/)
    * or use Rbenv 1.3.2 [official doc](https://github.com/rbenv/rbenv#readme)
* Git version 2.47.1 or later [official doc](https://git-scm.com/)
* Bundler 2.5.21 or later (already installed with ruby) [official doc](https://bundler.io/)

## Deployment

### On dev environment

#### Clone the repository

```bash
git clone https://github.com/CPNV-ES-BI1-RIA2-ETL-INTERNAL-SOURCE/DATA-GENERATOR-ETL.git
cd DATA-GENERATOR-ETL
```

#### Install the dependencies

```bash
bundle install
```

#### Run the server

```bash
ruby .\src\index.rb -p 8080
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

#### Run the tests

```bash
rspec
```

### Docker

#### Build the image

```bash
docker build -t data-generator .
```

#### Run the container

```bash
export AWS_ACCESS_KEY_ID=<AWS_KEY>
export AWS_SECRET_ACCESS_KEY=<AWS_SECRET>
docker run -e AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY -p 8088:8088 data-generator
```

## Directory structure

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

## Collaborate

### Workflow

* [Gitflow](https://www.atlassian.com/fr/git/tutorials/comparing-workflows/gitflow-workflow#:~:text=Gitflow%20est%20l'un%20des,les%20hotfix%20vers%20la%20production.)
* [How to commit](https://www.conventionalcommits.org/en/v1.0.0/)
* [How to use your workflow](https://nvie.com/posts/a-successful-git-branching-model/)

* Propose a new feature in [Github issues](https://github.com/CPNV-ES-BI1-SBB/DATA-GENERATOR/issues)
* Pull requests are open to merge in the develop branch.
* Issues are added to the [github issues page](https://github.com/CPNV-ES-BI1-SBB/DATA-GENERATOR/issues)

### Commits

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

## License

The project is released under a [MIT license](./LICENSE).

Copyright (c) 2024 CPNV - [cpnv.ch](https://cpnv.ch).

## Contact

If needed you can create an issue on GitHub we will try to respond as quickly as possible.
