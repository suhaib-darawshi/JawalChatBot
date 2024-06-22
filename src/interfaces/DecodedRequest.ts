import { UserModel } from "../models/UserModel";

declare module "@tsed/common" {
    interface Req {
      user?: UserModel; 
      key:any
    }
  }
