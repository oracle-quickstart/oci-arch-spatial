# Oracle Cloud Spatial Platform on ADW

# [![Deploy to Oracle Cloud][magic_button]][magic_sgtech_stack]

This architecture uses Oracle Autonomous Data Warehouse where the location components of business data are managed with a native spatial data type to enable location-based insights. The architecture also includes Oracle Spatial Studio and Oracle Application Express (APEX) for low code spatial data preparation, analysis, visualization, and application development.

The repository contains the [Terraform][tf] code to create a [Resource Manager][orm] stack, that creates all the required resources and configures the application on the created resources.

## Prerequisites

- Permission to `manage` the following types of resources in your Oracle Cloud Infrastructure tenancy:  `autonomous-database-family`, `instance-family`, `virtual-network-family`, `dynamic-groups`, `policies`, `orm-family`.
- Permission to `use` the following types of resources in your Oracle Cloud Infrastructure tenancy: `secret-family`, `keys` and `tag-namespaces`. 
- [Secret][secret](s) to use for Spatial Studio's database and application admin passwords
- SSH key pair
- Quota to create the following resources: 1 [ADW][adb] database instance, 1 [Compute instance][inst], 1 [VCN][vcn] and its required network artifacts ([Subnet][net], [IGW][igw], [Route Table][rt] and [NSG][nsg]), 1 [Dynamic Group][groups] and 1 [Policy][policies].
If you don't have the required permissions and quota, contact your tenancy administrator. See [Policy Reference][policy], [Service Limits][limits], [Compartment Quotas][quota].

#### **Generating an SSH Key Pair on UNIX or UNIX-Like Systems Using ssh-keygen**

- Run the ssh-keygen command.

`ssh-keygen -b 2048 -t rsa`

- The command prompts you to enter the path to the file in which you want to save the key. A default path and file name are suggested in parentheses. For example: /home/user_name/.ssh/id_rsa. To accept the default path and file name, press Enter. Otherwise, enter the required path and file name, and then press Enter.
- The command prompts you for a passphrase. Enter a passphrase, or press ENTER if you don't want to havea passphrase.
  Note that the passphrase isn't displayed when you type it in. Remember the passphrase. If you forget the passphrase, you can't recover it. When prompted, enter the passphrase again to confirm it.
- The command generates an SSH key pair consisting of a public key and a private key, and saves them in the specified path. The file name of the public key is created automatically by appending .pub to the name of the private key file. For example, if the file name of the SSH private key is id_rsa, then the file name of the public key would be id_rsa.pub.
  Make a note of the path where you've saved the SSH key pair.
  When you create instances, you must provide the SSH public key. When you log in to an instance, you must specify the corresponding SSH private key and enter the passphrase when prompted.

## Components

| Component                 | Description               |
|---------------------------|---------------------------|
| Autonomous Data Warehouse | Platform for management and analysis of business/spatial data   |
| Compute Instance          | VM host for Spatial Studio |
| Virtual Cloud Network     | The virtual network used by the application   |
| Public Subnet             | The subnet that houses the compute instance. This subnet allows public IP addresses and are exposed to the internet through the InternetGateway  |
| Internet Gateway          | Enables the compute instance to be reachable from the internet  |
| Route Tables              | The public subnet route rules direct traffic to use the Internet Gateway |
| Network Security Group    | Contains the security rules to enable HTTPS and SSH traffic from anywhere to the compute instance |
| Dynamic Group             | A component group containing the instance |
| Identity Policy           | Statements to grant the Dynamic Group access to the Tenancy's Secrets decoding capabilities and the ability to download the ADW wallet |

# Deployment Instructions

## Deploy Using Oracle Resource Manager

1. Click [![Deploy to Oracle Cloud][magic_button]][magic_sgtech_stack]. 
  If you aren't already signed in, when prompted, enter the tenancy and user credentials.

2. Review and accept the terms and conditions.
3. Select the region where you want to deploy the stack.
4. Follow the on-screen prompts and instructions to create the stack.
5. After creating the stack, click **Terraform Actions**, and select **Plan**.
6. Wait for the job to be completed, and review the plan. To make any changes, return to the Stack Details page, click **Edit Stack**, and make the required changes. Then, run the **Plan** action again.
7. If no further changes are necessary, return to the Stack Details page, click **Terraform Actions**, and select **Apply**. 

## Local Development

1. Perform pre-deployment setup described [here][oci-prereqs].

2. Clone the Module with the following commands to make a local copy fo the repo:

    git clone https://github.com/oracle-quickstart/oci-arch-spatial.git
    cd oci-arch-spatial/
    ls

    Note, the instructions below are to build a `.zip` file from your local copy for use in ORM. If you do not want to use ORM and instead deploy with the terraform CLI, then you need to rename `provider.tf.cli -> provider.tf`. This is because authentication works slightly differently in ORM vs the CLI. This file is ignored by the build process below. Make sure you have terraform v1.0+ cli installed and accessible from your terminal.

3. In order to `build` the zip file with the latest changes you made to this code, you can simply go to `build-orm` folder and use terraform to generate a new zip file:

    On the first run you are required to initialize the terraform modules used by the template with  `terraform init` command:

    ```bash
    $ terraform init
    ```

4. Once terraform is initialized, run `terraform apply` to generate ORM zip file:
   
    ```bash
    $ terraform apply
    data.archive_file.generate_zip: Refreshing state...
    Apply complete! Resources: 0 added, 0 changed, 0 destroyed.
    ```

    This command will package the content of `terraform` folder into a zip and will store it in the `build-orm\dist` folder. You can check the content of the file by running `unzip -l dist/orm.zip`:

    ```bash
    $ unzip -l dist/orm.zip

    Archive:  orm.zip
      Length      Date    Time    Name
    ---------  ---------- -----   ----
        2651  01-01-2049 00:00   compute.tf
         866  01-01-2049 00:00   database.tf
         493  01-01-2049 00:00   datasources.tf
        1653  01-01-2049 00:00   image_subscription.tf
        2425  01-01-2049 00:00   locals.tf
        2272  01-01-2049 00:00   network.tf
        2032  01-01-2049 00:00   nsg.tf
         860  01-01-2049 00:00   oci_images.tf
        1860  01-01-2049 00:00   outputs.tf
        2222  01-01-2049 00:00   policies.tf
       15599  01-01-2049 00:00   schema.yaml
         405  01-01-2049 00:00   scripts/bootstrap.sh
        3961  01-01-2049 00:00   variables.tf
         178  01-01-2049 00:00   versions.tf
    ---------                     -------
       37477                     14 files
    ```

5. [Login](https://cloud.oracle.com/resourcemanager/stacks/create) to Oracle Cloud Infrastructure to import the stack
    > `Home > Developer Services > Resource Manager > Stacks > Create Stack`
6. Upload the `orm.zip` and provide a name and description for the stack
7. Configure the Stack. The UI will present the variables to the user dynamically, based on their selections. 
8. Click Next and Review the configuration.
9. Click Create button to confirm and create your ORM Stack.
10. On Stack Details page, you can now run `Terraform` commands to manage your infrastructure. You typically start with a plan then run apply to create and make changes to the infrastructure. More details below:
        
    |      TERRAFORM ACTIONS     |           DESCRIPTION                                                 |
    |----------------------------|-----------------------------------------------------------------------|
    |Plan                        | `terraform plan` is used to create an execution plan. This command is a convenient way to check the execution plan prior to make any changes to the infrastructure resources.|
    |Apply                       | `terraform apply` is used to apply the changes required to reach the desired state of the configuration described by the template.|
    |Destroy                     | `terraform destroy` is used to destroy the Terraform-managed infrastructure.|

## Additional Information

* For instructions on changing the default HTTPS port and creating additional users, see /u01/Oracle_Spatial_Studio/README.txt  

* To configure your HTTPS certificate, see [Loading keys and certificates in Jetty](https://www.eclipse.org/jetty/documentation/jetty-9/index.html#loading-keys-and-certificates). Note: this requires understanding of TSL/SSL certificate configuration

* The Server is registered as a Linux startup service using custom start/stop scripts and will be automatically started when the instance is booted. 

* Use the following system commands to gracefully start, stop or restart it.
    ```
    sudo systemctl start spatialstudio
    sudo systemctl stop spatialstudio
    sudo systemctl restart spatialstudio
    ```

## Contributing

This project welcomes contributions from the community. Before submitting a pull request, please [review our contribution guide](./CONTRIBUTING.md)

## Security

Please consult the [security guide](./SECURITY.md) for our responsible security vulnerability disclosure process

## License

Copyright (c) 2022 Oracle and/or its affiliates.
Released under the Universal Permissive License v1.0 as shown at
<https://oss.oracle.com/licenses/upl/>.

[magic_button]: https://oci-resourcemanager-plugin.plugins.oci.oraclecloud.com/latest/deploy-to-oracle-cloud.svg
[magic_sgtech_stack]: https://cloud.oracle.com/resourcemanager/stacks/create?zipUrl=https://github.com/oracle-quickstart/oci-arch-spatial/releases/latest/download/spatial-stack-latest.zip
[policy]: https://docs.cloud.oracle.com/en-us/iaas/Content/Identity/Reference/policyreference.htm
[policies]: https://docs.oracle.com/en-us/iaas/Content/Identity/Tasks/managingpolicies.htm
[limits]: https://docs.cloud.oracle.com/en-us/iaas/Content/General/Concepts/servicelimits.htm
[quota]: https://docs.cloud.oracle.com/iaas/Content/General/Concepts/resourcequotas.htm
[oci]: https://cloud.oracle.com/en_US/cloud-infrastructure
[orm]: https://docs.cloud.oracle.com/iaas/Content/ResourceManager/Concepts/resourcemanager.htm
[tf]: https://www.terraform.io
[net]: https://docs.cloud.oracle.com/iaas/Content/Network/Concepts/overview.htm
[vcn]: https://docs.cloud.oracle.com/iaas/Content/Network/Tasks/managingVCNs.htm
[lb]: https://docs.cloud.oracle.com/iaas/Content/Balance/Concepts/balanceoverview.htm
[igw]: https://docs.cloud.oracle.com/iaas/Content/Network/Tasks/managingIGs.htm
[natgw]: https://docs.cloud.oracle.com/iaas/Content/Network/Tasks/NATgateway.htm
[svcgw]: https://docs.cloud.oracle.com/iaas/Content/Network/Tasks/servicegateway.htm
[rt]: https://docs.cloud.oracle.com/iaas/Content/Network/Tasks/managingroutetables.htm
[seclist]: https://docs.cloud.oracle.com/iaas/Content/Network/Concepts/securitylists.htm
[adb]: https://docs.cloud.oracle.com/iaas/Content/Database/Concepts/adboverview.htm
[inst]: https://docs.cloud.oracle.com/iaas/Content/Compute/Concepts/computeoverview.htm
[kms]: https://docs.cloud.oracle.com/en-us/iaas/Content/KeyManagement/Concepts/keyoverview.htm
[nsg]: https://docs.oracle.com/en-us/iaas/Content/Network/Concepts/networksecuritygroups.htm
[secret]: https://docs.oracle.com/en-us/iaas/Content/KeyManagement/Tasks/managingsecrets.htm
[groups]: https://docs.oracle.com/en-us/iaas/Content/Identity/Tasks/managingdynamicgroups.htm
[oci-prereqs]: https://github.com/oracle/oci-quickstart-prerequisites
