# google_client_config and kubernetes provider must be explicitly specified like the following.
data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

module "gke" {
  source                     = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
  name                       = "gke-test-1"
  project_id                 = var.project_id
  region                     = "us-central1"
  zones                      = ["us-central1-a", "us-central1-b", "us-central1-f"]
  network                    = "${var.project_id}-vpc-01"
  subnetwork                 = "${var.project_id}-${var.region}-01"
  ip_range_pods              = "${var.project_id}-${var.region}-01-sec-pods"
  ip_range_services          = "${var.project_id}-${var.region}-01-sec-services"
  http_load_balancing        = false
  horizontal_pod_autoscaling = true
  network_policy             = false
  enable_private_endpoint    = true
  enable_private_nodes       = true
  create_service_account     = true
  deploy_using_private_endpoint = true
  master_ipv4_cidr_block        = "172.16.0.0/28"
  master_authorized_networks    = [{cidr_block = "10.2.0.0/16", display_name = "vpc network"},{cidr_block = "192.168.0.0/17", display_name = "vpc pod network"},{cidr_block = "192.168.128.0/17", display_name = "vpc service network"}]
  remove_default_node_pool      = true

  node_pools = [
    {
      name                      = "default-node-pool"
      machine_type              = "e2-medium"
      node_locations            = "us-central1-b,us-central1-c"
      min_count                 = 1
      max_count                 = 6
      local_ssd_count           = 0
      disk_size_gb              = 100
      disk_type                 = "pd-standard"
      image_type                = "COS"
      auto_repair               = true
      auto_upgrade              = true
      preemptible               = false
      initial_node_count        = 1
      disable_legacy_metadata_endpoints = true
      enable_shielded_nodes             = true
      enable_secure_boot        = true
      enable_integrity_monitoring = true
    },
  ]

  node_pools_oauth_scopes = {
    all = []

    default-node-pool = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  node_pools_labels = {
    all = {}

    default-node-pool = {
      default-node-pool = true
    }
  }

  node_pools_metadata = {
    all = {}

    default-node-pool = {
      node-pool-metadata-custom-value = "my-node-pool"
    }
  }

  node_pools_taints = {
    all = []

    default-node-pool = [
      {
        key    = "default-node-pool"
        value  = true
        effect = "PREFER_NO_SCHEDULE"
      },
    ]
  }

  node_pools_tags = {
    all = []

    default-node-pool = [
      "default-node-pool",
    ]
  }
}