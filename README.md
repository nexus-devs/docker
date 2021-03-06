# NexusHub Docker Images
This is a collection of Docker images for NexusHub server components.
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
Check out [Docker for Mac](https://docs.docker.com/docker-for-mac/install/).


<br>


## Deploying the NexusHub stack
With Docker installed, we can now build the required docker images and
deploy them to [Docker Swarm](https://docs.docker.com/engine/swarm/key-concepts/).

**IMPORTANT**: You probably won't need this unless you're debugging stuff, so make
sure to follow the [Quickstart Tutorial](https://github.com/nexus-devs/nexus-stats#quickstart)
from the NexusHub repo instead.

<br>

### Deploy for development
>`bash deploy.sh --dev /c/path/to/nexus-stats/repo`

This will bind the repo's location to the docker container, which means that we
can edit our code as usual without accessing the container's filesystem directly.
<br>

Each part of the application will listen on separate ports on `localhost`:
- View Server: 3000
- API Server: 3003
- Auth Server: 3030

Furthermore this will run cubic in development mode, which means:
- All nodes will be managed by a single controller in a single container
- API endpoints will not be loaded into cache, so we don't have to restart for
changes
- Hot-module replacement will be active for working on the web client
- Webpack will build for development, meaning no minification, ES6+
transpilation, etc

Other than that, all is designed to be parallel to production to avoid sudden
surprises before going live :^)

<br>

### Deploy for production
>`bash deploy.sh`

Sets up the swarm, builds images and deploys them to the swarm.
The application will listen on :80/:443 to \*.nexus-stats.com requests. <br>

Requires the manual addition of the following secrets:
- Docker Secret: nexus-dockerhub-token, nexus-cloudflare-token

<br>

### All deploy options
| Flag        | Shortcut       | Description   |
|:------------- |:------------- |:------------- |
| `--dev`   | `-d` | Deploy with dev image. Requires path to the host's nexus-stats repo as an argument. |
| `--local` | `-l` | Use local registry instead of hub.docker.com |
| `--build` | `-b` | Build and publish files to specified registry before deploying. |
| `--staging` | `-s` | Generate production image from staging branch. Just for the staging server. |

<br>

### Building images manually
Every image can also be easily built manually without the deploy script. Just
`cd` into the folder of your target image and run `make image registry=<registry>`
where `registry` is either `127.0.0.1:5000` for the local registry or `nexusstats`
for the dockerhub repo (requires permissions).
