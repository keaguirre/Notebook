# Kubernetes

## Basic concepts
![Alt text](https://lh7-us.googleusercontent.com/docsz/AD_4nXfynlt7t0NifjCHKO7769qp4u9mdXRRaQ15lbwy7fOVkbga9-LHizfkhwKO069_e1a9KmB_FQMo5SKk5Hprs76SkHF3mCIcEQbPf4oVqbVVMYfpWUtJ4udP8LZ8Cjwdl1MsvxDkzGh5mCtpGGb1D3yNWIw?key=2w5PVqIs1gWd_EUlSJM-EQ)

![Reference](https://www.hunters.security/en/blog/kubernetes-security-guide)
- Cluster - A set of control plane and worker nodes.
- Nodes:
    - Worker Nodes: A physical or virtual machine that hosts one or more pods. Nodes are often referred to as worker nodes. , while the control plane components (e.g. kube-apiserver, etcd, kube-scheduler) are typically hosted on the same dedicated machine.
    - Control Plane: The layer that manages the worker nodes and the pods in the cluster. It includes important cluster components such as: kube-apiserver, etcd, kube-scheduler. A set of those components is typically hosted on the same dedicated machine.  The host running this set of components was historically called the master node. 
- Pod - A wrapper (an abstraction layer) over a container. Enables users to use Kubernetes without worrying about the kind of container (i.e. agnostic to container kind).
One benefit of using pods is that we only interact with the Kubernetes layer and not the container’s layer.
Usually, a pod contains 1 container, but that doesn’t have to be the case. Network-wise, a pod gets an internal IP address (and not the container).
The last important aspect we should mention about pods is that they are ephemeral. That means they are designed to be relatively short-lived, easily started, stopped, or restarted to adapt to changes in workload or to recover from faults.
