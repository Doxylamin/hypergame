# HyperGame (based on Easy-GPU-PV) 🚀

A project dedicated to making GPU Paravirtualization on Hyper-V super easy.
HyperGame allows you to partition your systems dedicated or integrated GPU and assign it to several Hyper-V VMs.
It's the same technology that is used in WSL2, and Windows Sandbox.

## Features

HyperGame aims to make this easier by automating most of the steps to get a GPU-P VM up and running.

1. Automatically creates a VM with a random hostname and password.
2. Automatically installs Windows to the VM
3. Partitions the Host GPU and copies the required drivers to the VM.
4. Installs various tools and services, such as:
    - [Parsec](https://parsec.app)
    - [VBCable](https://vb-audio.com)
    - [Ninite](https://ninite.com) with .NET 7, Chrome, Steam and 7-Zip


## Deployment

To deploy this project, clone the repository and allow execution of PowerShell Scripts with the following command:
```ps1
  Set-ExecutionPolicy Unrestricted
```

Download a compatible Windows ISO (x64, Win10/11) and put it into the `./iso` folder. Rename it to WindowsInstall.iso for easier usage.

Now run PowerShell ISE (x64!) as Administrator, open 0_PreChecks.ps1 and run it using the green Play Button in the IDE.
This will check if a GPU Virtual Machine can be created on your hostsystem.

If all checks run through, load 1_ConfigureNetwork.ps1 into the ISE and run it. This will create an internal network with NAT capabilities and assign it to 192.168.99.0/24

Open 2_CreateVM.ps1 into the PowerShell ISE  and edit the params section at the top of the file if required.
Running this script will create the VM Image and run your virtual machine.
If a `game-core.vhdx` exists at the specified VHD Location, it will be used to create a differencial disk.
Use this if you have preinstalled game data that you want to pass to the VM.
The VM hostname, user and password will be printed after completion.

### Upgrading GPU Drivers when you update the host GPU Drivers
It is important to update the VMs GPU Drivers if you updated the Hosts GPU Drivers.
1. Reboot the host after updating GPU Drivers.
2. Open PowerShell as Administrator and change directory (CD) to the path that CreateVM.ps1 and UpdateVMGpuPartitionDriver.ps1 are located. 
3. Run ```./4_UpdateVMGpuPartitionDriver.ps1 -VMName "VM-Name" -GPUName "AUTO"```
## FAQ

- After you have signed into Parsec on the VM, always use Parsec to connect to the VM.  Keep the Microsft Hyper-V Video adapter disabled. Using RDP and Hyper-V Enhanced Session mode will result in broken behaviour and black screens in Parsec.  RDP and the Hyper-V video adapter only offer a maximum of 30FPS. Using Parsec will allow you to use up to 4k60 FPS.
- If you get "ERROR  : Cannot bind argument to parameter 'Path' because it is null." this probably means you used Media Creation Tool to download the ISO.  You unfortunately cannot use that, if you don't see a direct ISO download link at the Microsoft page, follow [this guide.](https://www.nextofwindows.com/downloading-windows-10-iso-images-using-rufus)  
- Your GPU on the host will have a Microsoft driver in device manager, rather than an nvidia/intel/amd driver. As long as it doesn't have a yellow triangle over top of the device in device manager, it's working correctly.  
- A powered on display / HDMI dummy dongle must be plugged into the GPU to allow Parsec to capture the screen.  You only need one of these per host machine regardless of number of VM's.
- If your computer is super fast it may get to the login screen before the audio driver (VB Cable) and Parsec display driver are installed, but fear not! They should soon install.  
- The screen may go black for times up to 10 seconds in situations when UAC prompts appear, applications go in and out of fullscreen and when you switch between video codecs in Parsec - not really sure why this happens, it's unique to GPU-P machines and seems to recover faster at 1280x720.
- Vulkan renderer is unavailable and GL games may or may not work.  [This](https://www.microsoft.com/en-us/p/opencl-and-opengl-compatibility-pack/9nqpsl29bfff?SilentAuth=1&wa=wsignin1.0#activetab=pivot:overviewtab) may help with some OpenGL apps.  
- If you do not have administrator permissions on the machine it means you set the username and vmname to the same thing, these needs to be different.  
- AMD Polaris GPUS like the RX 580 do not support hardware video encoding via GPU Paravirtualization at this time.  
- To download Windows ISOs with Rufus, it must have "Check for updates" enabled.

## Acknowledgements

 - [jamesstringerparsec/Easy-GPU-PV](https://github.com/jamesstringerparsec/Easy-GPU-PV/)
    - [Hyper-ConvertImage](https://github.com/tabs-not-spaces/Hyper-ConvertImage) for creating an updated version of [Convert-WindowsImage](https://github.com/MicrosoftDocs/Virtualization-Documentation/tree/master/hyperv-tools/Convert-WindowsImage) that is compatible with Windows 10 and 11.
    - [gawainXX](https://github.com/gawainXX) for help testing and pointing out bugs and feature improvements.  


