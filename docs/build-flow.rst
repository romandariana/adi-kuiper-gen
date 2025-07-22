.. _build-flow:

Build Flow
==========

The Kuiper build process uses Docker to create a controlled environment for 
building Debian-based images for Analog Devices products. The build follows 
these high-level steps:

1. ``build-docker.sh`` creates a Docker container with all necessary build dependencies
2. Inside the container, ``kuiper-stages.sh`` orchestrates a series of build stages
3. Each stage performs specific tasks like system configuration, tool installation, and boot setup
4. The final image is exported as a zip file to the ``kuiper-volume`` directory on your host machine

This approach ensures consistent builds across different host systems while 
allowing full customization through the ``config`` file.

The ``config`` file is first read by ``build-docker.sh`` on the host system 
to set up environment variables and Docker options. It is then copied into 
the container where ``kuiper-stages.sh`` reads it again to determine which 
stages to execute and how to configure them.

.. raw:: html

     <svg viewBox="0 0 800 650" class="kuiper-build-flow-diagram" xmlns="http://www.w3.org/2000/svg">
     <defs>
       <!-- Arrow marker -->
       <marker id="arrowhead" markerWidth="10" markerHeight="7" 
               refX="9" refY="3.5" orient="auto" fill="#667eea">
         <polygon points="0 0, 10 3.5, 0 7" />
       </marker>
       
       <!-- Gradient for containers -->
       <linearGradient id="hostGradient" x1="0%" y1="0%" x2="0%" y2="100%">
         <stop offset="0%" style="stop-color:#f8f9fa;stop-opacity:1" />
         <stop offset="100%" style="stop-color:#e9ecef;stop-opacity:1" />
       </linearGradient>
       
       <linearGradient id="containerGradient" x1="0%" y1="0%" x2="0%" y2="100%">
         <stop offset="0%" style="stop-color:#e3f2fd;stop-opacity:1" />
         <stop offset="100%" style="stop-color:#bbdefb;stop-opacity:1" />
       </linearGradient>
       
       <linearGradient id="outputGradient" x1="0%" y1="0%" x2="0%" y2="100%">
         <stop offset="0%" style="stop-color:#e8f5e8;stop-opacity:1" />
         <stop offset="100%" style="stop-color:#c8e6c9;stop-opacity:1" />
       </linearGradient>
     </defs>

     <!-- 🖥️ Host System -->
     <rect x="100" y="50" width="560" height="560" rx="8" 
           fill="url(#hostGradient)" stroke="#6c757d" stroke-width="2"/>
     <text x="650" y="80" text-anchor="end" font-family="Arial, sans-serif" font-size="18" font-weight="bold" fill="#333">
       🖥️ Host System
     </text>

     <!-- build-docker.sh -->
     <rect x="170" y="100" width="140" height="60" rx="4" 
           fill="white" stroke="#adb5bd" stroke-width="1"/>
     <text x="240" y="120" text-anchor="middle" font-family="Arial, sans-serif" font-size="14" font-weight="bold">🐳 build-docker.sh</text>
     <text x="240" y="135" text-anchor="middle" font-family="Arial, sans-serif" font-size="11" fill="#666">Reads config,</text>
     <text x="240" y="150" text-anchor="middle" font-family="Arial, sans-serif" font-size="11" fill="#666">creates container</text>

     <!-- Config file -->
     <rect x="450" y="100" width="140" height="60" rx="4" 
           fill="white" stroke="#adb5bd" stroke-width="1"/>
     <text x="520" y="125" text-anchor="middle" font-family="Arial, sans-serif" font-size="14" font-weight="bold">📄 config</text>
     <text x="520" y="145" text-anchor="middle" font-family="Arial, sans-serif" font-size="12" fill="#666">Build configuration</text>

     <!-- Arrow from config to build-docker.sh -->
     <line x1="450" y1="130" x2="310" y2="130" stroke="#667eea" stroke-width="2" marker-end="url(#arrowhead)"/>

     <!-- 🐳 Docker Container -->
     <rect x="130" y="180" width="500" height="250" rx="6" 
           fill="url(#containerGradient)" stroke="#2196f3" stroke-width="2"/>
     <text x="620" y="205" text-anchor="end" font-family="Arial, sans-serif" font-size="16" font-weight="bold" fill="#1976d2">
       🐳 Docker Container
     </text>

     <!-- kuiper-stages.sh -->
     <rect x="280" y="220" width="120" height="50" rx="3" 
           fill="white" stroke="#90a4ae" stroke-width="1"/>
     <text x="340" y="235" text-anchor="middle" font-family="Arial, sans-serif" font-size="12" font-weight="bold">⚙️ kuiper-stages.sh</text>
     <text x="340" y="250" text-anchor="middle" font-family="Arial, sans-serif" font-size="10" fill="#666">Orchestrates build</text>
     <text x="340" y="262" text-anchor="middle" font-family="Arial, sans-serif" font-size="10" fill="#666">stages</text>

     <!-- Config copy -->
     <rect x="460" y="220" width="120" height="50" rx="3" 
           fill="white" stroke="#90a4ae" stroke-width="1"/>
     <text x="520" y="240" text-anchor="middle" font-family="Arial, sans-serif" font-size="12" font-weight="bold">📄 config (copy)</text>
     <text x="520" y="255" text-anchor="middle" font-family="Arial, sans-serif" font-size="10" fill="#666">Configuration copy</text>

     <!-- Stage Execution -->
     <rect x="280" y="290" width="120" height="50" rx="3" 
           fill="white" stroke="#90a4ae" stroke-width="1"/>
     <text x="340" y="310" text-anchor="middle" font-family="Arial, sans-serif" font-size="12" font-weight="bold">🔧 Stage Execution</text>
     <text x="340" y="325" text-anchor="middle" font-family="Arial, sans-serif" font-size="10" fill="#666">Processes all</text>
     <text x="340" y="337" text-anchor="middle" font-family="Arial, sans-serif" font-size="10" fill="#666">build stages</text>

     <!-- Image Creation -->
     <rect x="280" y="360" width="120" height="50" rx="3" 
           fill="white" stroke="#90a4ae" stroke-width="1"/>
     <text x="340" y="380" text-anchor="middle" font-family="Arial, sans-serif" font-size="12" font-weight="bold">💿 Image Creation</text>
     <text x="340" y="395" text-anchor="middle" font-family="Arial, sans-serif" font-size="10" fill="#666">Generates</text>
     <text x="340" y="407" text-anchor="middle" font-family="Arial, sans-serif" font-size="10" fill="#666">final image</text>

     <!-- Arrows within Docker container -->
     <!-- config copy to kuiper-stages.sh -->
     <line x1="460" y1="245" x2="400" y2="245" stroke="#667eea" stroke-width="2" marker-end="url(#arrowhead)"/>
     
     <!-- kuiper-stages.sh to Stage Execution -->
     <line x1="340" y1="270" x2="340" y2="290" stroke="#667eea" stroke-width="2" marker-end="url(#arrowhead)"/>
     
     <!-- Stage Execution to Image Creation -->
     <line x1="340" y1="340" x2="340" y2="360" stroke="#667eea" stroke-width="2" marker-end="url(#arrowhead)"/>

     <!-- Arrow from build-docker.sh to docker container -->
     <line x1="240" y1="160" x2="240" y2="180" stroke="#667eea" stroke-width="2" marker-end="url(#arrowhead)"/>
     <text x="250" y="172" font-family="Arial, sans-serif" font-size="10" fill="#666" font-style="italic">Creates Docker container</text>

     <!-- 📁 kuiper-volume -->
     <rect x="200" y="460" width="350" height="120" rx="8" 
           fill="url(#outputGradient)" stroke="#4caf50" stroke-width="2"/>
     <text x="350" y="485" text-anchor="end" font-family="Arial, sans-serif" font-size="16" font-weight="bold" fill="#2e7d32">
       📁 kuiper-volume/
     </text>

     <!-- Build Artifacts -->
     <text x="220" y="510" font-family="Arial, sans-serif" font-size="12" fill="#333">├──image_YYYY-MM-DD-ADI-Kuiper-Linux-[arch].zip</text>
     <text x="220" y="525" font-family="Arial, sans-serif" font-size="12" fill="#333">├──build.log</text>
     <text x="220" y="540" font-family="Arial, sans-serif" font-size="12" fill="#333">├──ADI_repos_git_info.txt</text>
     <text x="220" y="554" font-family="Arial, sans-serif" font-size="12" fill="#333">├──licensing/</text>
     <text x="220" y="568" font-family="Arial, sans-serif" font-size="12" fill="#333">└──sources/</text>

     <!-- Arrow from docker container to output -->
     <line x1="340" y1="430" x2="340" y2="460" stroke="#667eea" stroke-width="2" marker-end="url(#arrowhead)"/>
     <text x="350" y="447" font-family="Arial, sans-serif" font-size="10" fill="#666" font-style="italic">Outputs to host</text>

   </svg>

----

Docker Build Environment
------------------------

Docker is used to perform the build inside a container, which partially 
isolates the build from the host system. This allows the script to work on 
non-Debian based systems (e.g., Fedora Linux). The isolation is not total 
due to the need to use some kernel-level services for ARM emulation (binfmt) 
and loop devices (losetup).

The ``build-docker.sh`` script handles:

- Checking prerequisites and permissions
- Building a Docker image with all necessary dependencies
- Running a Docker container with appropriate options
- Mounting volumes to share data between the host and container
- Setting environment variables based on the ``config`` file
- Starting the internal build process by calling ``kuiper-stages.sh``
- Cleaning up the container after completion (if ``PRESERVE_CONTAINER=n``)

Running the Build
~~~~~~~~~~~~~~~~~

To build:

.. shell::

   sudo bash build-docker.sh

or

.. shell::

   sudo ./build-docker.sh

Your Kuiper image will be in the ``kuiper-volume/`` folder inside the cloned 
repository on your machine as a zip file named 
``image_YYYY-MM-DD-ADI-Kuiper-Linux-[arch].zip``. After successful build, 
the Docker image and the build container are removed if ``PRESERVE_CONTAINER=n``.

If needed, you can remove the build container with:

.. shell::

   docker rm -v debian_<DEBIAN_VERSION>_rootfs_container

If you choose to preserve the Docker container, you can access the Kuiper 
root filesystem by copying it from the container to your machine with this command:

.. shell::

   CONTAINER_ID=$(docker inspect --format="{{.Id}}" debian_<DEBIAN_VERSION>_rootfs_container)
   sudo docker cp $CONTAINER_ID:<TARGET_ARCHITECTURE>_rootfs .

You need to replace ``<DEBIAN_VERSION>`` and ``<TARGET_ARCHITECTURE>`` with 
the ones in the configuration file.

Example:

.. shell::

   CONTAINER_ID=$(docker inspect --format="{{.Id}}" debian_bookworm_rootfs_container)
   sudo docker cp $CONTAINER_ID:armhf_rootfs .

Docker Container Configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

When the Docker container is run, various required command line arguments are provided:

- ``-t``: Allocates a pseudo-TTY allowing interaction with container's shell
- ``--privileged``: Provides elevated privileges required by the chroot command
- ``-v /dev:/dev``: Mounts the host system's device directory
- ``-v /lib/modules:/lib/modules``: Mounts kernel modules from the host
- ``-v ./kuiper-volume:/kuiper-volume``: Creates a shared volume for the output
- ``-e "DEBIAN_VERSION={value}"``: Sets environment variables from the config file

The ``--name`` and ``--privileged`` options are already set by the script and 
should not be redefined.

----

Stage-Based Build Process
-------------------------

Inside the Docker container, ``kuiper-stages.sh`` orchestrates the entire 
build process. This script reads the ``config`` file, sets up environment 
variables, and executes a series of stages in a specific order.

How Stages Are Processed
~~~~~~~~~~~~~~~~~~~~~~~~

The build process follows these steps inside the Docker container:

1. ``kuiper-stages.sh`` loops through the ``stages`` directory in alphanumeric order
2. Within each stage, it processes subdirectories in alphanumeric order
3. For each subdirectory, it runs the following files if they exist:

   - ``run.sh`` - A shell script executed in the Docker container's context
   - ``run-chroot.sh`` - A shell script executed within the Kuiper image using chroot
   - Package installation files:

     - ``packages-[*]`` - Lists packages to install with ``--no-install-recommends``
     - ``packages-[*]-with-recommends`` - Lists packages to install with their recommended dependencies

The package installation files (``packages-[*]``) are processed if the 
corresponding configuration option is enabled. For example, ``packages-desktop`` 
is only processed if ``CONFIG_DESKTOP=y`` in the config file.

Key Stages Overview
~~~~~~~~~~~~~~~~~~~

The build process is divided into several stages for logical clarity and modularity:

- **01.bootstrap** - Creates a usable filesystem using ``debootstrap``
- **02.set-locale-and-timezone** - Configures system locale and timezone settings
- **03.system-tweaks** - Sets up users, passwords, and system configuration
- **04.configure-desktop-env** - Installs and configures desktop environment (if enabled)
- **05.adi-tools** - Installs Analog Devices libraries and tools (based on config)
- **06.boot-partition** - Adds boot files for different platforms
- **07.extra-tweaks** - Applies custom scripts and additional configurations
- **08.export-stage** - Creates and exports the final image

Each stage contains multiple substages that handle specific aspects of the 
build process. The stages are designed to be modular, allowing for easy 
customization and extension.

For a more detailed description of each stage and its purpose, see the 
:doc:`Stage Reference <stage-reference>` section.

Stage Execution Logic
~~~~~~~~~~~~~~~~~~~~~

The ``kuiper-stages.sh`` script contains a helper function called 
``install_packages`` that handles package installation for each stage. This function:

1. Checks if package files exist for the current stage
2. Verifies if the corresponding configuration option is enabled
3. Installs the packages using the appropriate apt-get command

The script then executes each stage's ``run.sh`` script, which may perform 
additional configuration steps, compile software from source, or prepare files 
for the final image.

This modular approach allows users to easily customize the build process by 
modifying existing stages or adding new ones.
