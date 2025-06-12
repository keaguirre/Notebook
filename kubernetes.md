# Kubernetes
[Docs]([https://www.hunters.security/en/blog/kubernetes-security-guide](https://kubernetes.io/docs/concepts/overview/))

# Basic concepts
## Clúster
Un conjunto de nodos que ejecutan aplicaciones en contenedores. Un clúster de Kubernetes consta de un plano de control y uno o más nodos de trabajo.(todo el contenido de la imagen es la referencia a los elementos del clúster).

![Kubernetes-architecture](Assets/kubernetes/k8-architecture.jpg)

## Control Plane
Es el "cerebro" de Kubernetes. Administra y coordina todo el clúster.

### API Server
- Punto de entrada para todas las peticiones (UI, CLI, herramientas externas).
- Expone la API de Kubernetes y valida las peticiones.

### Scheduler
- Decide en qué nodo se colocarán los pods nuevos.
- Toma decisiones basadas en la disponibilidad de recursos, afinidad, etc.

### Controller Manager
- Ejecuta distintos controladores que regulan el estado del clúster (por ejemplo, replicar pods, reiniciar contenedores, etc.).

### etcd
- Base de datos distribuida que almacena todo el estado del clúster de Kubernetes.
- Altamente disponible y consistente.

## Worker Nodes (Nodos trabajadores)
Estos ejecutan las aplicaciones en contenedores. A physical or virtual machine that hosts one or more pods. Nodes are often referred to as worker nodes, while the control plane components (e.g. kube-apiserver, etcd, kube-scheduler) are typically hosted on the same dedicated machine as the control plane which is responsible for managing the worker nodes and the pods in the cluster that run on them orchestrated by the control plane on another dedicated machine.

- Cada nodo contiene:
    -   Pods: A wrapper (an abstraction layer) over a container. Enables users to use Kubernetes without worrying about the kind of container (i.e. agnostic to container kind). The last important aspect we should mention about pods is that they are ephemeral. That means they are designed to be relatively short-lived, easily started, stopped, or restarted to adapt to changes in workload or to recover from faults.
        -   Unidad mínima desplegable de Kubernetes.
        -   Un pod puede contener uno o más contenedores.
        -   Una o mas unidades de red y almacenamiento compartido.

    -   Runtime de contenedores
        -   Software que ejecuta los contenedores dentro de los pods. Ejemplos: Docker, Containerd, CRI-O.
        
    -   Containerd
        -   Motor de contenedores que ejecuta y gestiona los contenedores dentro de los pods.

    -   kubelet
        -   Agente que se ejecuta en cada nodo y comunica con el API Server.
        -   Se asegura de que los contenedores estén ejecutándose como deberían.

    -   Kube-proxy
        -   Maneja la red del nodo y la comunicación entre servicios.
        -   Implementa el balanceo de carga y reenvío de tráfico.

[Reference](https://www.hunters.security/en/blog/kubernetes-security-guide)
