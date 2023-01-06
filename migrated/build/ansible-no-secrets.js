#!/usr/bin/env node

import fs from 'fs';
import YAML from 'yaml';
import process from 'process';

const filename = process.argv[2];
const destination = process.argv[3];
if (!destination) {
  console.error('source as [1], destination as [2]');
  process.exit(1);
}

function iterate(obj, key = '') {
  for (var property in obj) {
    switch(typeof(obj[property])) {
      case 'object':
        iterate(obj[property], `${key}.${property}`);
        break;
      case 'string':
        if (obj[property].startsWith('$ANSIBLE_VAULT')) {
          obj[property] = `vault${key}.${property}`;
        }
    }
  }
}

const file = fs.readFileSync(filename, 'utf8');
const obj = YAML.parse(file);
iterate(obj);

let yaml = '---\n\n';
yaml += YAML.stringify(obj);
fs.writeFileSync(destination, yaml);
