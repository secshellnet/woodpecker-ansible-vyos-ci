from sys import argv
import yaml

# get available hosts from hosts.yaml
with open("hosts.yml", "r") as f:
    content = yaml.load(f.read(), Loader=yaml.Loader)

all_hosts: list = list(content.get("all").get("hosts").keys())
changes = argv
# extract the sites from the hosts, for being able to compare them to the directory in tasks
sites = {f.split(".")[-3]: f for f in all_hosts}

hosts = set()

if "vyos.yml" in changes or "dynamic-network-groups.py" in changes:
    print(" ".join(all_hosts))
    exit(0)

# if changes in host_vars, check filename to determine which machine needs to be executed
# if changes in tasks/SITE: add SITE to list of executed things
# if changes in tasks: add all sites to list of executed things
for change in changes:
    for site in sites:
        if f"{site}/" in change:
            hosts.add(sites[site])
            break
    else:
        if "tasks" in change or "host_vars" in change:
            print(" ".join(all_hosts))
            exit(0)
print(" ".join(hosts))

