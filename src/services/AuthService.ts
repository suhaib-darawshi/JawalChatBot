import {Inject, Injectable} from "@tsed/di";
import { BadRequest, Unauthorized } from "@tsed/exceptions";
import { MongooseModel } from "@tsed/mongoose";
import { UserModel } from "../models/UserModel";
import * as bcrypt from 'bcryptjs';
import { pipeline } from "stream";
import { AuthorizationService } from "./AuthorizationService";

@Injectable()
export class AuthService {
    constructor(@Inject(UserModel)private userModel:MongooseModel<UserModel>,@Inject(AuthorizationService)private authorService:AuthorizationService){}
    async login(userData:Partial<UserModel>){
        const user=await this.userModel.findOne({phone:userData.phone});
        if(!user) throw new BadRequest("USER_NOT_FOUND");
        if(!(await bcrypt.compare(userData.password!,user.password))){
            throw new Unauthorized("User not found or incorrect password");
        }
        return {user:await this.getUserDate(user),token: this.authorService.generateToken(user)};
    }
    async getUserDate(user:UserModel){
        const data=await this.userModel.aggregate([
            {
                $match: {
                    phone: user.phone,
                }
            },
            {
                $lookup: {
                    from:"chatmodels",
                    let:{userId:"$_id"},
                    pipeline:[
                        {
                      $match: {
                        $expr: {
                          $eq: ["$$userId", "$userId"] 
                        }
                      }
                    },
                        { $sort: { updatedAt: -1 } },
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
                        
                      ],
                      as: "chats",
                }
            }
        ]);
        if(data.length!=0)
        return data[0];
        else
        return null;
    }
    async createUser(data:Partial<UserModel>){
        const u=await this.userModel.findOne({phone:data.phone});
        if(u) throw new BadRequest("PHONE_NUMBER_ALREADY_SIGNED_UP")
        let oldPassword=data.password;
        data.password=await this.hashPassword(data.password!);
        const user=await this.userModel.create(data);
        data.password=oldPassword??"";
        
        return await this.login(data);
    }
    
    async  hashPassword(password: string): Promise<string> {
        return bcrypt.hash(password, await bcrypt.genSalt(10));
    }
}
