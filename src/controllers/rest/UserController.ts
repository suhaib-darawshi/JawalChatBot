import {Controller, Inject} from "@tsed/di";
import { BodyParams } from "@tsed/platform-params";
import {Get, Post, Put} from "@tsed/schema";
import { UserModel } from "../../models/UserModel";
import { AuthService } from "../../services/AuthService";
import { Res } from "@tsed/common";
import * as path from 'path';
@Controller("/user")
export class UserController {
  constructor(@Inject(AuthService)private authService:AuthService){}
  @Get("/")
  get() {
    return "hello";
  }
  @Post("/signin")
  async signin(@BodyParams()user:UserModel){
    return await this.authService.login(user);
  }
  @Put("/signup")
  async signup(@BodyParams()user:UserModel){
    return await this.authService.createUser(user);
  }
  @Post('/download')
  async downloadFile(@Res() res: Res,@BodyParams("url")url:string) {
    const filePath = path.join( url);
    res.download(filePath);
  }
}
