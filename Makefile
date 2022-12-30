#
#
# Depends on: 
#     ansible/*
#
# Generate:
#     x
#

ansible: ansible-dump ansible-build ansible-lint

ANSIBLE_TMP=tmp/ansible

ANSIBLE_SOURCE=ansible
ANSIBLE_GALAXY=$(ANSIBLE_SOURCE)/.galaxy

dump: ansible-dump
clean: ansible-clean
build: ansible-build
lint: ansible-lint
release: ansible-release

.PHONY: ansible-dump
ansible-dump:
	$(call dump_space)
	$(call dump_title,ANSIBLE)
	$(call dump_info,ANSIBLE_SOURCE)
	$(call dump_info,ANSIBLE_GALAXY)
	$(call dump_version,ansible)
	$(call dump_version,ansible-lint)

.PHONY: ansible-clean
ansible-clean:
	rm -fr "$(ANSIBLE_GALAXY)"
	rm -fr repo/dev-config.json

.PHONY: ansible-build
ansible-build: $(ANSIBLE_TMP)/.built

$(ANSIBLE_TMP)/.built: \
		$(shell find ansible/ | grep -v .galaxy ) \
		$(ANSIBLE_GALAXY)/.done \
		ansible/tmp/00-all_vars.yml \
		ansible/tmp/50-hosts.yml \
		/etc/jehon/restricted/ansible-key

	@mkdir -p repo
	cd ansible && ansible-playbook build-artifacts.yml
	$(call touch,$@)

/etc/jehon/restricted/ansible-key:
	if [ ! -r $@ ]; then echo "123" > $@; fi
	$(call touch,$@)

$(ANSIBLE_GALAXY)/.done: ansible/requirements.yml
	mkdir -p $(ANSIBLE_GALAXY)
	( cd ansible && ansible-galaxy install --role-file requirements.yml --roles-path .galaxy/ )
	$(call touch,$@)

# We need this one in ansible/ to be included in the docker devcontainer
ansible/tmp/00-all_vars.yml: ansible/inventory/00-all_vars.yml build/ansible-no-secrets.js node_modules/.built
	$(call mkdir,$@)
	build/ansible-no-secrets.js "ansible/inventory/00-all_vars.yml" "$@"
	$(call touch,$@)

ansible/tmp/50-hosts.yml: ansible/inventory/50-hosts.yml build/ansible-no-secrets.js node_modules/.built
	$(call mkdir,$@)
	build/ansible-no-secrets.js "ansible/inventory/50-hosts.yml" "$@"
	$(call touch,$@)

.PHONY: ansible-lint
ansible-lint:
	cd $(ANSIBLE_SOURCE) && ansible-lint
	@echo "$@ ok"

ansible-release: ansible-build

#
# Node
#

node_modules/.built: package-lock.json package.json
	jh-npm-update-if-necessary "$@"
