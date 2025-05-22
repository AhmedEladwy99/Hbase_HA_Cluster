FROM ubuntu:22.04 AS hadoop

# Install all required packages including Python3 and pip in one RUN
RUN apt update -y && \
    apt upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt install -y \
    net-tools \
    netcat \
    ssh \
    sshpass \
    openjdk-8-jdk \
    sudo \
    vim \
    wget \
    tar \
    python3 \
    python3-pip && \
    # Install Faker and happybase Python packages globally
    pip3 install Faker happybase && \
    # Download and extract Hadoop
    wget https://dlcdn.apache.org/hadoop/common/hadoop-3.3.6/hadoop-3.3.6.tar.gz && \
    tar -xzf hadoop-3.3.6.tar.gz -C /opt && \
    rm hadoop-3.3.6.tar.gz && \
    # Download and extract Zookeeper
    mkdir -p /opt/zookeeper && \
    wget https://dlcdn.apache.org/zookeeper/zookeeper-3.8.4/apache-zookeeper-3.8.4-bin.tar.gz && \
    tar -xzf apache-zookeeper-3.8.4-bin.tar.gz -C /opt/zookeeper && \
    mv /opt/zookeeper/apache-zookeeper-3.8.4-bin /opt/zookeeper/zookeeper && \
    rm apache-zookeeper-3.8.4-bin.tar.gz && \
    # Create hadoop user
    adduser --disabled-password --gecos "" hadoop && \
    echo "hadoop:123" | chpasswd && \
    usermod -aG sudo hadoop && \
    echo "hadoop ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/hadoop

USER hadoop
WORKDIR /home/hadoop

# SSH setup and directory preparation
RUN mkdir -p ~/.ssh && \
    ssh-keygen -t rsa -N '' -f ~/.ssh/id_rsa && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
    chmod 700 ~/.ssh && chmod 600 ~/.ssh/authorized_keys && \
    sudo mkdir -p /opt/hadoop/name /opt/hadoop/journal /opt/hadoop/data && \
    sudo mkdir -p /opt/zookeeper/data /opt/zookeeper/log && \
    sudo chown -R hadoop:hadoop /opt/hadoop /opt/zookeeper /opt/hadoop-3.3.6

# Copy configuration files and bootstrap script
COPY --chown=hadoop:hadoop --chmod=755 ./data/configs/hadoop/* /opt/hadoop-3.3.6/etc/hadoop/
COPY --chown=hadoop:hadoop --chmod=755 ./data/configs/zoo.cfg /opt/zookeeper/zookeeper/conf/
COPY --chown=hadoop:hadoop --chmod=755 ./code/hadoop_script.sh /home/hadoop/code/

# Environment setup
ENV JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64 \
    HADOOP_HOME=/opt/hadoop-3.3.6 \
    HADOOP_CONF_DIR=/opt/hadoop-3.3.6/etc/hadoop \
    ZOOKEEPER_HOME=/opt/zookeeper/zookeeper \
    PATH=$PATH:/opt/hadoop-3.3.6/bin:/opt/hadoop-3.3.6/sbin:/opt/zookeeper/zookeeper/bin

RUN sudo mkdir -p /run/sshd && sudo chmod 755 /run/sshd

ENV HBASE_HOME=/opt/hbase
ENV HBASE_VERSION=2.5.11

USER root
# Download and extract HBase
RUN mkdir -p $HBASE_HOME && \
    wget https://dlcdn.apache.org/hbase/${HBASE_VERSION}/hbase-${HBASE_VERSION}-bin.tar.gz -O /tmp/hbase.tar.gz && \
    tar -xzf /tmp/hbase.tar.gz -C /opt/hbase --strip-components=1 && \
    rm /tmp/hbase.tar.gz && \
    chown -R hadoop:hadoop $HBASE_HOME

COPY --chown=hadoop:hadoop /data/hbase/conf/hbase-site.xml /opt/hbase/conf/hbase-site.xml 

USER hadoop

ENTRYPOINT ["/bin/bash", "-c", "service ssh start && /home/hadoop/code/hadoop_script.sh"]
