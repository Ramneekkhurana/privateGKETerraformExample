/**
 * Copyright 2019 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


provider "google" {
}

# [START vpc_custom_create]
resource "google_compute_network" "vpc_network" {
  project                 = var.project_id # Replace this with your project ID in quotes
  name                    = "${var.project_id}-vpc-01"
  auto_create_subnetworks = false
  mtu                     = 1460
}
# [END vpc_custom_create]

resource "google_compute_subnetwork" "network-with-private-secondary-ip-ranges" {
  project       = var.project_id # Replace this with your project ID in quotes
  name          = "${var.project_id}-${var.region}-01"
  ip_cidr_range = "10.2.0.0/16"
  region        = "us-central1"
  network       =  google_compute_network.vpc_network.name
  
  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }

  secondary_ip_range {
    range_name    = "${var.project_id}-${var.region}-01-sec-pods"
    ip_cidr_range = "192.168.0.0/17"
  }

  secondary_ip_range {
    range_name    = "${var.project_id}-${var.region}-01-sec-services"
    ip_cidr_range = "192.168.128.0/17"
  }

}
# [EN