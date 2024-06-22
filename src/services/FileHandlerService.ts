import { PlatformMulterFile } from "@tsed/common";
import {Injectable} from "@tsed/di";
import * as fs from 'fs';
import * as path from 'path';
@Injectable()
export class FileHandlerService {
    async uploadFile(file: PlatformMulterFile): Promise<string> {
        const originalExtension = path.extname(file.originalname)
        const uploadsDir = path.join( 'public', 'uploads','Qfiles');
        if (!fs.existsSync(uploadsDir)) {
            fs.mkdirSync(uploadsDir, { recursive: true });
        }
        const targetPath = path.join(uploadsDir, `${file.originalname}`);
        fs.writeFileSync(targetPath, file.buffer);
        return targetPath;
    }
}
