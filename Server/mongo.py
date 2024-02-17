import os
import pymongo
from pymongo import MongoClient
from dotenv import load_dotenv
import bcrypt
import uuid

load_dotenv()
MONGO_PASS = os.environ["MONGO_PASS"]

cluster = MongoClient(
    f"mongodb+srv://goats:{MONGO_PASS}@hangnyc.arbldh3.mongodb.net/?retryWrites=true&w=majority"
)

db = cluster["HangNYC"]
userCollection = db["users"]


def hash_password(password):
    salt = bcrypt.gensalt()
    hashed_password = bcrypt.hashpw(password.encode("utf-8"), salt)
    return hashed_password


def create_user(name, password):
    hashed_password = hash_password(password)
    userID = uuid.uuid4().hex
    user = {"_id": userID, "name": name, "password": hashed_password}
    userCollection.insert_one(user)
    return user


def auth_user(name, password):
    user = userCollection.find_one({"name": name})

    if user:
        if bcrypt.checkpw(password.encode("utf-8"), user["password"]):
            return user
    return None
