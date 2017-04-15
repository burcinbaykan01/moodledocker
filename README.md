

A Dockerfile that installs and runs the latest Moodle stable(3.2+).

## Installation

```
git clone https://github.com/burcinbaykan01/moodledocker
cd docker-moodle
docker build -t moodle .
```

## Usage

To spawn a new instance of Moodle:

```
docker run -d --name DB -p 3306:3306 -e MYSQL_DATABASE=moodle -e MYSQL_USER=moodle -e MYSQL_PASSWORD=moodle centurylink/mysql
docker run -d -P --name moodle --link DB:DB -e MOODLE_URL=http://130.149.22.217:8080 -p 8080:80 moodle
```

You can visit the following URL in a browser to get started:

```
http://130.149.22.217:8080
```



