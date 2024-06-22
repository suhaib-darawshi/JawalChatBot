import { Model, ObjectID } from "@tsed/mongoose";
import {Default, Property} from "@tsed/schema";
@Model({
  schemaOptions: {
    timestamps: true,
  }
})
export class FaqModel {
  @ObjectID()
  _id: string;

  @Property()
  qa:string;

  @Property()
  @Default(0)
  count:number
}
