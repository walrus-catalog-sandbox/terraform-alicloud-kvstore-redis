# Replication Example

Deploy Redis service in standalone architecture by root module.

```bash
# setup infra
$ terraform apply -auto-approve \
  -target=alicloud_vpc.example \
  -target=alicloud_vswitch.example \
  -target=alicloud_pvtz_zone.example \
  -target=alicloud_pvtz_zone_attachment.example

# create service
$ terraform apply -auto-approve
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_alicloud"></a> [alicloud](#requirement\_alicloud) | >= 1.140.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.5.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_alicloud"></a> [alicloud](#provider\_alicloud) | >= 1.140.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_this"></a> [this](#module\_this) | ../.. | n/a |

## Resources

| Name | Type |
|------|------|
| [alicloud_pvtz_zone.example](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/pvtz_zone) | resource |
| [alicloud_pvtz_zone_attachment.example](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/pvtz_zone_attachment) | resource |
| [alicloud_vpc.example](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/vpc) | resource |
| [alicloud_vswitch.example](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/vswitch) | resource |
| [alicloud_zones.selected](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/data-sources/zones) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_address"></a> [address](#output\_address) | n/a |
| <a name="output_address_readonly"></a> [address\_readonly](#output\_address\_readonly) | n/a |
| <a name="output_connection"></a> [connection](#output\_connection) | n/a |
| <a name="output_connection_readonly"></a> [connection\_readonly](#output\_connection\_readonly) | n/a |
| <a name="output_context"></a> [context](#output\_context) | n/a |
| <a name="output_password"></a> [password](#output\_password) | n/a |
| <a name="output_port"></a> [port](#output\_port) | n/a |
| <a name="output_refer"></a> [refer](#output\_refer) | n/a |
<!-- END_TF_DOCS -->