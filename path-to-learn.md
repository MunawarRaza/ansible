## Phase 1: Master the Core (1 Week)
Understand these topics thoroughly before moving on.

### 1. Inventory

Learn:

- Static inventory
- INI format
- YAML inventory
- Groups
- Nested groups
- host_vars
- group_vars

Example:
```
[web]
10.10.10.10

[db]
10.10.10.20

[dev:children]
web
db
```

### 2. Playbooks

Understand:

- hosts:
- become:
- gather_facts:
- vars:
- tasks:
- handlers:
- roles:
- import_tasks
- include_tasks

### 3. Variables
This is one of the most important topics.

<b>Learn:</b>

- defaults
- vars
- host_vars
- group_vars
- extra vars
- facts
- register
- set_fact

Also understand variable precedence. It explains why one value overrides another.

### 4. Conditionals

Master:
```
when:
```

Examples:
```
when: ansible_os_family == "Debian"
when: docker_installed
when: install_required
```

5. Loops
```
loop:
```

Example:

- packages:
  - vim
  - nano
  - curl

Install all packages.


## Phase 2: Learn Modules (2 Weeks)

Don't try to memorize every module. Learn the ones you'll use daily.

These should become second nature:
```
apt
dnf
yum
package
service
systemd
copy
template
file
user
group
stat
command
shell
unarchive
archive
get_url
uri
lineinfile
replace
blockinfile
find
fetch
wait_for
reboot
service_facts
setup
debug
fail
assert
set_fact
```

These cover the majority of infrastructure automation tasks.

## Phase 3: Roles (Most Important)

This is where you're already heading.

Understand the purpose of every directory:

```
roles/
    docker/
        defaults/
        files/
        handlers/
        meta/
        tasks/
        templates/
        vars/
```
Know why each exists.

## Phase 4: Templates

Master Jinja2.

For example

Instead of
```
ExecStart=/usr/local/bin/node_exporter
```
write
```
ExecStart={{ node_exporter_binary }}
```

Later you'll use:

```
if
for
filters
default()
regex_replace()
join()
split()
```

## Phase 5: Error Handling

Learn:
```
block:
rescue:
always:

```

Example

```
block:

- Install Docker

rescue:

- Remove temporary files

always:

- Print summary
```

## Phase 6: Build Real Roles

This is where you'll gain practical experience.

I would build these roles, one by one:

```
docker
docker_compose
node_exporter
promtail
loki
cadvisor
nginx
jenkins_agent
gitlab_runner
trivy
java
maven
python
redis
mysql
postgres
mongodb
```

## Phase 7: Best Practices

Always follow these guidelines:

✔ Don't use `shell` if an Ansible module exists.

✔ Use `package` instead of `apt/dnf` when possible for cross-platform compatibility.

✔ Prefer `template` over `copy` for configurable files.

✔ Use `notify` and `handlers` for service restarts.

✔ Store versions in `defaults/main.yml`.

✔ Keep tasks small and focused.

✔ Keep playbooks short; put logic into roles.

✔ Avoid hardcoded values.

## Recommended Resources

### 1. Official Documentation (Must Read)
The Ansible documentation is the definitive reference. Read it alongside your hands-on work rather than trying to read it cover to cover.

Focus especially on:

- Getting Started
- Playbooks
- Variables
- Roles
- Modules (especially the ones listed above)

### 2. Jeff Geerling

Jeff Geerling is one of the most respected voices in the Ansible community.

His resources include:

- YouTube tutorials
- Open-source Ansible roles on GitHub
- The book Ansible for DevOps

His GitHub repositories are excellent examples of clean, production-ready role design.

### 3. Learn Linux TV

Excellent for understanding practical infrastructure automation rather than just syntax.

## Practice Project (I Think This Fits Your Work Perfectly)

Create a repository like this:

```
ansible/
│
├── playbooks/
│
├── roles/
│     docker/
│     docker_compose/
│     nginx/
│     node_exporter/
│     promtail/
│     loki/
│     java/
│     jenkins_agent/
│     sonar_scanner/
│     trivy/
│     mongodb/
│     mysql/
│     redis/
│
├── inventory/
│
└── group_vars/
```

## A 30-Day Plan
<b>Week 1:</b> Inventory, playbooks, variables, conditionals, loops. <br>
<b>Week 2:</b> Modules, handlers, templates, facts, error handling.<br>
<b>Week 3:</b> Build roles for Docker, Docker Compose, NGINX, and Node Exporter.<br>
<b>Week 4:</b> Build advanced roles for Jenkins Agent, Promtail, Trivy, MongoDB, and integrate everything into a reusable automation repository.<br>