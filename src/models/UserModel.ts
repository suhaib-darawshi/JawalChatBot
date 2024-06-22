import {Default, Property} from "@tsed/schema";
import { Model, ObjectID, Unique } from "@tsed/mongoose";
@Model({
  schemaOptions: {
    timestamps: true,
  }
})
export class UserModel {
  @ObjectID()
  _id: string;
  @Property()
  username:string;
  @Property()
  phone:string;
  @Property()
  password:string;
  @Property()
  @Default("USER")
  role:string;
}
