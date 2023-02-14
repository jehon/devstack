#!/usr/bin/env node

import os from 'os';
import fs from 'fs';
import path from 'path';

import * as csv from 'csv';

// import * as csv from 'csv';

const F_INPUT = path.join(os.homedir(), 'Downloads', 'd365.csv');
const F_OUTPUT = F_INPUT.replace('.csv', '-splitted.csv')

process.stdout.write(`FILE: ${F_INPUT}\n`);
try {
    fs.statSync(F_INPUT);
} catch (e) {
    console.error("File does not exists");
}

fs.createReadStream(F_INPUT, {  /* encoding: 'latin1' */})
    .pipe(csv.parse({
        delimiter: ';',
        columns: true
    }))
    .pipe(csv.transform((obj, cb) => {
        // console.log(obj);
        cb(null, obj);
    }))
    .pipe(csv.stringify({
        header: true,
        bom: true,
        delimiter: ';',
        columns: {
            'Clé de ticket': 'id',
            'Résumé': 'title',
            'Création': 'created',
            'Mise à jour': 'updated',
            'Composants': 'components',
            'Etiquettes': 'tags'
        },
    }))
    .pipe(fs.createWriteStream(F_OUTPUT, { encoding: 'utf-8'}));

//     .pipe(csv2json({
//         delimiter: ';'
//     }))
//     .pipe(new Transform({
//         transform: (obj, encoding, cb) => {
//             cb(null, obj);
//         }
//     }))
//     .pipe(process.stdout);

