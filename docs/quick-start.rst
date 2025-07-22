.. _quick-start:

Quick Start
===========

This guide will walk you through building your first Kuiper image with default 
settings. You'll have a functional Debian-based image ready for Analog Devices 
hardware in under an hour.

.. tip::
   **First time building?** The default configuration creates a basic but 
   fully functional image perfect for getting started. You can always 
   customize later!

----

Before You Begin
----------------

Ensure you've completed all the prerequisites:

.. grid:: 1 3 3 3
   :gutter: 2

   .. grid-item-card:: ✅ **Ubuntu 22.04 LTS**

      Recommended host OS

   .. grid-item-card:: ✅ **Docker 24.0.6+**

      Container runtime

   .. grid-item-card:: ✅ **10GB+ free space**

      For build artifacts

Haven't set up your environment yet? :doc:`Check the prerequisites <prerequisites>` first.

----

Step 1: Clone the Repository
----------------------------

Start by cloning the Kuiper build system to your local machine:

.. code-block:: bash
   :caption: Clone the repository

   # Clone with minimal history for faster download
   git clone --depth 1 https://github.com/analogdevicesinc/adi-kuiper-gen
   cd adi-kuiper-gen

.. important::
   **Path Requirements**
   
   Ensure your clone path contains **no spaces**. Paths with spaces will 
   cause the build to fail.
   
   * ✅ Good: ``/home/user/adi-kuiper-gen``
   * ❌ Bad: ``/home/user/my projects/adi-kuiper-gen``

----

Step 2: Review Default Configuration
------------------------------------

The default configuration provides a minimal but functional Kuiper image:

.. tab-set::

   .. tab-item:: What's Included

      .. list-table::
         :header-rows: 1
         :class: bold-header

         * - Component
           - Status
           - Description
         * - **Base System**
           - ✅ Included
           - Debian Bookworm, essential packages
         * - **User Account**
           - ✅ Included
           - User 'analog' with sudo access
         * - **SSH Server**
           - ✅ Included
           - Remote access enabled
         * - **Raspberry Pi Boot**
           - ✅ Included
           - Boot files for RPi 4/5
         * - **Desktop Environment**
           - ❌ Not included
           - Command-line only
         * - **ADI Tools**
           - ❌ Not included
           - Can be added later

   .. tab-item:: Configuration Details

      The default ``config`` file contains:

      .. code-block:: bash
         :caption: Default configuration settings

         # System Configuration
         TARGET_ARCHITECTURE=armhf          # 32-bit ARM
         DEBIAN_VERSION=bookworm           # Debian 12
         
         # Build Options
         PRESERVE_CONTAINER=n              # Clean up after build
         EXPORT_SOURCES=n                  # Don't download source
         
         # Features (all disabled by default)
         CONFIG_DESKTOP=n                  # No GUI
         CONFIG_LIBIIO=n                   # No ADI libraries
         CONFIG_PYADI=n                    # No Python bindings
         
         # Boot Files (enabled by default)
         CONFIG_RPI_BOOT_FILES=y           # Raspberry Pi support
         CONFIG_XILINX_INTEL_BOOT_FILES=y  # Carrier board support

   .. tab-item:: Customization Options

      Want to customize before building? Common modifications:

      **Enable Desktop Environment:**
      
      .. code-block:: bash

         CONFIG_DESKTOP=y

      **Add ADI Tools:**
      
      .. code-block:: bash

         CONFIG_LIBIIO=y
         CONFIG_IIO_OSCILLOSCOPE=y

      **Switch to 64-bit:**
      
      .. code-block:: bash

         TARGET_ARCHITECTURE=arm64

      For complete options, see the :doc:`configuration guide <configuration>`.

----

Step 3: Start the Build
-----------------------

Launch the build process with a single command:

.. code-block:: bash
   :caption: Build your Kuiper image

   sudo ./build-docker.sh

.. dropdown:: What happens during the build?
   :color: info

   The build process follows these stages:

   1. **Docker Setup** (2-3 minutes)
      
      * Downloads base Debian image
      * Installs build dependencies
      * Creates build container

   2. **System Bootstrap** (5-10 minutes)
      
      * Creates minimal Debian filesystem
      * Configures package repositories
      * Sets up basic system structure

   3. **Configuration** (10-15 minutes)
      
      * Creates users and passwords
      * Configures networking and SSH
      * Sets up locale and timezone

   4. **Boot Preparation** (5-10 minutes)
      
      * Installs boot files for target hardware
      * Configures filesystem table
      * Prepares kernel and device trees

   5. **Image Creation** (10-15 minutes)
      
      * Creates disk image with proper partitions
      * Copies all files to image
      * Compresses final output

   **Total time:** 30-60 minutes depending on your system and internet speed.

Build Progress Monitoring
~~~~~~~~~~~~~~~~~~~~~~~~~

Monitor the build progress with these indicators:

.. list-table::
   :header-rows: 1
   :class: bold-header

   * - Stage Message
     - What's Happening
     - Typical Duration
   * - ``Start stage 01.bootstrap``
     - Creating base filesystem
     - 5-10 minutes
   * - ``Start stage 02.set-locale-and-timezone``
     - System localization
     - 2-3 minutes
   * - ``Start stage 03.system-tweaks``
     - User and network setup
     - 3-5 minutes
   * - ``Start stage 06.boot-partition``
     - Installing boot files
     - 5-10 minutes
   * - ``Start stage 08.export-stage``
     - Creating final image
     - 10-15 minutes

.. tip::
   **Patience is key!** The first build downloads many packages and can take 
   time. Subsequent builds with similar configurations will be much faster 
   due to Docker layer caching.

----

Step 4: Locate Your Image
-------------------------

After a successful build, find your new Kuiper image:

.. code-block:: bash
   :caption: Navigate to output directory

   cd kuiper-volume
   ls -la *.zip

You'll see a file named:

.. code-block:: text

   image_YYYY-MM-DD-ADI-Kuiper-Linux-armhf.zip

Where ``YYYY-MM-DD`` is today's date and ``armhf`` is the architecture.

Build Artifacts
~~~~~~~~~~~~~~~

The ``kuiper-volume`` directory contains several useful files:

.. list-table::
   :header-rows: 1
   :class: bold-header

   * - File/Directory
     - Description
     - Use Case
   * - ``image_*.zip``
     - **Your Kuiper image** (main output)
     - Flash to SD card
   * - ``build.log``
     - Complete build log with timestamps
     - Troubleshooting builds
   * - ``ADI_repos_git_info.txt``
     - Git information for all ADI repositories
     - Version tracking
   * - ``licensing/``
     - License files for all included software
     - Compliance documentation

----

Step 5: Prepare SD Card
-----------------------

Extract and write your image to an SD card:

.. tab-set::

   .. tab-item:: Extract Image

      .. code-block:: bash
         :caption: Extract the image file

         # Extract the zip file
         unzip image_*-ADI-Kuiper-Linux-*.zip
         
         # Verify extraction
         ls -lh *.img

   .. tab-item:: Using Balena Etcher (Recommended)

      **Download:** https://www.balena.io/etcher/

      1. Launch Balena Etcher
      2. Click "Flash from file"
      3. Select your extracted ``.img`` file
      4. Select your SD card (8GB+ recommended)
      5. Click "Flash"

      .. .. image:: /sources/etcher-screenshot.png
      ..    :alt: Balena Etcher interface
      ..    :align: center

   .. tab-item:: Using Command Line

      .. code-block:: bash
         :caption: Write image using dd (Linux)

         # Find your SD card device
         sudo fdisk -l
         
         # Unmount if auto-mounted
         sudo umount /dev/sdX*
         
         # Write image (replace sdX with your device)
         sudo dd if=image_*-ADI-Kuiper-Linux-*.img of=/dev/sdX bs=4M status=progress conv=fsync
         
         # Ensure data is written
         sync

      .. warning::
         **Double-check device name!** Writing to the wrong device can 
         destroy data. Your SD card is typically ``/dev/sdX`` or ``/dev/mmcblkX``.

----

Step 6: Boot Your Device
------------------------

.. grid:: 1 2 2 2
   :gutter: 3

   .. grid-item-card:: 🔌 **Hardware Setup**

      1. Insert SD card into target device
      2. Connect ethernet cable (if available)
      3. Connect display and keyboard (optional)
      4. Power on the device

   .. grid-item-card:: ⏱️ **First Boot**

      * Initial boot takes 2-3 minutes
      * Root partition auto-expands to full SD card
      * System shows login prompt when ready

   .. grid-item-card:: 🔐 **Login Credentials**

      * **Username:** ``analog``
      * **Password:** ``analog``
      * **Root access:** ``sudo`` or direct root login

   .. grid-item-card:: 🌐 **Network Access**

      * Ethernet: Automatic DHCP
      * WiFi: Use ``nmtui`` to configure
      * SSH: Enabled by default

Quick Verification
~~~~~~~~~~~~~~~~~~

Verify your Kuiper system is working properly:

.. code-block:: bash
   :caption: System verification commands

   # Check system information
   cat /etc/os-release
   uname -a
   
   # Verify network connectivity
   ip addr show
   ping -c 3 google.com
   
   # Check available disk space
   df -h

Expected output shows Debian 12 (Bookworm) with kernel optimized for your 
target hardware.

----

Troubleshooting Quick Start
---------------------------

.. dropdown:: Build fails with "permission denied"
   :color: warning

   **Problem:** Docker access issues

   **Solution:** Ensure you're using ``sudo``:
   
   .. code-block:: bash

      sudo ./build-docker.sh

.. dropdown:: "No space left on device" during build
   :color: warning

   **Problem:** Insufficient disk space

   **Solutions:**
   
   * Check available space: ``df -h``
   * Clean Docker cache: ``sudo docker system prune -a``
   * Free up at least 15GB

.. dropdown:: SD card not booting
   :color: warning

   **Problem:** Image writing or hardware issues

   **Troubleshooting steps:**
   
   1. Verify image integrity: ``md5sum image_*.img``
   2. Try a different SD card (8GB+, Class 10)
   3. Re-flash with different tool
   4. Check target hardware compatibility

.. dropdown:: Cannot connect via SSH
   :color: warning

   **Problem:** Network or SSH configuration

   **Solutions:**
   
   1. Find device IP: Check router admin or use ``nmap``
   2. Verify SSH is running: ``systemctl status ssh``
   3. Try direct console access first
   4. Check firewall settings

----

Next Steps
----------

Congratulations! You've successfully built and deployed your first Kuiper image. 

.. grid:: 1 2 2 2
   :gutter: 3

   .. grid-item-card:: 🔧 **Customize Your Build**
      :link: configuration
      :link-type: doc

      Add desktop environment, ADI tools, or configure for specific 
      hardware platforms.

   .. grid-item-card:: 📚 **Understanding the Build**
      :link: build-flow
      :link-type: doc

      Learn how the build process works and how to modify or extend 
      the build stages.

   .. grid-item-card:: 🛠️ **Advanced Topics**
      :link: configuration
      :link-type: doc

      Explore custom scripts, cross-compilation, and advanced 
      configuration options.

   .. grid-item-card:: ❓ **Get Help**
      :link: troubleshooting
      :link-type: doc

      Find solutions to common issues or get help with advanced 
      configurations.

.. tip:: **Development Workflow**
   
   For iterative development:
   
   1. Make configuration changes
   2. Rebuild: ``sudo ./build-docker.sh``
   3. Test on target hardware
   4. Repeat as needed

   Docker caching makes subsequent builds much faster!
