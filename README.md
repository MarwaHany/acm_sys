# Description
The App is a mini chat system that has multiple applications identified by a unique token, each Application has many chats each identified by a unique number (number should start from 1) , each Chat has many messages identified by a unique number (number should also start from 1).
### Covered Points
- `RESTful` APIs.
- `MySQL` database.
- `ElasticSearch` for partial matching messages content.
- use `Docker` to contatinerize the application.
- use `Sidekiq` to create chats and messages.
- use `redis` for updating number of chats of each application and number of messages on each chat.
### How To Run Application
- First run 
 ``` bash
docker-compose build
``` 
- Then run
``` bash
docker-compose up
```
