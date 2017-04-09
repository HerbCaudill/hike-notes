'use strict'
mongodb = require('mongodb')
# Standard URI format: mongodb://[dbuser:dbpassword@]host:port/dbname, details set in .env
MONGODB_URI = "mongodb://#{process.env.USER}:#{process.env.PASS}@#{process.env.HOST}:#{process.env.DB_PORT}/#{process.env.DB}"
collection = undefined

# ------------------------------
# ASYNCHRONOUS PROMISE-BASED API
#  SEE BELOW FOR SYNCHRONOUS API
# ------------------------------
# Serializes an object to JSON and stores it to the database

set = (key, value) ->
  new Promise((resolve, reject) ->
    if typeof key != 'string'
      reject new DatastoreKeyNeedToBeStringException(key)
    else
      try
        serializedValue = JSON.stringify(value)
        collection.updateOne { 'key': key }, { $set: 'value': serializedValue }, { upsert: true }, (err, res) ->
          if err
            reject new DatastoreUnderlyingException(value, err)
          else
            resolve res
          return
      catch ex
        reject new DatastoreValueSerializationException(value, ex)
    return
)

# Fetches an object from the DynamoDB instance, deserializing it from JSON

get = (key) ->
  new Promise((resolve, reject) ->
    try
      if typeof key != 'string'
        reject new DatastoreKeyNeedToBeStringException(key)
      else
        collection.findOne { 'key': key }, (err, data) ->
          if err
            reject new DatastoreUnderlyingException(key, err)
          else
            try
              if data == null
                resolve null
              else
                resolve JSON.parse(data.value)
            catch ex
              reject new DatastoreDataParsingException(data.value, ex)
          return
    catch ex
      reject new DatastoreUnknownException('get', { 'key': key }, ex)
    return
)

remove = (key) ->
  new Promise((resolve, reject) ->
    try
      if typeof key != 'string'
        reject new DatastoreKeyNeedToBeStringException(key)
      else
        collection.deleteOne { 'key': key }, (err, res) ->
          if err
            reject new DatastoreUnderlyingException(key, err)
          else
            resolve res
          return
    catch ex
      reject new DatastoreUnknownException('remove', { 'key': key }, ex)
    return
)

removeMany = (keys) ->
  Promise.all keys.map((key) ->
    remove key
  )

connect = ->
  new Promise((resolve, reject) ->
    try
      mongodb.MongoClient.connect MONGODB_URI, (err, db) ->
        if err
          reject err
        collection = db.collection(process.env.COLLECTION)
        resolve collection
        return
    catch ex
      reject new DatastoreUnknownException('connect', null, ex)
    return
)

DatastoreKeyNeedToBeStringException = (keyObject) ->
  @type = @constructor.name
  @description = 'Datastore can only use strings as keys, got ' + keyObject.constructor.name + ' instead.'
  @key = keyObject
  return

DatastoreValueSerializationException = (value, ex) ->
  @type = @constructor.name
  @description = 'Failed to serialize the value to JSON'
  @value = value
  @error = ex
  return

DatastoreDataParsingException = (data, ex) ->
  @type = @constructor.name
  @description = 'Failed to deserialize object from JSON'
  @data = data
  @error = ex
  return

DatastoreUnderlyingException = (params, ex) ->
  @type = @constructor.name
  @description = 'The underlying DynamoDB instance returned an error'
  @params = params
  @error = ex
  return

DatastoreUnknownException = (method, args, ex) ->
  @type = @constructor.name
  @description = 'An unknown error happened during the operation ' + method
  @method = method
  @args = args
  @error = ex
  return

setCallback = (key, value, callback) ->
  set(key, value).then((value) ->
    callback null, value
    return
  ).catch (err) ->
    callback err, null
    return
  return

getCallback = (key, callback) ->
  get(key).then((value) ->
    callback null, value
    return
  ).catch (err) ->
    callback err, null
    return
  return

removeCallback = (key, callback) ->
  remove(key).then((value) ->
    callback null, value
    return
  ).catch (err) ->
    callback err, null
    return
  return

removeManyCallback = (keys, callback) ->
  removeMany(keys).then((value) ->
    callback null, value
    return
  ).catch (err) ->
    callback err, null
    return
  return

connectCallback = (callback) ->
  connect().then((value) ->
    callback null, value
    return
  ).catch (err) ->
    callback err, null
    return
  return

setSync = (key, value) ->
  sync.await setCallback(key, value, sync.defer())

getSync = (key) ->
  sync.await getCallback(key, sync.defer())

removeSync = (key) ->
  sync.await removeCallback(key, sync.defer())

removeManySync = (keys) ->
  sync.await removeManyCallback(keys, sync.defer())

connectSync = ->
  sync.await connectCallback(sync.defer())

initializeApp = (app) ->
  app.use (req, res, next) ->
    sync.fiber next
    return
  return

# -------------------------------------------
# SYNCHRONOUS WRAPPERS AROUND THE PROMISE API
# -------------------------------------------
sync = require('synchronize')
asyncDatastore = 
  set: set
  get: get
  remove: remove
  removeMany: removeMany
  connect: connect
syncDatastore = 
  set: setSync
  get: getSync
  remove: removeSync
  removeMany: removeManySync
  connect: connectSync
  initializeApp: initializeApp
module.exports =
  async: asyncDatastore
  sync: syncDatastore

