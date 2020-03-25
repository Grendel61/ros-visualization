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
  
### Using an existing ROS Service
Now that you have completed the steps above, you can launch an existing Ros service or topic. A good example is the [Turtlebot simulation](http://wiki.ros.org/turtlesim). This will require you to open multiple terminal windows. But you will be learning how ROS works. 

The Turtlebot Simulator is already installed, so you can jump in quickly by running it. 
1. Start the ros-visualization container with a `docker run` (see above)
2. This will give you a cursor so attach a shell to the container to open a terminal window to run Turtlebot (see above)
3. Now start `roscore`, on the command line of the new shell type:
``` 
roscore
```
This will start the Roscore server, and you'll be ready to run a ROS Service. You should see something like this:
```
ros@e52e7c314fb4:~$ roscore
... logging to /home/ros/.ros/log/f72a3a66-6ece-11ea-bea0-0242ac110002/roslaunch-e52e7c314fb4-292.log
Checking log directory for disk usage. This may take a while.
Press Ctrl-C to interrupt
Done checking log file disk usage. Usage is <1GB.

started roslaunch server http://e52e7c314fb4:35167/
ros_comm version 1.14.4


SUMMARY
========

PARAMETERS
 * /rosdistro: melodic
 * /rosversion: 1.14.4

NODES

auto-starting new master
process[master]: started with pid [302]
ROS_MASTER_URI=http://e52e7c314fb4:11311/

setting /run_id to f72a3a66-6ece-11ea-bea0-0242ac110002
process[rosout-1]: started with pid [313]
started core service [/rosout]
```
4. Attach a new shell to the container to open a terminal window to run Turtlebot (see above)
5. In the new terminal window enter:
```
rosrun turtlesim turtlesim_node
```
You should see:
```
ros@e52e7c314fb4:~$ rosrun turtlesim turtlesim_node
QStandardPaths: XDG_RUNTIME_DIR not set, defaulting to '/tmp/runtime-ros'
[ INFO] [1585164731.259722600]: Starting turtlesim with node name /turtlesim
```
6. At this point, if you opened a browser window to your container at http://localhost:6901/ you should see a turtlebot like this:

  ![](/pics/turtlebot.png)

7. Now let's learn about the services that are running - attach a new shell to the container to open a terminal window to interact with ROS services (see above)
8. In the new window let's look into the running TurtleSim ROS services. Let's start with what nodes are running, enter on the command line:
``` 
rosnode list
```
This should show: 
```
ros@e52e7c314fb4:~$ rosnode list
/rosout
/turtlesim
```
Now let's specifically look at ROS Services running, enter on the command line:
```
  rosservice list
```
You should see something like this.
```
  ros@e52e7c314fb4:~$ rosservice list
  /clear
  /kill
  /reset
  /rosout/get_loggers
  /rosout/set_logger_level
  /spawn
  /turtle1/set_pen
  /turtle1/teleport_absolute
  /turtle1/teleport_relative
  /turtlesim/get_loggers
  /turtlesim/set_logger_level
```
Now let's look into the `/spawn` service from that list. Spawn creates a new TurtleSim node, on the command line add:
```
  rosservice info /spawn
```
This should return information about the `/spawn` service. Think of it as a route. 
```
  ros@e52e7c314fb4:~$ rosservice info /spawn
  Node: /turtlesim
  URI: rosrpc://e52e7c314fb4:50939
  Type: turtlesim/Spawn
  Args: x y theta name
```
The `rosservice` has the following commands:
```
  Commands:
          rosservice args print service arguments
          rosservice call call the service with the provided args
          rosservice find find services by service type
          rosservice info print information about service
          rosservice list list active services
          rosservice type print service type
          rosservice uri  print service ROSRPC uri
```
Now lets expose information about the API, enter on the command line:
```
  rossrv info turtlesim/Spawn
```
This exposes the types:
```
  ros@e52e7c314fb4:~$ rossrv info turtlesim/Spawn
  float32 x
  float32 y
  float32 theta
  string name
  ---
  string name
```
So let's create a new Turtle a little above and to the right of our current turtle which is at 0 0 0. On the command line enter:
```
  rosservice call /spawn 7 7 0 eddie
```
This is a terminal at location `7 7` with an orientation of `0` degrees from the base. In the terminal you should see:
```
  name: "eddie"
```
In your window running the simulation (e.g. the 2nd window) you should see an INFO message:
```
[ INFO] [1585164731.268737700]: Spawning turtle [turtle1] at x=[5.544445], y=[5.544445], theta=[0.000000]
[ INFO] [1585165017.538127200]: Spawning turtle [eddie] at x=[7.000000], y=[7.000000], theta=[0.000000]
```
The top message was from when you started TurtleSim, the second message is for our "eddie" turtle created above. In your browser window for the desktop you should see a new turtle added to the screen. 

  ![](/pics/2turtles.png)

Now let's remove that turtle, on the command line in your rosservice window enter:
```
rosservice call /kill eddie
```
The `/kill` command is listed in your command list on the TurtleSim. If you look at your browser window with the turtles, the "eddie" turtle should be gone. 

Chack out these tutorials to learn more about ROS Services:
[Intro Video](https://www.youtube.com/watch?time_continue=480&v=qhnlmrGQVvM&feature=emb_logo)
[TurtleSim Pages (see bottom)](http://wiki.ros.org/turtlesim)


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
