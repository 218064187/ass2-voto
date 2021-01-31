import ballerina/io;
import ballerina/http;
import ballerina/lang.'int;

http:Client clientEndpoint = check new ("http://localhost:9090");
public function main () {

        io:println("WELCOME TO     VOTO");
        io:println("******************************");
        io:println("1.Register as candidate");
        io:println("2.Register as voter");
        io:println("3.Vote");
        io:println("4.Projections");
        io:println("5.get results");


       string choice = io:readln("Enter choice :");

       if (choice === "1"){
           //**************register candidate **********************
           string name = io:readln("Enter Name :");
           string nam_id  = io:readln("Enter Namibian ID  :");
           string ruling_party  = io:readln("Enter Ruling  Party  :");

           int|error id = 'int:fromString(nam_id);

             var  response = clientEndpoint->post("/graphql",{ query: " { register_candidate(name:\"tinashe\",id:1,ruling_party:\"swapo\") }" });
           // io:println(response);
            if (response is  http:Response) {
                var jsonResponse = response.getJsonPayload();

                if (jsonResponse is json) {

                    io:println(jsonResponse);
                } else {
                    io:println("Invalid payload received:", jsonResponse.message());
                }

             }
           }else if(choice === "2"){
                //**************register voter **********************
           string name = io:readln("Enter Name :");
           string nam_id  = io:readln("Enter voter ID  :");

           int|error id = 'int:fromString(nam_id);

             var  response = clientEndpoint->post("/graphql",{ query: " { register_vote(name:\"tinashe\",namibian_id:4) }" });
           // io:println(response);
            if (response is  http:Response) {
                var jsonResponse = response.getJsonPayload();

                if (jsonResponse is json) {

                    io:println(jsonResponse);
                } else {
                    io:println("Invalid payload received:", jsonResponse.message());
                }

             }
           }else if(choice === "3"){
                //**************register voter **********************

           string name = io:readln("Enter voter ID :");
           string nam_id  = io:readln("Enter  candidate id  :");

           int|error id = 'int:fromString(nam_id);


             var  response = clientEndpoint->post("/graphql",{ query: " { vote(voterID:1,candidateID:4) }" });
           // io:println(response);3
            if (response is  http:Response) {
                var jsonResponse = response.getJsonPayload();

                if (jsonResponse is json) {

                    io:println(jsonResponse);
                } else {
                    io:println("Invalid payload received:", jsonResponse.message());
                }

             }
           }



}