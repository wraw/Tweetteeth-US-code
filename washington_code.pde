import processing.serial.*;

import cc.arduino.*;

import twitter4j.conf.*;
import twitter4j.*;
import twitter4j.auth.*;
import twitter4j.api.*;
import java.util.*;

GeoLocation washington;

Arduino arduino;

int pos=0; //servo position in degrees (0..180)

Twitter twitter;
String searchString = "food";
List<Status> tweets;

int currentTweet;

void setup()
{
    size(800,600);
    
     println(Arduino.list());

  arduino = new Arduino(this, Arduino.list()[5], 57600);

  arduino.pinMode(9,5);
  arduino.analogWrite(9, 0);


    ConfigurationBuilder cb = new ConfigurationBuilder();
    cb.setOAuthConsumerKey("noZKuu83FQm9vkqQEF91GjaUh");
    cb.setOAuthConsumerSecret("tITmfoHj15ApeXs6DBi87YQfCjn0NymLn1pJhFvMc1uBjxkEgs");
    cb.setOAuthAccessToken("4060741114-A6zegrdL7dWZAqfws4f2V1IcRFaVemNd2SwTsl7");
    cb.setOAuthAccessTokenSecret("bWhpL9yYVTOg3BfnRtkydS1MRG9akeRvo9uMuZnnGkTEZ");

    TwitterFactory tf = new TwitterFactory(cb.build());

    twitter = tf.getInstance();

    getNewTweets();

    currentTweet = 0;

    thread("refreshTweets");
    
   

    
    
}

void draw()
{
    fill(0, 40);
    rect(0, 0, width, height);

    currentTweet = currentTweet + 1;

    if (currentTweet >= tweets.size())
    {
        currentTweet = 0;
    }

    Status status = tweets.get(currentTweet);

    fill(200);
    text(status.getText(), random(width), random(height), 300, 200);
    println(tweets.size()); 
    arduino.analogWrite(9,tweets.size());
    delay(2000);
    arduino.analogWrite(9,0);

    delay(250);
}

void getNewTweets()
{
    try
    {
        Query query = new Query(searchString);
        washington = new GeoLocation(39.51305555555555,77.03444444444445);
        query.setGeoCode(washington,1000,Query.KILOMETERS);
        query.setCount(90);
        QueryResult result = twitter.search(query);

        tweets = result.getTweets();
    }
    catch (TwitterException te)
    {
        System.out.println("Failed to search tweets: " + te.getMessage());
        System.exit(-1);
    }
}

void refreshTweets()
{
    while (true)
    {
        getNewTweets();

        println("Updated Tweets");

        delay(30000);
    }
}
