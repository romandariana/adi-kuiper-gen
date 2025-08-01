.. _use-image:

Using the Generated Image
==========================

After successfully building your Kuiper image, you'll need to write it to an 
SD card or storage device and boot your target hardware. This section guides 
you through that process.

----

Extracting the Image
--------------------

The build process produces a zip file in the ``kuiper-volume/`` directory. 
Extract it using:

.. code-block:: bash
   :caption: Extract the image

   # Navigate to the kuiper-volume directory
   cd kuiper-volume

   # Extract the image
   unzip image_YYYY-MM-DD-ADI-Kuiper-Linux-[arch].zip

----

Writing the Image to an SD Card
-------------------------------

Using Balena Etcher (Recommended)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

`Balena Etcher <https://www.balena.io/etcher/>`_ provides a simple, graphical 
interface for writing images to SD cards and is the recommended method:

1. **Download and install** `Balena Etcher <https://www.balena.io/etcher/>`_.
2. **Launch Etcher** and click "Flash from file".
3. **Select the image file** you extracted from the zip.
4. **Select your SD card** as the target.
5. **Click "Flash"** and wait for the process to complete.

Using Command Line on Linux
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

For users who prefer command line tools:

1. **Insert your SD card** into your computer.
2. **Identify the device name** of your SD card:

   .. code-block:: bash

      sudo fdisk -l

   Look for a device like ``/dev/sdX`` or ``/dev/mmcblkX`` (where X is a 
   letter or number) that matches your SD card's size.

3. **Unmount any auto-mounted partitions**:

   .. code-block:: bash

      sudo umount /dev/sdX*

   Replace ``/dev/sdX`` with your actual device path.

4. **Write the image to the SD card**:

   .. code-block:: bash

      sudo dd if=image_YYYY-MM-DD-ADI-Kuiper-Linux-[arch].img of=/dev/sdX bs=4M status=progress conv=fsync

   Replace ``/dev/sdX`` with your actual device path, and update the image 
   filename accordingly.

5. **Ensure all data is written**:

   .. code-block:: bash

      sudo sync

6. **Eject the SD card**:

   .. code-block:: bash

      sudo eject /dev/sdX

----

Booting Your Device
-------------------

1. **Insert the SD card** into your target device.
2. **Connect required peripherals** (power, display, keyboard if needed).
3. **Power on the device**.
4. The first boot may take longer as the system automatically resizes the root partition to use the full SD card capacity.

----

Login Information
-----------------

- **Username**: analog
- **Password**: analog

Root access is available using the same password with ``sudo`` or by logging 
in directly as root.

----

Accessing Your Kuiper System
----------------------------

Console Access
~~~~~~~~~~~~~~

Connect directly with a keyboard and display if your hardware supports it.

SSH Access
~~~~~~~~~~

If your device is connected to a network, you can access it via SSH:

.. code-block:: bash

   ssh analog@<device-ip-address>

Replace ``<device-ip-address>`` with the actual IP address of your device.

VNC Access (If desktop environment was enabled)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If you built your image with ``CONFIG_DESKTOP=y``, you can access the 
graphical environment via VNC:

1. Connect to your device using a VNC client (like RealVNC, TigerVNC, or Remmina).
2. Use the device's IP address and port 5900 (e.g., ``192.168.1.100:5900``).

----

Verifying Your Installation
---------------------------

To verify that your Kuiper image is working correctly:

1. **Check system information**:

   .. code-block:: bash

      cat /etc/os-release
      uname -a

2. **Verify ADI tools** (if you included them in your build):

   .. code-block:: bash

      # For libiio (if installed)
      iio_info -h

      # For IIO Oscilloscope (if installed)
      osc -h

3. **Check available hardware**:

   .. code-block:: bash

      # List connected IIO devices (if libiio installed)
      iio_info
