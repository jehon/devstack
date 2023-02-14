#!/usr/bin/env node

import { promises as fs } from 'fs';

import yargs from 'yargs';
import XLSX from 'xlsx';
import { parse as csvParse } from 'csv-parse/sync';

const options = await yargs(process.argv.slice(2))
    .usage('$0 <from>')
    .command('$0 <from>', 'split file', yargs => {
        yargs
            .positional('from', {
                type: 'string',
                demandOption: "true"
                })
    })
    .argv

const F_INPUT = options.from;
const F_OUTPUT = F_INPUT.replace('.csv', '-excel.xlsx')

// https://csv.js.org/parse/distributions/nodejs_esm/
const content = await fs.readFile(F_INPUT, {
    encoding: "utf-8"
});
const records = await csvParse(content, {
    delimiter: ';'
});

// console.log(records);

// https://www.npmjs.com/package/xlsx
const workbook = XLSX.utils.book_new();
const ws = XLSX.utils.aoa_to_sheet(records);
XLSX.utils.book_append_sheet(workbook, ws, "jira", true);

XLSX.writeFile(workbook, F_OUTPUT);

process.stdout.write(`Generated ${F_OUTPUT}`);
