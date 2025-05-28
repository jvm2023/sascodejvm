# azurecni overlay is used  wherein pod ip address is assigned from private ip space not from aks subnet 
# new vnet and two subnets creation  
# one rg already existing which have storage account for storing state file 
# 172.25.132.0/22 vnet 
# posgress db creation???
# vnet new creation 
# 6 node pools as per the LLD including one default system
# container registry is getting attached
# terraform_object has been assigned owner role to fix authorization error for acr pull role for aks
# need to check backend pool for the default lb created with aks 
# standard layer 4 LB is created along with aks.
# azure netapp files needs dedicated subnet 
# NetApp account
# Capacity pool   which can be hot expanded if needed 
# Volume (inside a VNet subnet)
# You use NFS (since this volume supports NFSv4.1)

# The NetApp volume is mounted as a PersistentVolume (PV) in Kubernetes.

# Your pods then mount that PV via a PersistentVolumeClaim (PVC).
# Option 1: Subnet already exists, delegation missing
# Manually add the delegation via the Azure Portal:
# Go to your VNet > Subnets > anf_subnet
# Click “Delegate subnet”
# Choose Microsoft.NetApp/volumes
# allowed_clients = ["0.0.0.0/0"] – open to all clients  t be checked in netapp volume block
# tfstate storage account is exsisting  as well as the container to store tfstate 
# terraform show -json tescoresources.plan | jq -r '.resource_changes[].name'
# naming conventions to be followed .....
# If you're running latency-sensitive workloads (like microservices that chat frequently), placing your node pools in a PPG can improve intra-node performance.

----------------------------------------------



aks_cluster_node_username = <sensitive>
aks_cluster_password = <sensitive>
aks_host = <sensitive>
aks_pod_cidr = "10.244.0.0/16"
cluster_api_mode = "public"
cluster_name = "tesas-aks"
cluster_node_pool_mode = "default"
jump_admin_username = "jumpuser"
jump_private_ip = "192.168.2.5"
jump_public_ip = "172.191.140.18"
jump_rwx_filestore_path = "/viya-share"
kube_config = <sensitive>
location = "eastus"
nat_ip = "135.234.146.202"
nfs_admin_username = "nfsuser"
nfs_private_ip = "192.168.2.4"
prefix = "tesas"
provider = "azure"
provider_account = "Tesco-Subscription"
rwx_filestore_endpoint = "192.168.2.4"
rwx_filestore_path = "/export"
