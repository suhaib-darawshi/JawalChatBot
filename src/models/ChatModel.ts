import { Model, ObjectID, Ref } from "@tsed/mongoose";
import {Default, Property} from "@tsed/schema";
import { UserModel } from "./UserModel";
@Model({
  schemaOptions: {
    timestamps: true,
  }
})
export class ChatModel {
  @ObjectID()
  _id: string;

  @Ref(UserModel)
  userId:Ref<UserModel>

  @Property()
  @Default(false)
  isFavorite:boolean

  @Property()
  name:string;

}
