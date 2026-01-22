FROM debian:bookworm AS pegasus-base

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt update && apt install --yes --quiet --no-install-recommends \
  sudo \
  git \
  pkg-config \
  build-essential \
  gdb \
  cmake \
  ca-certificates

RUN apt clean -y && apt autoremove -y

# Create a runner user for better integration with GitHub
ARG USERNAME=runner
RUN useradd -m ${USERNAME} && echo ${USERNAME} ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USERNAME}

# Install vcpkg in /opt/
WORKDIR /opt

# Setting VCPKG tag to checkout
ARG VCPKG_TAG=2026.01.16

# Instead of cloning, just download and unpack the target version.
RUN wget https://github.com/microsoft/vcpkg/archive/refs/tags/${VCPKG_TAG}.tar.gz && tar xzf ${VCPKG_TAG}.tar.gz && rm ${VCPKG_TAG}.tar.gz
RUN ./vcpkg-${VCPKG_TAG}/bootstrap-vcpkg.sh -disableMetrics

# Set some environment variables
ENV VCPKG_ROOT=/opt/vcpkg-${VCPKG_TAG}
ENV PATH=${VCPKG_ROOT}:$PATH CMAKE_TOOLCHAIN_FILE=${VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake

# Installing packages in classic mode instead of using a manifest file.
RUN vcpkg install fmt gtest spdlog opencv grpc
