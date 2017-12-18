#! /usr/bin/python
import redis

print("hello")

r = redis.Redis(host='127.0.0.1', port=6579)
r.set('foo', 'Bar')
print r.get('foo')
