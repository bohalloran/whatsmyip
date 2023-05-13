**TODO: clean up README later and add for readability**

**TODO: scale with K8S (maybe lambda, EC2/docker maybe too "heavy weight" on resources)**

* Assumes you already have a VPC, subnet and created a named profile in your $HOME/.aws with your AWS creds
* Update main.tf provider block with your named profile e.g. "bohalloran"
```
terraform init
terraform plan -out plan.out
terraform apply plan.out
```
* Plan will display in console the "external-ip" of AWS/EC2 instance endpoint 
* Once instance is up and running then in browser hit http://external-ip:8080
```
 curl http://external-ip:8080
```
* Returns the IP address of your client
* When done tear down EC2 instance
```
terraform destroy
```
