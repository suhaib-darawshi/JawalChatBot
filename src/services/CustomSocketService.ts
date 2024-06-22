import { Inject, InjectorService } from "@tsed/di";
import { MongooseModel } from "@tsed/mongoose";
import {IO, Nsp, Socket, SocketService, SocketSession} from "@tsed/socketio";
import * as SocketIO from "socket.io";
import { UserModel } from "./../models/UserModel";

interface Client {
    id: string;
    role:string
  }
  
@SocketService("socket")
export class CustomSocketService {
  
    @Nsp nsp: SocketIO.Namespace;
    private clients: Map<string, SocketIO.Socket[]> = new Map();
  @Nsp("/")
  nspOther: SocketIO.Namespace; 

  constructor(
    @IO() private io: SocketIO.Server,
    private injector: InjectorService,
    ) {}
  setIo(io:SocketIO.Server){
    this.io=io;
  }
  $onNamespaceInit(nsp: SocketIO.Namespace) {}
  $onConnection(@Socket socket: SocketIO.Socket, @SocketSession session: SocketSession) {
    socket.on("setId", (data: Client) => {
      if (!this.clients.has(data.id)){
        this.clients.set(data.id, [socket]);
      }
      else{
        let cls=this.clients.get(data.id)!;
        cls.push(socket);
        this.clients.set(data.id,cls);
      }
      
  });
    
  }
  $onDisconnect(@Socket socket: SocketIO.Socket) {
    this.clients.forEach((socketA, id) =>{
        
          for(const sockett of  socketA){
            if(socket.id==sockett.id){
              this.clients.delete(id);
            console.log(`${id} has disconnected`);
          }
        }
            
        
    });
    
  }
  sendEventToClient(id: string, data: any,event:string) {
    const client = this.clients.get(id);
    console.log(data);
    
    if (client) {
      for(const sockett of  client){
        try{
          console.log("emited");
          sockett.emit(event, data);
        }
        catch(e){
  
        }
      }
      
      return id;
    }
    
  }
}
