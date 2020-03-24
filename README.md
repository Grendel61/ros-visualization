# Containerized ROS Visualization and Development environment 

This repository builds an Ubuntu environment for developing and visualizing Robot Operating System (ROS) worlds. 
## DockerHub
https://hub.docker.com/repository/docker/grendel61/ros-visualization/general

![Docker Image Size (tag)](https://img.shields.io/docker/image-size/grendel61/ros-visualization/latest) 
![MicroBadger Layers](https://img.shields.io/microbadger/layers/grendel61/ros-visualization)

## Grendel61/ros-visualization:latest
* Ubuntu 18.04 with Desktop
* VNC/No-VNC on Ports: 5901/6901
* XFCE Window Manager
* ROS Melodic-Desktop-Full:
  * ROS Melodic: tutorials cmake, ros-built-toools, ros-melodic catkin, etc. 
  * RQT
  * RVIZ
  * Robot Generic Libraries
  * 2D/3D simulaters and perception
  * Python 3 64-bit
* ROS Gazebo 9 - Robot Model Development and Simulation
* ROS MoveIt - Robot Motion Planning and Simulation
* Tensorflow GPU

# Using Ros-Visualization
Ros-Visualization was designed to provide a method for avoiding the install process for Gazebo and MoveIt, and allow you to run these applications directly from the container. There is no need to separately install Ros-Visualization just run it from the command line. You will have two categories of options to decide how you want to run the container:
* How you want to view the results of the Ros-Visualization container - For visualization and viewing of the desktop you can chose to use a VNC client or a browser client. This comes down to setting a port number. You can also set resolution and other information. 
* Where you want to keep ROS source code and configurations specific to your run. For source code you can setup a detached volume. This enables you to put your simulation code into a Git directory that you can edit in your favorite IDE. The ability to attach a local volume (see above) also makes this solution viable for a development platform. 

## Running Ros-Visualization
1) Create a GitHub repository on your GitHub account to hold your source code, lets call this `Ros-source`.  
2) Clone to your local machine. 
3) In a terminal window (e.g. see example below on VSCode) run Ros-Visualization with a detached volume (e.g. -v). Replace `[Path to Ros-source directory]` with the actual local path to your Ros-source repository. 
  ```
  docker run -it --rm -p 5901:5901 -p 6901:6901 \
  -e VNC_PW=vncpassword \
  -v /[Ros-Source directory]:/home/ros/Desktop/src \
  grendel61/ros-visualization:latest 
  ```
 The end of the run should look like this:
 
  ![](/pics/ros-visualization-run.jpg)
  
 The container will remain running, so you'll need to attach a new shell to the container to continue the startup process. 
4) Open up the desktop viewer in your browser. Open a browser window. 
In the URL field enter: 
```
http://localhost:6901/
```
In the password field in the center top of the screen, enter: 
```
vncpassword
```
  ![](/pics/vncpassword.png)
  
5) Use the desktop. Entering the correct password will bring up the Ubuntu Desktop. Explore it. 

  ![](/pics/ubuntu-desktop.png)
  
6) Ros-source directory (e.g. `src`). The source directory folder on the bottom left of the screen is where your configuration data and code will be stored. At startup unless you've used your Ros-source directory before it will be empty. Here is a Ros-source directory after using Moveit. In this way you can build your Catkin directories for ROS as above so that they will survive exiting the container, and can be under source control. 

  ![](/pics/src-directory.png)
  
4) Now attach a shell to the running container. Attaching a shell is how you will launch Ros nodes you have already built, or use simulation libraries like Gazebo and MoveIt. 

Start VSCode, if you don't have the VSCode Docker extension, add it. Now in the Containers section (top left), `right click` on the Ros-visualization container you started in the previous steps, and now select Attach Shell. This will place you into a shell inside the container, and from here you can enter ROS oriented commands.

  ![](/pics/attach-shell.png)
  
### Using an existing ROS Node
Now that you have completed the steps above, you can launch an existing Ros Node, visualization application, or start a tutorial. To run a ROS node use roslaunch as below replacing `package_name file.launch` with an actual Ros Node in your source diretory. 
```
roslaunch package_name file.launch
```
### Using Gazebo
Gazebo is a 3D dynamic simulator with the ability to accurately and efficiently simulate populations of robots in complex indoor and outdoor environments. While similar to game engines, Gazebo offers physics simulation at a much higher degree of fidelity, a suite of sensors, and interfaces for both users and programs.
- Start the ros-visualization container with a `docker run` (see above)
- Attach a shell to the container to open a terminal window to run Gazebo (see above)
- Enter on the command line:
```
gazebo
```
- Follow the [Gazebo tutorials](http://gazebosim.org/tutorials?cat=get_started) 
### Using MoveIt
MoveIt is an easy-to-use robotics manipulation platform for developing applications, evaluating designs, and building integrated products
- Start the ros-visualization container with a `docker run` (see above)
- Attach a shell to the container to open a terminal window to run Gazebo (see above)
- Enter on the command line
```
roslaunch panda_moveit_config demo.launch rviz_tutorial:=true
```
- Follow the [MoveIt tutorials](https://ros-planning.github.io/moveit_tutorials/)

# Detailed Instructions
## Startup & Install ROS-Visualization
- Run command with mapping to local port `5901` (vnc protocol) and `6901` (vnc web access):

      docker run -d -p 5901:5901 -p 6901:6901 grendel61/ros-visualization:latest 

- If you want to get into the container use interactive mode `-it` and `bash`
      
      docker run -it -p 5901:5901 -p 6901:6901 grendel61/ros-visualization:latest bash

- If you want to connect to tensorboard, run command with mapping to local port `6006`:
      
      docker run -it -p 5901:5901 -p 6901:6901 -p 6006:6006 grendel61/ros-visualization:latest 

## Advanced Docker Run settings

### Using root (user id `0`)
Add the `--user` flag to your docker run command:
```
    docker run -it --user root -p 5901:5901 grendel61/ros-visualization:latest 
```
### Using user and group id of host system
Add the `--user` flag to your docker run command (Note: uid and gui of host system may not able to map with container, which is 1000:1000. If that is the case, check with 3):
```
    docker run -it -p 5901:5901 --user $(id -u):$(id -g) grendel61/ros-visualization:latest 
```
### Override VNC and Container environment variables
The following VNC environment variables can be overwritten at the `docker run` phase to customize your desktop environment inside the container:
* `VNC_COL_DEPTH`, default: `24`
* `VNC_RESOLUTION`, default: `1920x1080`
* `VNC_PW`, default: `vncpassword`
* `USER`, default: `ros`
* `PASSWD`, default: `ros`

### Override the VNC password
Simply overwrite the value of the environment variable `VNC_PW`. For example in
the docker run command:
```
    docker run -it -p 5901:5901 -p 6901:6901 -e VNC_PW=vncpassword grendel61/ros-visualization:latest 
```
### Override the VNC resolution
Simply overwrite the value of the environment variable `VNC_RESOLUTION`. For example in
the docker run command:
```
    docker run -it -p 5901:5901 -p 6901:6901 -e VNC_RESOLUTION=800x600 grendel61/ros-visualization:latest 
```
### Mount a local directory to the container
You can settings to the run to connect a local directory which will receive new files created with the container. This will let you edit generated files with your IDE. Map your group/user to the container retrieve R/W permission to the mounted directory of mounting directory in container (Note: after running this command, the user account in container will be same as host account):
```
 docker run -it -p 5901:5901 \
   --user $(id -u):$(id -g) \
   --volume /etc/passwd:/etc/passwd \
   --volume /etc/group:/etc/group \
   --volume /etc/shadow:/etc/shadow \
   --volume /home/ros/Desktop:/home/ros/Desktop:rw \
   grendel61/ros-visualization:latest
```

### Connecting jupyter notebook within container
- Run command with mapping to local port `8888` (jupyter protocol) and `8888` (host web access):
```
      docker run -d -p 8888:8888 grendel61/ros-visualization:latest 
```
- Check your local IP within container using `` $ifconfig``, then you can start up jupyter notebook in container with following command: 
```
      jupyter notebook --ip={YOUR CONTAINER IP} --port=8888 --allow-root
```
- After start up the jupyter kernel, you can access the notebook from host browser through HTTP service.
```
      http://localhost:8888/
```
## Display Connections & Controls
You can connect to the Ubuntu desktop and run applications like RVIZ, Gazebo, etc. in multiple ways:
* Connect via __VNC viewer `localhost:5901`__, default password: `vncpassword`
* Connect via __noVNC HTML5 full client__: [`http://localhost:6901/vnc.html`](http://localhost:6901/vnc.html), default password: `vncpassword` 
* Connect via __noVNC HTML5 lite client__: [`http://localhost:6901/?password=vncpassword`](http://localhost:6901/?password=vncpassword) 
* Connect to __Tensorboard__ if you do the tensorboard mapping above: [`http://localhost:6006`](http://localhost:6006)
* The default username and password in container is ros:ros

## Contributors
* [ConSol/docker-headless-vnc-container](https://github.com/ConSol/docker-headless-vnc-container) - developed the ConSol/docker-headless-vnc-container
* [Docker-Ros-VNC](https://github.com/henry2423/docker-ros-vnc) - provided the very complex VNC integration to Ubuntu, and the basic approach for ROS
