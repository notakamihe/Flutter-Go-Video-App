package utils

import (
	"context"
	"fmt"
	"time"

	"github.com/dgrijalva/jwt-go"
	"github.com/notakamihe/video_app/server/models"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"go.mongodb.org/mongo-driver/mongo"
)

func CreateToken(id string) (models.Token, error) {
	var err error

	atClaims := jwt.MapClaims{}

	atClaims["authorized"] = true
	atClaims["user_id"] = id
	atClaims["exp"] = time.Now().Add(time.Minute * 1440).Unix()

	at := jwt.NewWithClaims(jwt.SigningMethodHS256, atClaims)

	token, err := at.SignedString([]byte("secret"))

	if err != nil {
		return models.Token{}, err
	}

	return models.Token{Token: token}, nil
}

func IsOIdInCollection(collection *mongo.Collection, id string) bool {
	oid, err := primitive.ObjectIDFromHex(id)

	if err != nil {
		fmt.Println(err)
		return false
	}

	err = collection.FindOne(context.TODO(), bson.M{"_id": oid}).Decode(make(map[string]interface{}))

	if err != nil {
		fmt.Println(err)
		return false
	}

	return true
}

func IndexOfOID(list []primitive.ObjectID, oid primitive.ObjectID) int {
	for idx, id := range list {
		if id == oid {
			return idx
		}
	}

	return -1
}
