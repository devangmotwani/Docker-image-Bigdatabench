#!/bin/bash

echo 'export JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:jre/bin/java::")' >> ~/.bashrc
echo 'export PATH=$PATH:$JAVA_HOME' >> ~/.bashrc

echo 'export HADOOP_HOME=/usr/hadoop/hadoop-2.7.4' >> ~/.bashrc
echo 'export PATH=$PATH:$HADOOP_HOME/bin' >> ~/.bashrc
echo 'export PATH=$PATH:$HADOOP_HOME/sbin' >> ~/.bashrc
echo 'export HADOOP_MAPRED_HOME=$HADOOP_HOME' >> ~/.bashrc
echo 'export HADOOP_COMMON_HOME=$HADOOP_HOME' >> ~/.bashrc
echo 'export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop' >> ~/.bashrc
echo 'export HADOOP_HDFS_HOME=$HADOOP_HOME' >> ~/.bashrc
echo 'export YARN_HOME=$HADOOP_HOME' >> /.bashrc
echo 'export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native' >> ~/.bashrc
echo 'export HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib"' >> ~/.bashrc

#export SPARK_HOME=/home/hosein/project/spark-1.6.0-bin-hadoop2.6
echo 'export SPARK_HOME=/home/wh/spark' >> ~/.bashrc
echo 'export PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin' >> ~/.bashrc
echo 'export SPARK_MASTER_HOST=127.0.0.1' >> ~/.bashrc
echo 'export SBT_HOME=/usr/bin/sbt' >> ~/.bashrc
echo 'export PATH=$PATH:$SBT_HOME/bin' >> ~/.bashrc
echo 'export FLINK_HOME=/home/hosein/Flink/flink-0.10.0' >> ~/.bashrc 
echo 'export JAR_FILE_FLINK=/home/hosein/Flink/BigDataBench_V3.2_Flink/JAR_FILE/bigdatabench-flink-0.10.0.jar' >> ~/.bashrc
echo 'export JAR_GRAPH_FLINK=/home/hosein/Flink/BigDataBench-Graph/Flink-Gelly/graph-flink.jar' >> ~/.bashrc
echo 'export JAR_FILE_SPARK=/home/hosein/Flink/BigDataBench_V3.2.5_Spark/JAR_FILE/bigdatabench-spark_1.3.0-hadoop_1.0.4.jar' >> ~/.bashrc
echo 'export JAR_GRAPH_SPARK=/home/hosein/Flink/BigDataBench-Graph/Spark-Graphx/graph-spark.jar' >> ~/.bashrc
echo 'export PATH=$PATH:$FLINK_HOME/bin' >> ~/.bashrc

##Putting together libraries for BigDataBench
bash /home/hosein/Flink/BigDataBench_V3.2.1_Hadoop_Hive/prepar.sh
bash /home/hosein/Flink/BigDataBench_V3.2.5_Spark/prepar.sh

##C++ library path error solved
echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib' >> ~/.bashrc

## Allow root login to the docker through ssh
sed -n 's/prohibit-password/yes/' /etc/ssh/sshd_config && \
service ssh start

source ~/.bashrc

#export MAHOUT_HOME=/home/hosein/Flink/BigDataBench_V3.2.1_Hadoop_Hive/E-commerce/mahout-distribution-0.6/bin
ssh -o StrictHostKeyChecking=no localhost exit #&& \
ssh -o StrictHostKeyChecking=no 0.0.0.0 exit #&& \
ssh -o StrictHostKeyChecking=no 127.0.0.1 exit

##Start hadoop daemons
$HADOOP_HOME/sbin/start-all.sh

## Remove Hadoop from safemode
$HADOOP_HOME/bin/hadoop dfsadmin -safemode leave

/bin/bash
