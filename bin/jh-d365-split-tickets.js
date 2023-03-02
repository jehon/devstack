#!/usr/bin/env node

import fs from 'fs';
import assert from 'node:assert/strict';

import XLSX from 'xlsx';
import yargs from 'yargs';

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

// const F_INPUT = path.join(os.homedir(), 'Downloads', 'd365.xlsx');
const F_INPUT = options.from;
const F_OUTPUT = F_INPUT.replace('.xlsx', '-splitted.xlsx')

const REGEX = /([A-Z]{3,10}|FM)-?[0-9]{2,4}/;

assert.match("CCFF-001", REGEX);
assert.match("FM-245", REGEX);
assert.match("FM-22", REGEX);
assert.match("ticket FM-22", REGEX);
assert.doesNotMatch("bonjour ceci est mon ticket", REGEX);

process.stdout.write(`Reading ${F_INPUT}\n`);
try {
    fs.statSync(F_INPUT);
} catch (e) {
    console.error(`File ${F_INPUT} }does not exists`);
}

// https://www.npmjs.com/package/xlsx

const workbook = XLSX.readFile(F_INPUT);

const initialData = XLSX.utils.sheet_to_json(workbook.Sheets.Sheet1)

const outputData = [];
for(let i = 0; i< initialData.length; i++) {
    const line = initialData[i];

    // Add other lines according to comments:
    const comment = line['Commentaire interne'] ?? line['Commentaire externe'];
    const tickets = [ ...(comment??"").matchAll(new RegExp(REGEX, 'g')) ].map(m => m[0]);
    if (tickets && tickets.length > 0) {
        console.log("Replacing ", comment, " => ", JSON.stringify(tickets));
        const n = tickets.length;
        // "Heures"
        for(let i = 0; i < n; i++ ) {
            outputData.push({
                ...line,
                Quantité: i == 0 ? line.Quantité : "",
                splitted: true,
                splitted_Heures: line.Quantité / n,
                splitted_Ticket: tickets[i]
            });
        }
    } else {
        outputData.push({
            ...line,
            splitted: false,
            splitted_Heures: line.Quantité,
            splitted_Ticket: 'no_ticket'
        });
    }
}

// console.log(outputData);

XLSX.utils.book_append_sheet(workbook, XLSX.utils.json_to_sheet(outputData), "splitted", true);
XLSX.writeFile(workbook, F_OUTPUT);

process.stdout.write(`Generated ${F_OUTPUT}`);