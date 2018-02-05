# Nexus-Stats Docker Images
This is a collection of Docker images for Nexus-Stats server components.
There is a readme included in each folder to explain the image setup and
configuration.


<br>


## Installing Docker
We made a couple of scripts to simplify the Docker installation as much as
possible. Notably, this also includes support to run Linux Docker images on
Windows.

### Linux
To install Docker on Linux, just run `sudo bash install.sh`.

### Windows
For Windows, make sure you're running the latest version of Windows 10. We'll
use Bash on Windows to run Docker images for Linux in a Windows environment.
1. Get [Docker for Windows](https://www.docker.com/docker-windows)
2. Tick the "Expose daemon on tcp://localhost:2375" option in settings.
This allows us to use the Windows Docker core on a Linux Docker client.
3. Enable [Bash on Windows](https://msdn.microsoft.com/en-us/commandline/wsl/install-win10)
4. `bash` in your command line, then locate this repo and run
`sudo bash install-windows.sh`

### Mac
Get [Boot 2 Docker](http://boot2docker.io/) and install.


<br>


## Deploying the Nexus-Stats stack
With Docker installed, we can now build the required docker images and
deploy them to [docker swarm](https://docs.docker.com/engine/swarm/key-concepts/)

<br>

### Deploy for development
>`bash deploy.sh --dev /c/path/to/nexus-stats/repo`

This will bind the repo's location to the docker container, which means that we
can edit our code as usual without accessing the container's filesystem. <br>

Each part of the application will listen on separate ports on `localhost`:
- View Server: 3030
- Auth Server: 3020
- API Server (Warframe): 3010

Furthermore this will run blitz.js in development mode, which means:
- All nodes will be managed by a single controller in a single container
- API endpoints will not be loaded into cache, so we don't have to restart for
changes
- Hot-module replacement will be active for working on the web client
- Webpack will build for development, meaning no minification, ES6+
transpilation, etc

Other than that, all is desgined to be parallel to production to avoid sudden
surprises before going live :^)

**Note:** This is all done automatically by running the `docker.sh` script in
the [Nexus-Stats repo](https://github.com/nexus-devs/nexus-stats)

<br>

### Deploy for production
>`bash deploy.sh`

Sets up the swarm, builds images and deploys them to the swarm.
The application will listen on :80/:443 to \*.nexus-stats.com requests. <br>

Requires the manual addition of the following secrets:
- Docker Secret: nexus-cert-public, nexus-cert-private, nexus-ci-github-user, nexus-ci-github-pass
- Env: DRONE_SECRET, DRONE_GITHUB_CLIENT, DRONE_GITHUB_SECRET