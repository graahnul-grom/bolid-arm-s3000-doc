#!/bin/sh

# docker load -i arm-s3000-astra-smolensk_1.7-1.01.654.182.tar.xz
# docker volume create arm-s3000-volume

# docker stop arm-s3000
# docker rm arm-s3000



# testing:
#
docker run \
    --restart=always \
    --publish 20080:80 \
    --publish 20043:443 \
    --publish 20497:64497/udp \
    --volume arm-s3000-volume:/persist \
    --name "arm-s3000" \
    arm-s3000-astra-smolensk_1.7:1.01.654.182



# from doc's example:
#
# sudo docker run                        \
#     --name arm-s3000                   \
#     --volume arm-s3000-volume:/persist \
#     --restart=always                   \
#     --publish 20080:80                 \
#     --publish 20043:443                \
#     arm-s3000-astra-smolensk_1.7:VERSION



# --device=/dev/bus/usb/001/002
# --device=/dev/ttyUSB0
    # lsusb -v
    # dmesg | grep tty
    # cat /proc/tty/drivers



# docker container ls
# docker image ls
# docker volume ls
# docker volume inspect arm-s3000
# docker logs arm-s3000
# docker stats
# docker inspect arm-s3000
# docker inspect --format "{{ .NetworkSettings.IPAddress }}" arm-s3000
# docker exec -i -t arm-s3000 /bin/bash



# http://127.0.0.1:20080/
# login: admin
# pw: armS3000
