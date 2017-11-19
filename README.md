# Nexus-Stats Docker Images
This is a collection of docker images for Nexus-Stats server components.
There is a readme included in each folder to guide you through the setup process.

<br>

## Installing Docker
We made a couple of scripts to simplify the docker installation as much as possible.
Notably, this also includes support to run Ubuntu Docker images on Windows.

### Ubuntu
To install Docker on Ubuntu, just run `sudo bash install.sh`.

### Windows
For Windows, make sure you're running the latest version of Windows 10. We'll use Bash on Windows to run docker images for Ubuntu in a Windows environment.
1. Get [Docker for Windows](https://www.docker.com/docker-windows)
2. Tick the "Expose daemon on tcp://localhost:2375" option in settings. This allows us to use the Windows Docker core on an Ubuntu Docker client.
3. Enable [Bash on Windows](https://msdn.microsoft.com/en-us/commandline/wsl/install-win10)
4. `bash` in your command line, then locate this repo and run `sudo bash install-windows.sh`

<br>

## Post-Installation
To verify your installation on either system, just run `docker run hello-world`. You can remove that image again with `docker rmi hello-world`.
<br>
If everything worked up to this point, you're ready to spin up the containers in this repo!
