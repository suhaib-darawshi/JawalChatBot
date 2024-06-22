import { Model, ObjectID, Ref } from "@tsed/mongoose";
import {Default, Property} from "@tsed/schema";
import { ChatModel } from "./ChatModel";
import { UserModel } from "./UserModel";
@Model({
  schemaOptions: {
    timestamps: true,
  }
})
export class MessageModel {
  @ObjectID()
  _id: string;

  @Ref(ChatModel)
  chatId:Ref<ChatModel>

  @Property()
  text:string;

  @Property()
  @Default(false)
  isSender:boolean;

  @Property()
  file:string;

  @Property()
  @Default(true)
  gpt:boolean;

  @Ref(UserModel)
  user:Ref<UserModel>;

  @Property()
  notes:string;

  @Property()
  similarity:string

  @Property()
  index:any
}
