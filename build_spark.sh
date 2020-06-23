#!/bin/bash

export SPARK_VERSION=3.0.0
export HADOOP_VERSION=3.2
export DOCKER_IMAGE_TAG=spark-history
export DOCKER_REPO=mragesh

if [ ! -d "spark" ]
then
# download and extract spark
curl http://mirror.metrocast.net/apache/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION.tgz | tar xvz -C . 
# rename the directory
mv spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION spark
fi

cp Dockerfiles/* spark/kubernetes/dockerfiles/spark/.
cp jars/* spark/jars/.
cp conf/* spark/conf/.

#cd dependencies/spark
# copy custom dependencies and changes for pyspark
#cp -r --parents * ../../spark/

#cd ../..
# build docker image
./spark/bin/docker-image-tool.sh -u root -r $DOCKER_REPO -t $DOCKER_IMAGE_TAG build

# push docker image
./spark/bin/docker-image-tool.sh -r $DOCKER_REPO -t $DOCKER_IMAGE_TAG push
