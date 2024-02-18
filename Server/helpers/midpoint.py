from flask import jsonify
from dotenv import load_dotenv
import googlemaps
import json
import requests
import os

gmaps = googlemaps.Client(key=os.getenv("googlemapsAPIKey"))


def getBestMidpoint(geocodes, modes):
    # find midpoint
    midpoint = find_midpoint(geocodes)
    bestPoint = getBetterPoint(midpoint, geocodes, modes, 99999999)
    print("best", bestPoint)
    return geocodes[0]


def find_midpoint(geocodes):
    latitudes = [address["lat"] for address in geocodes]
    longitudes = [address["lng"] for address in geocodes]

    midpoint = {
        "lat": sum(latitudes) / len(latitudes),
        "lng": sum(longitudes) / len(longitudes),
    }
    return midpoint


def getBetterPoint(midpoint, geocodes, modes, difference):
    commuteTimes = []
    minTime = 99999999999
    maxTime = -99999999999
    for i in range(len(geocodes)):
        commuteTime = getCommuteTime(geocodes[i], midpoint, modes[i])
        if commuteTime < minTime:
            minTime = commuteTime
        if commuteTime > maxTime:
            maxTime = commuteTime

        commuteTimes.append(commuteTime)

    newDifference = maxTime - minTime
    if newDifference <= 600 or newDifference >= difference:  # 10 minutes
        return midpoint
    else:
        # get closer to farthest point
        fathestPoint = geocodes[commuteTimes.index(maxTime)]
        percentToMove = ((maxTime - ((maxTime + minTime) / 2)) / maxTime) / 2
        newPoint = getCloserPoint(midpoint, fathestPoint, percentToMove)
        return getBetterPoint(newPoint, geocodes, modes, newDifference)


def getCloserPoint(point1, point2, percentToMove):
    newPoint = {
        "lat": point1["lat"] + (point2["lat"] - point1["lat"]) * percentToMove,
        "lng": point1["lng"] + (point2["lng"] - point1["lng"]) * percentToMove,
    }
    return newPoint


def getCommuteTime(origin, destination, mode):
    directionsResult = gmaps.directions(
        origin, destination, mode=mode, departure_time="now"
    )
    return directionsResult[0]["legs"][0]["duration"]["value"]
