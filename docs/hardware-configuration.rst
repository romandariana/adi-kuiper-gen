.. _hardware-configuration:

Hardware Configuration
======================

Kuiper allows you to configure your image to work with specific ADI evaluation boards and carrier platforms both during the build process and after deployment. This flexibility lets you create images that are ready for your primary hardware while maintaining the ability to reconfigure for different hardware later.

.. description::

   Configure Kuiper images for different ADI evaluation boards and carrier platforms using build-time configuration and runtime reconfiguration

----

How Hardware Configuration Works
--------------------------------

Kuiper uses a unified approach to hardware configuration that works at both build time and runtime:

**Build-Time Configuration (Optional)**
   Set ``ADI_EVAL_BOARD`` and ``CARRIER`` parameters in your config file before building. Your image will be automatically configured for that specific hardware combination during the build process. See the :doc:`Configuration <configuration>` section for details on these parameters.

**Runtime Reconfiguration (Always Available)**
   Use the built-in ``configure-setup.sh`` script to configure or reconfigure your Kuiper image for different hardware combinations after deployment. This script is always installed and available, regardless of whether you used build-time configuration.

**Key Benefits:**

- **Set defaults at build time** for your primary hardware target
- **Reconfigure anytime** for testing different evaluation boards
- **Use the same image** across multiple hardware platforms
- **No rebuilding required** when switching hardware configurations

Using Hardware Configuration
----------------------------

When to Configure Hardware
~~~~~~~~~~~~~~~~~~~~~~~~~~

Hardware configuration and reconfiguration is useful when you need to:

- **Set up your primary hardware** during the build process for immediate use
- **Test multiple evaluation boards** with the same Kuiper installation  
- **Switch between development and production hardware** without rebuilding images
- **Explore different ADI evaluation projects** on various carrier boards
- **Use a single image** across multiple hardware setups in your lab or production environment

Common Workflows
~~~~~~~~~~~~~~~~

**Single Hardware Target**
   Set ``ADI_EVAL_BOARD`` and ``CARRIER`` during build for automatic configuration. Your image boots ready to use with your hardware.

**Multi-Hardware Development**  
   Build with your primary hardware configured, then use runtime reconfiguration to test other combinations as needed.

**Flexible Lab Image**
   Build without specifying hardware (leave ``ADI_EVAL_BOARD`` and ``CARRIER`` empty), then configure each deployment using the runtime script.

Discovering Available Hardware Combinations
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Before reconfiguring your hardware setup, you need to know what combinations are supported by your Kuiper image. The configuration script includes a discovery feature that shows all available options.

To see what hardware combinations your image supports:

.. shell::

   $sudo configure-setup.sh --help
    Usage:
      sudo configure-setup.sh [OPTIONS] [ARGUMENTS]

    Description:
      Script that prepares Kuiper image to boot on a carrier board.

    Arguments:
      eval-board	Name of the project
      carrier	Carrier board name

    Options:
      -h, --help	Show this help message

    Example:
      sudo configure-setup.sh ad4003 zed


    Available projects in your Kuiper image:

    ADI Eval Board    Carrier
    ad9361-fmcomms2   zedboard
    ad9361-fmcomms2   zc706
    ad4003            zed
    adrv9009-zu11eg   adrv9009-zu11eg-revb

This output shows all the evaluation board and carrier combinations that your specific Kuiper image can support.

Reconfiguring Your Hardware Setup
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Once you've identified the hardware combination you want to use, reconfiguration requires root access to your Kuiper system (the ``analog`` user has sudo privileges) and that your system is running from an SD card or storage device.

Follow these steps:

#. **Log into your Kuiper system** via console, SSH, or VNC

#. **Check available configurations** (if you haven't already):

   .. shell::

      $sudo configure-setup.sh --help

#. **Run the configuration command** with your desired hardware combination:

   .. shell::

      $sudo configure-setup.sh <eval-board> <carrier>

   For example, to configure for the AD9361-FMCOMMS2 evaluation board on a ZedBoard carrier:

   .. shell::

      $sudo configure-setup.sh ad9361-fmcomms2 zedboard
       Successfully prepared boot partition for running project ad9361-fmcomms2 on zedboard.

#. **Reboot your system** for the changes to take effect:

   .. shell::

      $sudo reboot

After rebooting, your Kuiper system will be configured to work with the specified hardware combination.

What Happens During Reconfiguration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

When you run the configuration script, it performs several operations to prepare your system for the target hardware:

**File Operations**
   - Copies the appropriate kernel image to the boot partition
   - Copies device tree files and boot configuration files specific to your hardware
   - Updates boot loader configurations as needed

**Platform-Specific Setup**
   For Intel-based platforms, the script performs additional steps including updating the boot loader in the dedicated boot loader partition.

**Verification**
   The script provides feedback on the success or failure of each operation, allowing you to verify that the configuration completed properly.

----

Examples and Common Use Cases
-----------------------------

Switching Between Evaluation Boards
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If you're working with multiple ADI evaluation boards, you can easily switch between them:

.. shell::

   # Configure for AD4003 on ZED board
   $sudo configure-setup.sh ad4003 zed
   $sudo reboot

   # Later, switch to AD9361-FMCOMMS2 on ZC706
   $sudo configure-setup.sh ad9361-fmcomms2 zc706
   $sudo reboot

Development Workflow
~~~~~~~~~~~~~~~~~~~~

During development, you might want to test the same software stack across different hardware platforms:

.. shell::

   # Test on development board
   $sudo configure-setup.sh ad9361-fmcomms2 zedboard
   $sudo reboot
   # ... run your tests ...
   
   # Switch to production hardware
   $sudo configure-setup.sh ad9361-fmcomms2 zc706
   $sudo reboot
   # ... verify on production target ...

----

Next Steps
----------

For troubleshooting hardware configuration issues, see the :doc:`Troubleshooting <troubleshooting>` section.

To learn more about build-time configuration options, see the :doc:`Configuration <configuration>` section.
