# Alibaba Cloud Redis Template

Terraform module which deploys KvStore Redis on Alibaba Cloud.

- [x] Support standalone(standard read-write instance) and replication(one read-write instance and multiple read-only instances, for read write splitting).

## Usage

```hcl
module "example" {
  source = "..."

  infrastructure = {
    vpc_id        = "..."
    domain_suffix = "..."
  }

  architecture   = "standalone"
  engine_version = "5.0"
}
```

## Examples

- [Replication](./examples/replication)
- [Standalone](./examples/standalone)

## Contributing

Please read our [contributing guide](./docs/CONTRIBUTING.md) if you're interested in contributing to Walrus template.

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
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.5.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [alicloud_kvstore_connection.default](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/kvstore_connection) | resource |
| [alicloud_kvstore_instance.default](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/kvstore_instance) | resource |
| [alicloud_pvtz_zone_record.default](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/pvtz_zone_record) | resource |
| [alicloud_vpc.default](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/vpc) | resource |
| [alicloud_vswitch.default](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/vswitch) | resource |
| [random_password.password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_string.name_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [alicloud_kvstore_instance_classes.selected](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/data-sources/kvstore_instance_classes) | data source |
| [alicloud_pvtz_zones.selected](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/data-sources/pvtz_zones) | data source |
| [alicloud_vpcs.selected](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/data-sources/vpcs) | data source |
| [alicloud_vswitches.selected](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/data-sources/vswitches) | data source |
| [alicloud_zones.selected](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/data-sources/zones) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_architecture"></a> [architecture](#input\_architecture) | Specify the deployment architecture, select from standalone or replication. | `string` | `"standalone"` | no |
| <a name="input_context"></a> [context](#input\_context) | Receive contextual information. When Walrus deploys, Walrus will inject specific contextual information into this field.<br><br>Examples:<pre>context:<br>  project:<br>    name: string<br>    id: string<br>  environment:<br>    name: string<br>    id: string<br>  resource:<br>    name: string<br>    id: string</pre> | `map(any)` | `{}` | no |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | Specify the deployment engine version. | `string` | `"5.0"` | no |
| <a name="input_infrastructure"></a> [infrastructure](#input\_infrastructure) | Specify the infrastructure information for deploying.<br><br>Examples:<pre>infrastructure:<br>  vpc_id: string, optional              # the ID of the VPC where the Redis service applies<br>  domain_suffix: string, optional       # a private DNS namespace of the PrivateZone where to register the applied Redis service<br>  publicly_accessible: bool, optional   # whether the Redis service is publicly accessible</pre> | <pre>object({<br>    vpc_id              = optional(string)<br>    domain_suffix       = optional(string)<br>    publicly_accessible = optional(bool, false)<br>  })</pre> | <pre>{<br>  "publicly_accessible": false<br>}</pre> | no |
| <a name="input_password"></a> [password](#input\_password) | Specify the account password. The password must be 16-32 characters long and start with any letter, number, or the following symbols: ! # $ % ^ & * ( ) \_ + - =.<br>If not specified, it will generate a random password. | `string` | `null` | no |
| <a name="input_replication_readonly_replicas"></a> [replication\_readonly\_replicas](#input\_replication\_readonly\_replicas) | Specify the number of read-only replicas under the replication deployment. | `number` | `1` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_address"></a> [address](#output\_address) | The address, a string only has host, might be a comma separated string or a single string. |
| <a name="output_address_readonly"></a> [address\_readonly](#output\_address\_readonly) | The readonly address, a string only has host, might be a comma separated string or a single string. |
| <a name="output_connection"></a> [connection](#output\_connection) | The connection, a string combined host and port, might be a comma separated string or a single string. |
| <a name="output_connection_readonly"></a> [connection\_readonly](#output\_connection\_readonly) | The readonly connection, a string combined host and port, might be a comma separated string or a single string. |
| <a name="output_context"></a> [context](#output\_context) | The input context, a map, which is used for orchestration. |
| <a name="output_password"></a> [password](#output\_password) | The password of the account to access the service. |
| <a name="output_port"></a> [port](#output\_port) | The port of the service. |
| <a name="output_refer"></a> [refer](#output\_refer) | The refer, a map, including hosts, ports and account, which is used for dependencies or collaborations. |
<!-- END_TF_DOCS -->

## License

Copyright (c) 2023 [Seal, Inc.](https://seal.io)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at [LICENSE](./LICENSE) file for details.

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
