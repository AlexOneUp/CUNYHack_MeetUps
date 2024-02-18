from dotenv import load_dotenv
import googlemaps
import requests
import os

from helpers.midpoint import getCommuteTime


def getBusinesses(geocodes, midpoint, modes):
    latitude = midpoint["lat"]
    longitude = midpoint["lng"]

    endpoint = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"

    place_types = [
        "cafe",
        "restaurant",
        "bar",
        "activity",
        "fun",
        "entertainment",
        "food",
    ]

    params = {
        "location": f"{latitude},{longitude}",
        "radius": 200,
        "key": os.getenv("googlemapsAPIKey"),
        "keyword": "|".join(place_types),
    }

    response = requests.get(endpoint, params=params)
    businesses = response.json().get("results", [])
    sorted_businesses = sorted(
        businesses, key=lambda x: x.get("rating", 0), reverse=True
    )

    topBusinesses = []
    for i in range(5):
        if i >= len(sorted_businesses):
            break

        business = {}

        business["name"] = sorted_businesses[i].get("name", "N/A")
        business["address"] = sorted_businesses[i].get("vicinity", "N/A")
        business["rating"] = sorted_businesses[i].get("rating", "N/A")
        business["price_level"] = sorted_businesses[i].get("price_level", "N/A")
        business["location"] = (
            sorted_businesses[i].get("geometry", {}).get("location", {})
        )

        topBusinesses.append(business)

    addCommuteTimes(geocodes, topBusinesses, modes)

    return topBusinesses


def addCommuteTimes(geocodes, topBusinesses, modes):
    for business in topBusinesses:
        commuteTimes = []
        for i in range(len(modes)):
            commuteTimes.append(
                getCommuteTime(geocodes[i], business["location"], modes[i])
            )
        business["commuteTimes"] = commuteTimes

    return topBusinesses
