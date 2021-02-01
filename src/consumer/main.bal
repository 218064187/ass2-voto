import ballerinax/kafka;
import ballerina/log;
import ballerina/docker;

@docker:Config {
  name:"register_voter",
  tag:"v2.0"
}


kafka:ConsumerConfiguration consConf = {
    bootstrapServers: "localhost:9092",
    groupId: "group-id",

    topics: ["voting"],
    pollingIntervalInMillis: 1000, 
    //keyDeserializerType: kafka:DES_INT,
    //valueDeserializerType: kafka:DES_STRING,
    autoCommit: false
};

listener kafka:Listener cons = new (consConf);

service kafka:Service on cons {
    remote function onConsumerRecord(kafka:Caller caller,
                                kafka:ConsumerRecord[] records) {
        foreach var kafkaRecord in records {
            processKafkaRecord(kafkaRecord);
        }

        var commitResult = caller->commit();

        if (commitResult is error) {
            log:printError("Error occurred while committing the " +
                "offsets for the consumer ", err = commitResult);
        }
    }
}

