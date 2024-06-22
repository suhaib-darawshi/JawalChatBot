import {Inject, Injectable} from "@tsed/di";
import { MongooseModel } from "@tsed/mongoose";
import { ChatModel } from "../models/ChatModel";
import { MessageModel } from "../models/MessageModel";
import { UserModel } from "../models/UserModel";
import { exec } from "child_process";
import { BadRequest } from "@tsed/exceptions";
import { pipeline } from "stream";
import { FaqModel } from "../models/FaqModel";
@Injectable()
export class MessageService {
    constructor(@Inject(MessageModel)private messageModel:MongooseModel<MessageModel>,@Inject(ChatModel)private chatModel:MongooseModel<ChatModel>,@Inject(UserModel)private userModel:MongooseModel<UserModel>,@Inject(FaqModel)private faqModel:MongooseModel<FaqModel>){}
    async  handleFaqUpdate(similarity: string) {
        try {
          const existingFaq = await this.faqModel.findOne({ qa: similarity });
      
          if (existingFaq) {
            existingFaq.count += 1;
            await existingFaq.save();
          } else {
            const newFaq = this.faqModel.create({
              qa: similarity,
              count: 1
            });
          }
        } catch (error) {
          console.error('Failed to update FAQ count:', error);
        }
      }
    
    async createMessage(chatId:string|null,userId:string,text:string){
        const user=await this.userModel.findById(userId);
        if(!user)throw new BadRequest("USER_NOT_FOUND");
        let chat;
        let history=[];
        if(chatId=='1'){
            chat=await this.chatModel.create({
                userId:user
            });
            chatId=chat._id;
        }
        else{
            chat=await this.chatModel.findById(chatId);
            if(!chat)throw new BadRequest("CHATNOWFOUND")
            let msgs=await this.messageModel.find({chatId:chat!._id});
            for(let i=0;i<msgs.length;i++){
                if((i+2)<msgs.length){
                    history.push({"user_query":msgs[i].text,"bot_response":msgs[i].text});
                }
                
            }
        }
        const mn= this.messageModel.create({
            chatId:chat,
            text:text,
            isSender:true,
            gpt:false,
        });

        const resp= await this.getGPTResponse(text,history)as string;
        const m=(JSON.parse(resp))
        m['answer']=JSON.parse(m['answer']);
        m['source']=(m['source']as string).replace("\\","/");
        m['source']=(m['source']as string).replace("txt","pdf");
        m['source']=(m['source']as string).replace("Questions","uploads/Qfiles");
        
        if(resp){
            const ma= this.messageModel.create({
                chatId:chat,
                text:m['answer']['content'],
                isSender:false,
                gpt:true,
                file:m['source'],
                similarity:m['metadata']['chunk'],
                index:m['metadata']['index']
            });
            await this.handleFaqUpdate(m['metadata']['chunk'])
            chatId=chat!._id;
            const c= this.chatModel.aggregate([
                {
                    $match:{
                        $expr:{
                            $eq:["$_id",chatId]
                        }
                    },
                    
                },
                {
                    $limit:1
                },
                {
                    $lookup:{
                        from:"messagemodels",
                        as :"messages",
                        let:{chatId:"$_id"},
                        pipeline:[
                            {
                                $match: {
                                  $expr: {
                                    $eq: ["$$chatId", "$chatId"] 
                                  }
                                }
                              },
                                  { $sort: { updatedAt: -1 } },
                                  {
                                    $lookup:{
                                        from:"usermodels",
                                        let:{userId:"$user"},
                                        pipeline:[
                                            {
                                                $match: {
                                                  $expr: {
                                                    $eq: ["$$userId", "$_id"] 
                                                  }
                                                }
                                              },
                                        ],
                                        as:"user"
                                    }
                                  },
                                  {
                                    $addFields: {
                                      user: {
                                        $cond: {
                                          if: { $eq: [{ $size: "$user" }, 0] },
                                          then: "$$REMOVE",
                                          else: { $arrayElemAt: ["$user", 0] }
                                        }
                                      }
                                    }
                                  }
                        ]
                }
                }
            ]);
            return c;
        }
        return resp.split("'")[1]
    }
    async getGPTResponse(text:string,history:any){
        return new Promise((resolve, reject) => {
            const historyJSON = JSON.stringify(history);
        
            const command = `python PythonScripts/send.py "${text}" "${historyJSON.replace(/"/g, '\\"')}"`;

            exec(command, (error, stdout, stderr) => {
              if (error) {
                console.error(`Execution error: ${error}`);
                reject(`Error running script: ${stderr}`);
              } else {
                console.log(`Script Output: ${stdout}`);
                resolve(stdout);
              }
            });
          });
    }

}
