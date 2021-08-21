FROM ros:melodic
# Setup all the keys and install packages which need root access.
USER root

RUN . /opt/ros/melodic/setup.sh && \
    apt-get update && \
    apt-get install -y wget gnupg2 lsb-release && \
    apt-get install -y python3-colcon-common-extensions && \
    sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list' && \
    wget https://packages.osrfoundation.org/gazebo.key -O - | sudo apt-key add - && \
    apt-get update && \
    sudo apt-get install -y gazebo9 &&\
    sudo apt-get install -y libignition-common3-graphics-dev

RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN wget https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc -O - | sudo apt-key add - 
#&& \
    #sh -c 'echo "deb [arch=$(dpkg --print-architecture)] http://packages.ros.org/ros/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/ros-latest.list'

#RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -

# #Setup agv USER
RUN groupadd -g 1000 agv && \
    useradd -d /home/agv -s /bin/bash -m agv -u 1000 -g 1000 && \
    usermod -aG sudo agv && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers 

USER agv
RUN mkdir -p /home/agv/frenet_ws/src
ENV HOME /home/agv
WORKDIR /home/agv/frenet_ws/
COPY src /home/agv/frenet_ws/src/

#Setup dependencies
RUN echo 'debconf debconf/frontend select Noninteractive' | sudo debconf-set-selections
#RUN sudo apt-get install -y ros-melodic-navigation2 ros-melodic-nav2-bringup ros-melodic-turtlebot3*
RUN sudo rm -rf /var/lib/apt/lists/* /etc/ros/rosdep/sources.list.d/20-default.list
RUN sudo apt-get update &&\
    sudo rosdep init &&\
    sudo rosdep update 
RUN echo 'source /opt/ros/melodic/setup.bash' >> ~/.bashrc 
