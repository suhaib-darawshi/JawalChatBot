import { BodyParams, MultipartFile, PathParams, PlatformMulterFile, Req, Use } from "@tsed/common";
import {Controller, Inject}from "@tsed/di"
import {Get,Post} from "@tsed/schema";
import { TextAnalyticsClient, AzureKeyCredential } from '@azure/ai-text-analytics';
import { readFileSync } from 'fs';
import * as pdfParse from 'pdf-parse';
import { exec } from "child_process";
import { AdminService } from "../../services/AdminService";
import { MessageService } from "../../services/MessageService";
import { JwtMiddleware } from "../../middlewares/JwtMiddleware";
import { MessageModel } from "../../models/MessageModel";

// import  { Configuration, OpenAI } from "openai"
@Controller("/chat")
export class ChatController {
  constructor(@Inject(AdminService)private adminService:AdminService,@Inject(MessageService)private messageService:MessageService){}
  @Post("/:chat")
  @Use(JwtMiddleware)
  async runPythonScript(@MultipartFile('file')file:PlatformMulterFile,@PathParams("chat")chat:string, @BodyParams() message: MessageModel,@Req()req:Req ) {
    return await this.messageService.createMessage(chat,req.user!._id,message.text);
  }
}

