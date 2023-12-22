# Dev Cluster 01
This slice of terraform code is responsible for setting up configuration and secrets that rely on infrastructure resulting from dev-cluster-00.
The reason that this code couldn't be merged into dev-cluster-02 is because it requires manually setup if it hasn't already been done.

This is where you define the "template" of secrets that are expected for the admin to enter in manually into vault before you can proceed and apply dev-cluster-02.

This is mainly useful if you are doing the foundation deployment for the first time, since thereafter, vault should have the secrets all saved in the right places and they should persist accross restarts. You shouldn't really need to run this more than once, ever for a live cluster. 
