# This Dockerfile is used to build an ROS + VNC + Tensorflow image based on Ubuntu 18.04
FROM ubuntu

LABEL maintainer "Ed Fullman"
LABEL Ed Fullman "https://github.com/Grendel61"
ENV REFRESHED_AT 2020-03-04

# Install sudo
RUN apt-get update && \
    apt-get install -y sudo \
    xterm \
    curl

# Configure user
ARG user=ros
ARG passwd=ros
ARG uid=1000
ARG gid=1000
ENV USER=$user
ENV PASSWD=$passwd
ENV UID=$uid
ENV GID=$gid
RUN groupadd $USER && \
    useradd --create-home --no-log-init -g $USER $USER && \
    usermod -aG sudo $USER && \
    echo "$PASSWD:$PASSWD" | chpasswd && \
    chsh -s /bin/bash $USER && \
    # Replace 1000 with your user/group id
    usermod  --uid $UID $USER && \
    groupmod --gid $GID $USER


### VNC Installation
LABEL io.k8s.description="Ubuntu VNC with Xfce running ROS Melodic Desktop, Gazebo, MoveIt, and Tensorflow" \
      io.k8s.display-name="ROS Visualization and Development Environment" \
      io.openshift.expose-services="6901:http,5901:xvnc,6006:tnesorboard" \
      io.openshift.tags="vnc, xfce, ubuntu, ros, ros desktop, gazebo, tensorflow" \
      io.openshift.non-scalable=true

## Connection ports for controlling the UI:
# VNC port:5901
# noVNC webport, connect via http://IP:6901/?password=vncpassword
ENV DISPLAY=:1 \
    VNC_PORT=5901 \
    NO_VNC_PORT=6901
EXPOSE $VNC_PORT $NO_VNC_PORT

## Envrionment config
ENV VNCPASSWD=vncpassword
ENV HOME=/home/$USER \
    TERM=xterm \
    STARTUPDIR=/dockerstartup \
    INST_SCRIPTS=/home/$USER/install \
    NO_VNC_HOME=/home/$USER/noVNC \
    DEBIAN_FRONTEND=noninteractive \
    VNC_COL_DEPTH=24 \
    VNC_RESOLUTION=1920x1080 \
    VNC_PW=$VNCPASSWD \
    VNC_VIEW_ONLY=false
WORKDIR $HOME

RUN apt-get clean

## Add all install scripts for further steps
ADD ./src/common/install/ $INST_SCRIPTS/
ADD ./src/ubuntu/install/ $INST_SCRIPTS/
RUN find $INST_SCRIPTS -name '*.sh' -exec chmod a+x {} +

## Install some common tools
RUN $INST_SCRIPTS/tools.sh
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

## Install xvnc-server & noVNC - HTML5 based VNC viewer
RUN $INST_SCRIPTS/tigervnc.sh
RUN $INST_SCRIPTS/no_vnc.sh

## Install firefox and chrome browser
RUN $INST_SCRIPTS/firefox.sh
RUN $INST_SCRIPTS/chrome.sh

## Install xfce UI
RUN $INST_SCRIPTS/xfce_ui.sh
ADD ./src/common/xfce/ $HOME/

## configure startup
RUN $INST_SCRIPTS/libnss_wrapper.sh
ADD ./src/common/scripts $STARTUPDIR
RUN $INST_SCRIPTS/set_user_permission.sh $STARTUPDIR $HOME


### ROS and Gazebo Installation
# Install other utilities
RUN apt-get update && \
    apt-get install -y vim apt-utils \
    tmux \
    git

# Install ROS
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list' && \
    apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654 && \
    apt-get update && \
    apt-get install -y ros-melodic-desktop-full

RUN rosdep init

USER $USER
RUN rosdep update

USER root
## Install Dependencies
RUN apt-get install -y python-rosinstall python-rosinstall-generator python-wstool build-essential

# Install Gazebo
RUN sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list' && \
    wget http://packages.osrfoundation.org/gazebo.key -O - | sudo apt-key add - && \
    apt-get update && \
    apt-get install -y gazebo9 libgazebo9-dev &&\
    apt-get install -y ros-melodic-gazebo-ros-pkgs ros-melodic-gazebo-ros-control


# Setup ROS
USER $USER
RUN rosdep fix-permissions && rosdep update
RUN echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc
RUN /bin/bash -c "source ~/.bashrc"

# Install Tensorflow 
USER root
RUN apt-get install -y python3-dev python3-pip  && \
    pip3 install --user --upgrade tensorflow

# Install Moveit
## Update ROS
USER $USER
RUN rosdep update
##  back to root
USER root
RUN apt-get update && \
    apt-get -y dist-upgrade && \
    apt-get install -y ros-melodic-catkin python-wstool python-catkin-tools clang-format-3.9

## Create Workspace
RUN mkdir -p ~/ws_moveit && \
    cd ~/ws_moveit && \
    wstool init src && \
    wstool merge -t src https://raw.githubusercontent.com/ros-planning/moveit/master/moveit.rosinstall && \
    wstool update -t src && \
    rosdep install -y --from-paths src --ignore-src --rosdistro melodic && \
    catkin config --extend /opt/ros/melodic --cmake-args -DCMAKE_BUILD_TYPE=Release && \
    catkin build

### Source workspace
RUN echo 'source ~/ws_moveit/devel/setup.bash' >> ~/.bashrc
RUN /bin/bash -c "source ~/.bashrc"

## Download Examples
RUN cd ~/ws_moveit/src && \
    rm -rf moveit_tutorials && \
    rm -rf panda_moveit_config && \
    git clone https://github.com/ros-planning/moveit_tutorials.git -b master && \
    git clone https://github.com/ros-planning/panda_moveit_config.git -b melodic-devel

# Expose Tensorboard
EXPOSE 6006

# Expose Jupyter 
EXPOSE 8888

# Update links
RUN apt upgrade -y

### Switch back to user
USER $USER

ENTRYPOINT ["/dockerstartup/vnc_startup.sh"]
CMD ["--wait"]
