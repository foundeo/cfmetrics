# cfmetrics
Simple CF Metrics. Just copy the CFML file to your server and run.

Note that in order for the threads viewer (threads.cfm) to be able to run on CFML engines running Java 9 or above, you may need to add this line to the JVM startup args (such as in jvm.config, for Adobe CF):

  --add-exports=jdk.management/com.sun.management.internal=ALL-UNNAMED

## JVM Memory
![memory screenshot](https://raw.githubusercontent.com/foundeo/cfmetrics/master/cfmetrics.png)
