#!/bin/bash

NODE_ENV=production
#$1=${NODE_ENV}-savesimply
docker tag $1:latest $2:latest
docker tag $1:latest $2:${BUILD_NUMBER}

docker push $2:latest && /
docker push $2:${BUILD_NUMBER} && /
#if push successfull then 
docker rmi $2:latest $2:${BUILD_NUMBER}

# $2 = docker repo
#docker/repo=username/backup-prod

while [ "BUILD"="true" ]
do

    if [ ! "$(docker ps -a | grep $1)" ]; then
	echo "container does not exist"
	CONTAINER=false
    else
	echo "container exists"
	CONTAINER=true
    fi

    if [ ! "$(docker images | grep $1)" ]; then
        echo "image does not exist"
	    IMAGE=false
    else
        echo "image exists"
	    IMAGE=true
    fi

    if [[ $CONTAINER = "true" ]] && [[ $IMAGE = "true" ]]; then
        docker rm -f $1
        docker rmi $1
        BUILD=start

    elif [[ $CONTAINER = "false" ]] && [[ $IMAGE = "true" ]]; then
        docker rmi $1
        BUILD=start

    elif [[ $CONTAINER = "true" ]] && [[ $IMAGE = "false" ]]; then
        echo "image tag is removed and container is still running first remove untagged image manualy then run jenkins job again"

    elif [[ $CONTAINER = "false" ]] && [[ $IMAGE = "false" ]]; then
        BUILD=start
    fi

    if [ $BUILD = "start" ]; then 
	echo "container and image removed run build steps"
    docker pull $2:latest
    docker tag $2:latest $1:latest
    docker run -d -p 8081:8081 -v /home/ubuntu/logs:/root/.pm2/logs --name $1 $1
    else
	echo "container or image does not removed build steps are not going to run"
    fi
    BUILD=true
exit 1
done
