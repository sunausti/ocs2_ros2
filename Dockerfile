FROM osrf/ros:humble-desktop-full
SHELL ["/bin/bash", "-c"]
ENV DEBIAN_FRONTEND=noninteractive
ARG GIT_TOKEN
ENV GIT_TOKEN=${GIT_TOKEN}
RUN apt-get update && apt-get install -y --no-install-recommends \
    libglpk-dev \
    keyboard-configuration --assume-yes \
    libmpfr-dev \
    gnome-terminal \
    git liburdfdom-dev liboctomap-dev libassimp-dev libeigen3-dev \
    libxcb-xinerama0 libx11-xcb1 libglu1-mesa libxrender1 \
    libxkbcommon-x11-0 dbus-x11 at-spi2-core libcanberra-gtk-module libcanberra-gtk3-module \
    ros-iron-grid-map-cv ros-iron-grid-map-msgs ros-iron-grid-map-ros ros-iron-grid-map-sdf \
    libmpfr-dev libpcap-dev \
    && rm -rf /var/lib/apt/lists/*
RUN mkdir -p ocs2_ws/
RUN git clone --recurse-submodules https://github.com/sunausti/ocs2_ros2.git /ros2_ws/src
WORKDIR /ros2_ws
RUN apt-get update \
    && rosdep update \
    && rosdep install --from-paths src --ignore-src -r -y \
    && source /ros_entrypoint.sh \
    && colcon build --packages-up-to ocs2_legged_robot_ros  ocs2_quadrotor_ros \
    ocs2_ballbot_ros ocs2_double_integrator_ros ocs2_mobile_manipulator_ros

