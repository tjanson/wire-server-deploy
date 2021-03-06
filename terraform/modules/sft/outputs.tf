# TODO: It is absurd that srv-announcer requires this. All route53 resources are
# scoped globally, figure out if we really need to do this.
data "aws_region" "current" {}

output "sft" {
  value = {
    sft_srv = "_sft._tcp.${var.environment}"
    aws_key_id = aws_iam_access_key.srv-announcer.id
    aws_access_key = aws_iam_access_key.srv-announcer.secret
    aws_region = data.aws_region.current.name
    instances_blue = [ for server_name, _ in var.server_groups.blue.server_names :
      {
        hostname = hcloud_server.sft[server_name].name
        ipaddress = hcloud_server.sft[server_name].ipv4_address
        fqdn = aws_route53_record.sft_a[server_name].fqdn
      }
    ]
    instances_green = [ for server_name, _ in var.server_groups.green.server_names :
      {
        hostname = hcloud_server.sft[server_name].name
        ipaddress = hcloud_server.sft[server_name].ipv4_address
        fqdn = aws_route53_record.sft_a[server_name].fqdn
      }
    ]
  }
}
