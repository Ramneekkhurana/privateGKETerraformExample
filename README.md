# privateGKETerraformExample

Steps to Deploy GKE in Private mode 

Note - Disabling organization policies may have security repercussions, please validate with your orgnization Admin about if it's allowed.

1 - Ensure OSLogin Organization Policy is disabled ( GKE currently doesn't support it ).

2 - Ensure VPCPerring is allowed as GKE uses that to allow controlplane to talk to your worker nodes.

3 - This terraform will deploy a new VPC and subnets, if not needed you can remove vpc.tf and update variables according to your needs.



terraform init

terraform plan

terraform apply 



