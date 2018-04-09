## All of thes commnads basically run as different layers 
FROM ubuntu:16.04

##HADOOP location
RUN mkdir -p /usr/hadoop/hadoop-2.7.4/ \
&& cd /usr/hadoop/hadoop-2.7.4 

#Hadoop -> namenode and datanode
RUN mkdir -p /opt/hadoop-data/namenode \
&& cd /opt/hadoop-data \
&& mkdir datanode

##Install Java 8
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y  software-properties-common && \
    add-apt-repository ppa:webupd8team/java -y && \
    apt-get update && \
    apt-get install -y software-properties-common python-software-properties && \ 
    echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    apt-get install -y oracle-java8-installer && \
    apt-get clean

##Install gcc
#UN apt-get install -y gcc && \
#   apt-get install -y g++
RUN apt-get update && \
    apt-get install -y build-essential

##Install ssh
RUN apt-get install -y ssh && \
    apt-get install -y rsync

#Configure passwordless ssh
#RUN ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key && \
#RUN ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key && \
RUN ssh-keygen -q -N "" -t rsa -f /root/.ssh/id_rsa && \
    cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys

#Enable Root Login in sshd_config
RUN sed -n 's/prohibit-password/yes/' /etc/ssh/sshd_config && \
    service ssh start

#Permanently add localhost to known hosts and no checking for authentication
#RUN ssh -o StrictHostKeyChecking=no localhost exit
#RUN ssh -o StrictHostKeyChecking=no 0.0.0.0 exit
#RUN ssh -o StrictHostKeyChecking=no 127.0.0.1 exit

#Creating Spark files location
RUN mkdir -p /home/wh/

## Bigdatabench setting environment variables
RUN mkdir -p /home/hosein/Flink
WORKDIR /home/hosein/Flink
#RUN export JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:jre/bin/java::")
   # PATH=$PATH:$JAVA_HOME \
ENV HADOOP_HOME=/usr/hadoop/hadoop-2.7.4 \
   # PATH=$PATH:$HADOOP_HOME/bin \
   # PATH=$PATH:$HADOOP_HOME/sbin \
    HADOOP_MAPRED_HOME=/usr/hadoop/hadoop-2.7.4 \
    HADOOP_COMMON_HOME=/usr/hadoop/hadoop-2.7.4 \
    HADOOP_CONF_DIR=/usr/hadoop/hadoop-2.7.4/etc/hadoop \
    HADOOP_HDFS_HOME=/usr/hadoop/hadoop-2.7.4 \
    YARN_HOME=/usr/hadoop/hadoop-2.7.4 \
    HADOOP_COMMON_LIB_NATIVE_DIR=/usr/hadoop/hadoop-2.7.4/lib/native \
    HADOOP_OPTS="-Djava.library.path=/usr/hadoop/hadoop-2.7.4/lib" \
    SPARK_HOME=/home/wh/spark \
   # PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin
    SPARK_MASTER_HOST=127.0.0.1 \
    SBT_HOME=/usr/bin/sbt \
   # PATH=$PATH:$SBT_HOME/bin
    FLINK_HOME=/home/hosein/Flink/flink-0.10.0 \
    JAR_FILE_FLINK=/home/hosein/Flink/BigDataBench_V3.2_Flink/JAR_FILE/bigdatabench-flink-0.10.0.jar \
    JAR_GRAPH_FLINK=/home/hosein/Flink/BigDataBench-Graph/Flink-Gelly/graph-flink.jar \
    JAR_FILE_SPARK=/home/hosein/Flink/BigDataBench_V3.2.5_Spark/JAR_FILE/bigdatabench-spark_1.3.0-hadoop_1.0.4.jar \
    JAR_GRAPH_SPARK=/home/hosein/Flink/BigDataBench-Graph/Spark-Graphx/graph-spark.jar 
   # PATH=$PATH:$FLINK_HOME/bin

#Copying Hadoop, Spark, Flink and Bigdatabench experiment files
COPY . .

RUN mv hadoop-2.7.4 /usr/hadoop/ 
RUN mv spark /home/wh/
#ENV JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:jre/bin/java::")
EXPOSE 22 8081 8088 50070 8099 4040 
#22 : SSH
#8081 : Flink
#8088 : Hadoop job list
#50070 : Hadoop DFS
#8099 : Spark
#4040 : Spark Current job UI

##Format namenode
RUN /usr/hadoop/hadoop-2.7.4/bin/hadoop namenode -format

##Preparing BigDatabench files for experiments
#RUN /home/hosein/Flink/BigDataBench_V3.2.1_Hadoop_Hive/prepar.sh && \
#    /home/hosein/Flink/BigDataBench_V3.2.5_Spark/prepar.sh

##Install vim
RUN apt-get install -y vim

##Solving errors
#LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
#export LD_LIBRARY_PATH
#Library error other option
#Review your /etc/ld.so.conf. If /usr/local/lib is not listed there, add it. Now, run ldconfig to detect the shared object file and add it to some system-wide index.

CMD ["/bin/bash","startup.sh"]
