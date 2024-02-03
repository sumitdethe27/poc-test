variable "Application_name" {
  description = "The name of the Cloud Run service to create"
  type        = string
  default = "focus-dev-application"
}

variable "Application_image" {
  description = "GCR hosted image URL to deploy"
  type        = string
  default = "nginx"
}

variable "Application_traffic_split" {
  type = list(object({
    latest_revision = bool
    percent         = number
    revision_name   = string
    tag             = string
  }))
  description = "Managing traffic routing to the service"
  default = [{ latest_revision = true ,percent = 100 ,revision_name = "v1-0-0", tag = null }]
}
variable "Application_labels" {
  type        = map(string)
  description = "A set of key/value label pairs to assign to the service"
  default = {"name":"patientservice"}
}
variable "Application_annotations" {
  type        = map(string)
  description = "Annotations to the service. Acceptable values all, internal, internal-and-cloud-load-balancing"
  default = { "run.googleapis.com/ingress" = "all" }
}
variable "Application_template_annotations" {
  type        = map(string)
  description = "Annotations to the container metadata including VPC Connector and SQL. See [more details](https://cloud.google.com/run/docs/reference/rpc/google.cloud.run.v1#revisiontemplate)"
  default = { "run.googleapis.com/client-name" = "terraform" ,"generated-by" = "terraform", "autoscaling.knative.dev/maxScale" = 2 ,"autoscaling.knative.dev/minScale" = 0, "run.googleapis.com/cpu-throttling" = false, "run.googleapis.com/execution-environment" = "gen1", "run.googleapis.com/vpc-access-connector" = "focus-ehr-vpc-connector", "run.googleapis.com/vpc-access-egress" = "all-traffic" }
}
# variable "encryption_key" {
#   description = "CMEK encryption key self-link expected in the format projects/PROJECT/locations/LOCATION/keyRings/KEY-RING/cryptoKeys/CRYPTO-KEY."
#   type        = string
#   default     = null
# }
variable "Application_container_concurrency" {
  type        = number
  description = "Concurrent request limits to the service"
  default = 10
  
}

# variable "limits" {
#   type        = map(string)
#   description = "Resource limits to the container"
#   default     = null
# }
# variable "requests" {
#   type        = map(string)
#   description = "Resource requests to the container"
#   default     = {}
# }

variable "Application_env_vars" {
     type = list(object({
    value = string
    name  = string
  }))
  default = [ ]
}

variable "Application_env_secret_vars" {
  type = list(object({
    name = string
    value_from = set(object({
      secret_key_ref = map(string)
    }))
  }))
  default= []
}

variable "Application_ports" {
  type = object({
    name = string
    port = number
  })
  description = "Port which the container listens to (http1 or h2c)"
  default = { name = "http1" , port = 80 }
}

variable "location" {
  type = string
  default= "us-central1"
}


variable "project_id" {
  type = string
  default= "theta-style-407015"
}