FROM nvidia/cuda:10.2-base
CMD nvidia-smi

# Pull base image.
FROM ubuntu:18.04
LABEL maintainer "rohit_ranjan@kgpian.iitkgp.ac.in"

ENV DEBIAN_FRONTEND noninteractive

# Install updates
RUN apt-get update && apt-get install -y build-essential

# Install ROS Melodic
RUN apt-get update
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN apt-get -y install curl
RUN curl -s -k https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -
RUN apt update
RUN apt-get install -y ros-melodic-desktop-full
RUN apt-get install -y python-rosdep python-rosinstall python-rosinstall-generator python-wstool build-essential
RUN rosdep init && rosdep update

# Install some essentials
RUN apt-get install -y python-pip wget
RUN apt-get install -y ros-melodic-catkin python-catkin-tools ros-melodic-costmap-converter ros-melodic-base-local-planner ros-melodic-move-base ros-melodic-fake-localization
RUN sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list'
RUN wget https://packages.osrfoundation.org/gazebo.key -O - | sudo apt-key add -
RUN apt-get update
RUN apt-get install gazebo9
RUN apt upgrade libignition-math2
RUN apt-get install -y ros-melodic-gazebo-ros-pkgs ros-melodic-gazebo-ros-control
RUN pip install pyyaml rospkg

# Setup the shell
RUN /bin/bash -c "echo 'export HOME=/home/ubuntu' >> /root/.bashrc"
RUN /bin/bash -c "echo 'source /opt/ros/melodic/setup.bash' >> /root/.bashrc"
RUN cp /root/.bashrc /home/ubuntu/.bashrc
RUN /bin/bash -c "source /home/ubuntu/.bashrc"

COPY ros_melodic_ /home/ubuntu/workspaces
