os_user=ubuntu

default: apply

init:
	./tf init

apply: init
	echo yes | ./tf apply

destroy:
	echo "yes" | ./tf destroy -target=module.vault.helm_release.vault
	echo "yes" | ./tf destroy

refresh: destroy apply
	

controller-ip:
	@terraform output -raw controller_public_ip

tunnel-k8s:
	../rsc/scripts/util/tunnel.sh -u $(os_user) -h "$$(terraform output -raw controller_public_ip)" -i ~/.ssh/aws-key -l 6443 -r 6443

shell:
	ssh -i ~/.ssh/aws-key $(os_user)@"$$(terraform output -raw controller_public_ip)"