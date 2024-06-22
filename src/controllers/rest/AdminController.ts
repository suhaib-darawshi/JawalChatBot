import { MultipartFile, PlatformMulterFile } from "@tsed/common";
import {Controller, Inject} from "@tsed/di";
import {Get, Put} from "@tsed/schema";
import { AdminService } from "../../services/AdminService";

@Controller("/admin")
export class AdminController {
  constructor(@Inject(AdminService)private adminService:AdminService){}
  @Put("/file")
  async get(@MultipartFile("file")file:PlatformMulterFile) {
    return await this.adminService.addQFile(file);
    return "hello";
  }
}
