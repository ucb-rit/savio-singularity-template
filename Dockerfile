FROM ubuntu:18.04

ENV LC_ALL "C"

RUN apt-get update \
    && apt-get install -y apt-utils g++ ssh openmpi-bin libopenmpi-dev wget tzdata

## if planning to use on Savio
RUN mkdir -p /global/home/users /global/scratch

## example application
RUN mkdir /app
WORKDIR /app
COPY quad_mpi.cpp quad_mpi.cpp
RUN  mpicxx quad_mpi.cpp -o quad_mpi

CMD ["/app/quad_mpi"] 



