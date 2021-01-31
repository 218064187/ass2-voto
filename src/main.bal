import ballerina/io;
import ballerina/http;
import ballerina/lang.'int;

http:Client clientEndpoint = check new ("http://localhost:9090");

public function main () {
      dashboard();
}


public function print_choices(){
    io:println("~~~~~~~~~~WELCOME TO VOTO~~~~~~~~");
    io:println();
    io:println("1.Register as candidate");
    io:println("2.Register as voter");
    io:println("3.Vote");
    io:println("4.Projections");
    io:println("5.Get results");
    io:println( "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
}


public function regist_candidate(){
    string name = io:readln("Enter Name :");
    string nam_id  = io:readln("Enter Namibian ID  :");
    string ruling_party  = io:readln("Enter Ruling  Party  :");

    int|error id = 'int:fromString(nam_id);

     var  response = clientEndpoint->post("/graphql",{ query: " { candidate_register(name:\"tinashe\",id:1,party:\"swapo\") }" });
    // io:println(response);
    if (response is  http:Response) {
        var jsonResponse = response.getJsonPayload();

        if (jsonResponse is json) {

            io:println(jsonResponse);
        } else {
            io:println("Invalid payload received:", jsonResponse.message());
        }

     }
}


public function regist_voter(){
    string name = io:readln("Enter Name :");
    string nam_id  = io:readln("Enter voter ID  :");

    int|error id = 'int:fromString(nam_id);

    var  response = clientEndpoint->post("/graphql",{ query: " { voter_register(name:\"tinashe\",id_number:4) }" });
    // io:println(response);
    if (response is  http:Response) {
       var jsonResponse = response.getJsonPayload();

       if (jsonResponse is json) {

           io:println(jsonResponse);
       } else {
           io:println("Invalid payload received:", jsonResponse.message());
       }

    }
}

public function vote(){
    string name = io:readln("Enter voter ID :");
    string nam_id  = io:readln("Enter  candidate id  :");

    int|error id = 'int:fromString(nam_id);

    var  response = clientEndpoint->post("/graphql",{ query: " { vote(voter_id:1,candidate_id:4) }" });
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

public function dashboard(){
    print_choices();

    string choice = io:readln("Enter choice>> ");

    if (choice === "1"){
        regist_candidate();

    }else if(choice === "2"){
        regist_voter();

    }else if(choice === "3"){
        vote();
    }

}

