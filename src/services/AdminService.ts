import { PlatformMulterFile } from "@tsed/common";
import {Inject, Injectable} from "@tsed/di";
import { FileHandlerService } from "./FileHandlerService";
import { BadRequest } from "@tsed/exceptions";
import { exec } from "child_process";
import * as fs from 'fs';
import * as path from 'path';

@Injectable()
export class AdminService {
    constructor(@Inject(FileHandlerService)private fileHandler:FileHandlerService){}
    async addQFile(file?:PlatformMulterFile){
        if(!file){
            throw new BadRequest("FILE_NOT_PROVIDED");
        }
        const pdfFile= await this.fileHandler.uploadFile(file);
        return new Promise((resolve, reject) => {
            const originalExt = path.extname(file.originalname);  
            const basename = path.basename(file.originalname, originalExt);
            const command = `python PythonScripts/Convert.py ${pdfFile} public/Questions/${basename}.txt`;
            exec(command, (error, stdout, stderr) => {
              if (error) {
                console.error(`exec error: ${error}`);
                return reject(`Error: ${stderr}`);
              }
              console.log(`stdout: ${stdout}`);
              const secondCommand = `python ./PythonScripts/StoreFiles.py`;
                exec(secondCommand, (secondError, secondStdout, secondStderr) => {
                if (secondError) {
                    console.error(`Execution error: ${secondError}`);
                    return reject(`Error running second script: ${secondStderr}`);
                }
                console.log(`Second Script Output: ${secondStdout}`);
                resolve(secondStdout);
                });
                resolve("asd");
            });
          });

    }
}
