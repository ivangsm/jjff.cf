# **jjff.cf**

URL shortener service made with OpenResty and Redis.

 	jjff - FAST! URL Shortener
        
        Here's only 2 endpoints
            - '/set'
                example:
                    jjf.cf/set?url=https://url.com
            - '/'
                example:
                    jjff.cf/a0b1

        caution: the links are public and are not stored permanently


## 🐋 Run it with docker

### Dependencies:
- docker
- docker-compose

inside the project just run

`docker-compose up -d`

and now the API is available on localhost:8080

## ⏲ Performance

_Intel® Core™ i7-8550U CPU @ 1.80GHz × 8 + 8GB RAM DDR4_

	hey -n 100000 -c 100 -m GET http://localhost:8080/46a6

	Summary:
	Total:	7.9975 secs
	Slowest:	0.2431 secs
	Fastest:	0.0002 secs
	Average:	0.0079 secs
	Requests/sec:	12503.8873
	

	Response time histogram:
	0.000 [1]	|
	0.024 [99703]	|■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	0.049 [178]	|
	0.073 [49]	|
	0.097 [48]	|
	0.122 [4]	|
	0.146 [1]	|
	0.170 [6]	|
	0.195 [1]	|
	0.219 [6]	|
	0.243 [3]	|


	Latency distribution:
	10% in 0.0070 secs
	25% in 0.0074 secs
	50% in 0.0077 secs
	75% in 0.0081 secs
	90% in 0.0087 secs
	95% in 0.0093 secs
	99% in 0.0140 secs

	Details (average, fastest, slowest):
	DNS+dialup:	0.0000 secs, 0.0002 secs, 0.2431 secs
	DNS-lookup:	0.0000 secs, 0.0000 secs, 0.0132 secs
	req write:	0.0000 secs, 0.0000 secs, 0.0089 secs
	resp wait:	0.0079 secs, 0.0002 secs, 0.2431 secs
	resp read:	0.0000 secs, 0.0000 secs, 0.0056 secs

	Status code distribution:
	[200]	100000 responses