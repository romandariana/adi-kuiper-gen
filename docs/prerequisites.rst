.. _prerequisites:

Prerequisites
=============

Before building your first Kuiper image, ensure your development environment 
meets these requirements. We've designed this guide to help you verify and 
set up everything needed for a successful build.

.. important::
   **Operating System Support**
   
   Ubuntu 22.04 LTS is the recommended and officially supported platform. 
   Other Linux distributions may work but could encounter compatibility issues.
   
   **Windows is not supported** for Kuiper builds.

----

System Requirements
-------------------

.. grid:: 1 2 2 2
   :gutter: 3

   .. grid-item-card:: 💾 **Storage Space**

      **Minimum:** 10GB free disk space
      
      * Base system: ~3GB
      * Build artifacts: ~4GB  
      * Docker images: ~2GB
      * Output files: ~1GB

   .. grid-item-card:: 🖥️ **Memory & CPU**

      **Recommended:** 8GB RAM, 4+ CPU cores
      
      * Minimum: 4GB RAM, 2 cores
      * Build time scales with CPU cores
      * More RAM = faster Docker operations

   .. grid-item-card:: 🌐 **Network Access**

      **Required:** Stable internet connection
      
      * Package downloads: ~1-2GB
      * Git repository access
      * Docker Hub access

   .. grid-item-card:: ⚠️ **Path Requirements**

      **Critical:** No spaces in repository path
      
      * ✅ Good: ``/home/user/kuiper``
      * ❌ Bad: ``/home/user/my projects/kuiper``
      * Required by debootstrap

----

Required Software
-----------------

Docker Installation
~~~~~~~~~~~~~~~~~~~

Docker is essential for creating the isolated build environment. Kuiper requires 
Docker version 24.0.6 or newer.

.. tab-set::

   .. tab-item:: Check Installation

      Verify if Docker is already installed:

      .. code-block:: bash

         docker --version
         # Expected output: Docker version 24.0.6 or higher

   .. tab-item:: Install Docker

      If Docker isn't installed, follow the official guide:

      .. code-block:: bash

         # Quick installation for Ubuntu
         curl -fsSL https://get.docker.com -o get-docker.sh
         sudo sh get-docker.sh

      For complete installation instructions, visit: 
      https://docs.docker.com/engine/install/

   .. tab-item:: User Permissions

      Add your user to the docker group (optional but recommended):

      .. code-block:: bash

         sudo usermod -aG docker $USER
         # Log out and back in for changes to take effect

      .. note::
         If you skip this step, you'll need to use ``sudo`` with all 
         docker commands, which the build script already handles.

Cross-Architecture Support
~~~~~~~~~~~~~~~~~~~~~~~~~~

To build ARM-based images on x86 systems, you need these packages:

.. code-block:: bash
   :caption: Install cross-architecture support

   sudo apt-get update
   sudo apt-get install qemu-user-static binfmt-support

.. dropdown:: What do these packages do?
   :color: info

   * **qemu-user-static**: Emulates ARM architecture on x86 systems
   * **binfmt-support**: Allows the kernel to run binaries from different architectures

   These enable your x86 computer to build ARM images that will run on 
   Raspberry Pi and other ARM-based devices.

Kernel Module Setup
~~~~~~~~~~~~~~~~~~~

The ``binfmt_misc`` kernel module must be loaded:

.. code-block:: bash
   :caption: Load the required kernel module

   sudo modprobe binfmt_misc

.. tab-set::

   .. tab-item:: Verify Module

      Check if the module is loaded:

      .. code-block:: bash

         lsmod | grep binfmt_misc
         # Should show: binfmt_misc

   .. tab-item:: Persistent Loading

      To load automatically on boot, add to ``/etc/modules``:

      .. code-block:: bash

         echo 'binfmt_misc' | sudo tee -a /etc/modules

   .. tab-item:: WSL Users

      If using Windows Subsystem for Linux:

      .. code-block:: bash

         sudo update-binfmts --enable

----

Pre-Build Verification
----------------------

Run this verification script to ensure everything is properly configured:

.. code-block:: bash
   :caption: Complete system verification

   #!/bin/bash
   echo "🔍 Kuiper Prerequisites Verification"
   echo "=================================="
   
   # Check OS
   if [[ $(lsb_release -rs) == "22.04" ]]; then
       echo "✅ Ubuntu 22.04 LTS detected"
   else
       echo "⚠️  OS: $(lsb_release -d -s) (Ubuntu 22.04 recommended)"
   fi
   
   # Check Docker
   if command -v docker &> /dev/null; then
       DOCKER_VERSION=$(docker --version | grep -oP '\d+\.\d+\.\d+')
       echo "✅ Docker $DOCKER_VERSION installed"
   else
       echo "❌ Docker not found - please install Docker"
   fi
   
   # Check cross-architecture support
   if command -v qemu-arm-static &> /dev/null; then
       echo "✅ qemu-user-static installed"
   else
       echo "❌ qemu-user-static missing"
   fi
   
   # Check binfmt module
   if lsmod | grep -q binfmt_misc; then
       echo "✅ binfmt_misc module loaded"
   else
       echo "❌ binfmt_misc module not loaded"
   fi
   
   # Check disk space
   AVAILABLE=$(df . | tail -1 | awk '{print $4}')
   if [[ $AVAILABLE -gt 10485760 ]]; then  # 10GB in KB
       echo "✅ Sufficient disk space available"
   else
       echo "⚠️  Less than 10GB free space available"
   fi
   
   echo ""
   echo "If any items show ❌, please address them before building."

Save this script and run it to verify your setup:

.. code-block:: bash

   chmod +x verify-prereqs.sh
   ./verify-prereqs.sh

----

Common Setup Issues
-------------------

.. dropdown:: "Permission denied" when running Docker
   :color: warning

   **Problem:** Cannot access Docker daemon without sudo

   **Solutions:**
   
   1. **Recommended:** Use sudo with the build script (no setup required):
      
      .. code-block:: bash

         sudo ./build-docker.sh
   
   2. **Alternative:** Add user to docker group:
      
      .. code-block:: bash

         sudo usermod -aG docker $USER
         # Log out and back in

.. dropdown:: "Exec format error" during build
   :color: warning

   **Problem:** Cannot execute ARM binaries

   **Solution:** Ensure cross-architecture support is properly installed:
   
   .. code-block:: bash

      # Reinstall packages
      sudo apt-get install --reinstall qemu-user-static binfmt-support
      
      # Reload module
      sudo modprobe -r binfmt_misc
      sudo modprobe binfmt_misc
      
      # Verify files exist
      ls -la /usr/bin/qemu-arm-static

.. dropdown:: Build fails with "No space left on device"
   :color: warning

   **Problem:** Insufficient disk space during build

   **Solutions:**
   
   * Clean Docker system: ``docker system prune -a``
   * Move to larger partition
   * Free up at least 15GB for comfortable building

.. dropdown:: Repository path contains spaces
   :color: warning

   **Problem:** debootstrap fails with path containing spaces

   **Solution:** Move repository to path without spaces:
   
   .. code-block:: bash

      # Bad: /home/user/my projects/kuiper-gen
      # Good: /home/user/kuiper-gen
      mv "/home/user/my projects/kuiper-gen" /home/user/kuiper-gen

----

Next Steps
----------

Once all prerequisites are satisfied:

.. grid:: 1 2 2 2
   :gutter: 2

   .. grid-item-card:: 🚀 **Ready to Build**
      :link: quick-start
      :link-type: doc

      Your system is configured! Proceed to the Quick Start guide to 
      build your first Kuiper image.

   .. grid-item-card:: 🔧 **Customize First**
      :link: configuration
      :link-type: doc

      Want to customize your build? Check out the configuration options 
      before building.

.. tip:: **Save Time on Future Builds**
   
   Once you've completed this setup, these prerequisites remain valid for 
   all future Kuiper builds. You only need to do this once per system!
