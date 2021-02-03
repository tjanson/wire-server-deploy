variable "subdomains" {
  type = list(string)
}

module "aws-dns-records" {
  count =  min(1, var.kubernetes_node_count)

  source = "../modules/aws-dns-records"

  environment = var.environment
  subdomains = var.subdomains
  # root_domain = var.root_domain
  zone_fqdn = var.root_domain
  ips = [ for node in local.kubernetes_nodes: node.ipaddress ]
  create_spf_record = true
}
