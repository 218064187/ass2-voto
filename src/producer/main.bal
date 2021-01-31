
import ballerinax/kafka;
import ballerina/graphql;
import ballerina/io;
import ballerina/docker;
 
 
@docker:Config {
  name:"register_candi",
  tag:"v1.0"
}

@kubernetes:Deployment { image:"consumer-service", name:"kafka-consumer" }
kafka:ProducerConfiguration Candidate_Register = {
	bootstrapServers: "localhost:9092",
	clientId: "register-candidate",
	acks: "all",
	retryCount: 3
//	valueSerializerType: kafka:SER_STRING,
//	keySerializerType: kafka:SER_INT
};

kafka:ProducerConfiguration vote = {
	bootstrapServers: "localhost:9092",
	clientId: "vote",
	acks: "all",
	retryCount: 3
//	valueSerializerType: kafka:SER_STRING,
//	keySerializerType: kafka:SER_INT
};

kafka:ProducerConfiguration register_voter = {
	bootstrapServers: "localhost:9092",
	clientId: "register-voter",
	acks: "all",
	retryCount: 3
//	valueSerializerType: kafka:SER_STRING,
//	keySerializerType: kafka:SER_INT
};




kafka:Producer prod =checkpanic new (Candidate_Register);
kafka:Producer vote_producer =checkpanic new (vote);
kafka:Producer vote_register_prod =checkpanic new (register_voter);

service graphql:Service /graphql on new graphql:Listener(9090) {
 //register candidate
    resource function get register_candidate(string name,int id,string ruling_party) returns string {
            Candidate candidate ={name,id,ruling_party};
            registered_candidate_voters[id.toString()] = {name:name,vID:id,party:ruling_party};
            //byte[] serialisedMsg = candidate.toString().toBytes();
             // checkpanic prod->sendProducerRecord({
            //                         topic: "dsp",
            //                         value: serialisedMsg });

            //  checkpanic prod->flushRecords();\
            io:println(registered_candidate_voters);
        return "Candidate registered succesfully : " + name;
    }
    //vote 
    
     resource function get vote(int voterID,int candidateID) returns string {
            Vote vote_info ={voterID,candidateID};
        //    //check if the details are correct
            // if (register_vote.hasKey(voterID) && registered_candidate_voters.hasKey(candidateID) ){
            //       io:println("very");
            // }
            byte[] serialisedMsg = vote_info.toString().toBytes();

              checkpanic vote_producer->sendProducerRecord({
                                    topic: "voting",
                                    value: serialisedMsg });

             checkpanic vote_producer->flushRecords();
        return "Hello, " ;
    }

// register as a voter
     resource function get register_vote(string name,int namibian_id) returns string {
            Registered_voter vote_info ={name,namibian_id};
            // Candidate candidate ={name,id,ruling_party};
            register_vote[namibian_id.toString()] = {name:name,namibian_id:namibian_id};

            // byte[] serialisedMsg = vote_info.toString().toBytes();

            //   checkpanic vote_register_prod->sendProducerRecord({
            //                         topic: "dsp",
            //                         value: serialisedMsg });

            //  checkpanic vote_register_prod->flushRecords();
            io:println(register_vote);
        return "voter registered succesfully, " + name;
    }
    //count votes 

}
//records
public type Candidate record {
    string name;
    int id;
    string ruling_party;
};
public type Vote record {
    int voterID;
    int candidateID;
    
};
public type Registered_voter record {
    string name;
    int namibian_id;
};


map<json> registered_candidate_voters ={};
map<json> register_vote ={};
map<json> accepted_vote ={};
