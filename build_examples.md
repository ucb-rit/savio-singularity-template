There are multiple ways to create a Singularity container using on a Docker base container customized by the user. Here we show the use of a Dockerfile or a Singularity def file, where each of them builds upon a base Docker image.

# 1) Using a Singularity def file

## 1a) If you have root access on a computer

```
sudo singularity build example.simg example.def
```

## 1b) Building in the cloud

Alternatively (i.e., without any special privileges), if you're using a newer version of Singularity (the version on Savio does NOT support this), you may be able to build the container via Sylabs Cloud Remote Builder, like this:

```
singularity build --remote example.simg example.def
```

You'll need to create an account with Sylabs Cloud. More details are [here](https://www.sylabs.io/guides/3.2/user-guide/singularity_and_docker.html#building-containers-remotely).

# 2) Using a Dockerfile

## 2a) Using a local docker registry

```
docker build -f Dockerfile -t test:0.1

docker run -d -p 5000:5000 --name registry registry:2
docker tag test localhost:5000/test:0.1
docker push localhost:5000/test:0.1 # Push the container to your local registry
# from https://groups.google.com/a/lbl.gov/forum/#!topic/singularity/ZXOaNaM_6MY
sudo SINGULARITY_NOHTTPS=1 singularity build test.simg test_local_docker_registry.def
```

## 2b) Using Dockerhub 

```
docker build -f Dockerfile -t test:0.1 .

docker login --username=paciorek 
docker tag mpi paciorek/test:0.1
docker push paciorek/test

sudo singularity build test.simg docker://paciorek/test:0.1
```

## 2c) Using `docker2singularity`

```
docker build -f Dockerfile -t test:0.1 .

docker run -v /var/run/docker.sock:/var/run/docker.sock \
       -v /tmp:/output --privileged -t --rm \
       singularityware/docker2singularity \
       test
# /output is path in container where singularity container is built
# /output is mapped to /tmp on the host and this is where test.simg is created
```

## 2d) Using the Docker container directly from the docker daemon

```
docker build -f Dockerfile -t test:0.1 .

sudo singularity build test.simg docker-daemon://test:0.1
```

## 2e) Using the Docker container saved as an archive file

```
docker build -f Dockerfile -t test:0.1 .

docker save test -o test_0.1.tar
# sudo not needed
singularity -d build test.simg docker-archive://test_0.1.tar
```
