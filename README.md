# savio-singularity-template
This repository provides example files and instructions for using Singularity containers on the UC Berkeley high-performance computing cluster, Savio.

## Building Singularity containers

To build a Singularity container, you generally need root access (i.e. administrative privileges) on a Linux machine on which you've installed Singularity. This might be your own machine or your group's server, or you might run a Linux virtual machine on Windows or MacOS, or you might run a Linux virtual machine on a cloud provider such as AWS or Google Cloud Platform. In addition, recent versions of Singularity (but not the version on Savio) allow you to build containers in the cloud through Sylabs cloud. 

In `build_examples.md` we show a variety of ways to build a Singularity container, either from a Dockerfile or from a Singularity definition file (including remote building through Sylabs cloud). In either case, it is standard to start from a Dockerhub base image and use the Dockerfile or Singularity def file to customize it for your needs. That might be a bare-bones base image such as `ubuntu:18.04` or an image with a commonly-used piece of software and its dependencies, such as `tensorflow/tensorflow:1.13.1-gpu-py3`

`example.def` is a bare-bones Singularity definition file suitable for using as a starting point for preparing your own definition file for a container to use on Savio.  `example-gpu.def` is an example for software that uses a GPU. `Dockerfile` is an example Dockerfile that shows how to install MPI within the container for applications you would run via MPI from outside the container.

## Accessing files in a Singularity container

If you build your own container following the approaches discussed above, you should find that your home directory, your scratch directory, and `/tmp` from Savio are all directly available inside the container.

See at bottom for how to access Savio directories if you pull a container directly from Dockerhub or SingularityHub/Singularity Container Library.

## Running Singularity containers on Savio

This follows from the standard ways to run a Singularity container via `singularity shell`, `singularity run`, `singularity exec`, etc.

As an example, if you have a container image file in your local directory, you can simply do:

```
singularity shell my_container.simg
```

For containers that use a GPU:

```
singularity shell --nv my_container.simg
```

For running a container via MPI:

```
module load intel openmpi
mpirun singularity run mpi.simg                 ## directly run the default container command

mpirun singularity exec mpi.simg /app/quad_mpi  ## alternative to invoke container command manually

```

We provide a few pre-built containers available via the Savio software module system.

If you run
```
module avail
```

you'll see `rstudio-singularity` and `tensorflow-singularity`. Running `module load <name-of-module>` will give instructions and information about the container of interest. 

## Running Singularity containers on Savio directly from Dockerhub

Finally, if you don't need to customize the container, you can run containers directly from Dockerhub and Singularity Hub (now the Singularity Container Library). If you do so, you need to invoke some additional flags to be able to access your Savio home and scratch directories. 

Here we'll first pull the image onto Savio for faster access in the future. Then we start the container, setting up our Savio home and scratch directories as directories available within the container (at `/home/USERNAME` and `/mnt`).

```
singularity pull --name ubuntu.simg docker://ubuntu:18.04  # 
singularity shell --home ~:/home/${USER} --bind /global/scratch/${USER}:/mnt ubuntu.simg
```

or directly shelling into the container:

```
singularity shell --home ~:/home/${USER} --bind /global/scratch/${USER}:/mnt docker://ubuntu:18.04
```

The following approach of accessing the Container Library will only work once a newer version of Singularity is installed on Savio.

```
singularity pull library://sylabsed/examples/lolcow
```

