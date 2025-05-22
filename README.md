
# HBase Integration with Hadoop HA Cluster

## Project Overview

This project involves the integration of an HBase cluster into an existing Hadoop High Availability (HA) cluster environment. The setup is designed to ensure high availability, fault tolerance, and secure communication between components. The HBase cluster leverages the Hadoop HA cluster's HDFS storage layer to provide a scalable and reliable NoSQL database solution.

---

## Cluster Configuration

- **Master Nodes:**  
  - 2 HMaster nodes configured in Active/Standby mode for high availability.

- **RegionServers:**  
  - 2 to 3 RegionServers responsible for serving HBase regions and handling client requests.

- **ZooKeeper Quorum:**  
  - 3 ZooKeeper servers managing coordination and leader election within the cluster.

- **Hadoop HA Cluster:**  
  - Fully operational with active/standby NameNodes and proper failover setup.

---

## Integration Requirements

1. **Integration of HBase with Hadoop HA:**  
   - Configured HBase to connect with the existing Hadoop HA cluster ensuring seamless interaction with HDFS and NameNode failover support.

2. **Networking Configuration:**  
   - Established proper network connectivity among HBase Master nodes, RegionServers, ZooKeeper quorum, and Hadoop cluster nodes.
   - Ensured all required ports are opened and accessible for inter-component communication.

3. **HDFS Access:**  
   - Verified HBase’s ability to read/write data on the HDFS storage layer managed by the Hadoop HA cluster.
   - Configured HBase site to use HA-enabled HDFS URIs.

4. **Security and Authentication:**  
   - Implemented appropriate security settings to protect cluster components.
   - Configured authentication mechanisms (e.g., Kerberos or simple authentication) as per environment requirements.

---

## Components Details

| Component        | Description                                         | Configuration Notes                    |
|------------------|-----------------------------------------------------|-------------------------------------|
| HMaster Nodes    | Active and Standby masters for failover             | Configured with Zookeeper coordination |
| RegionServers    | Data nodes for HBase serving client requests        | Distributed across cluster nodes     |
| ZooKeeper        | Coordination service for HBase and Hadoop HA        | 3 quorum servers for high availability |
| Hadoop HA Cluster | Underlying HDFS storage with NameNode failover      | Configured with HA and failover enabled |

---

## Setup and Configuration Steps

1. **Hadoop HA Setup:**  
   - Ensure Hadoop NameNodes are configured for Active/Standby.
   - ZooKeeper quorum is set up for failover coordination.

2. **HBase Installation and Configuration:**  
   - Install HBase on cluster nodes.
   - Configure `hbase-site.xml` to point to HA-enabled HDFS paths and ZooKeeper quorum.

3. **Network Configuration:**  
   - Open required ports (e.g., 2181 for ZooKeeper, 16000 for HMaster, 16020 for RegionServer).
   - Validate connectivity between nodes.

4. **Security Configuration:**  
   - Enable Kerberos authentication if required.
   - Configure HBase and Hadoop to use the same security realm and principals.

5. **Testing:**  
   - Start the HBase services.
   - Verify HBase can read/write to HDFS.
   - Check failover by simulating active/standby switch of masters.

---

## Validation and Testing

- Confirmed HBase master failover works correctly using ZooKeeper coordination.
- Verified RegionServers register successfully with active HMaster.
- Tested HBase access to HDFS during NameNode failover scenarios.
- Ensured all security authentication mechanisms are effective and logs show successful authentications.

---

## References

- [Apache Hadoop Official Documentation](https://hadoop.apache.org/docs/)
- [Apache HBase Official Documentation](https://hbase.apache.org/book.html)
- [ZooKeeper Coordination Service](https://zookeeper.apache.org/)


