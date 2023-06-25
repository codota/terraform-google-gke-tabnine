# terraform-google-gke-tabnine

This module creates a reslient and fault tolerant Tabnine installation using Google
Kubernetes Engine (GKE) as the computing environment.

For further information - please refer to https://docs.tabnine.com/enterprise/

This module contains two submodules:
- [cluster](modules/cluster) - for creating a GKE cluster 
- [install](modules/install) - for installing Tabnine on top of an existing GKE cluster

And two examples:
- [cluster](examples/cluster) - an example of using the `cluster` module
- [complete](examples/complete) - an example of using the `install` module on top of the `cluster` module

<!-- BEGIN_TF_DOCS -->
## Inputs

No inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->