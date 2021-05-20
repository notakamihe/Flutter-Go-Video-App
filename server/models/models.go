package models

import (
	"time"

	"go.mongodb.org/mongo-driver/bson/primitive"
)

type User struct {
	Id        primitive.ObjectID `json:"_id" bson:"_id"`
	Name      string             `json:"name"`
	Email     string             `json:"email"`
	Password  string             `json:"password"`
	CreatedOn time.Time          `json:"createdOn"`
}

type Video struct {
	Id           primitive.ObjectID   `json:"_id" bson:"_id"`
	Title        string               `json:"title"`
	Description  string               `json:"description"`
	CreatedOn    time.Time            `json:"createdOn"`
	Likes        []primitive.ObjectID `json:"likes"`
	FileUrl      string               `json:"fileUrl"`
	ThumbnailUrl string               `json:"thumbnailUrl"`
	Views        int                  `json:"views"`
	User         primitive.ObjectID   `json:"user"`
}

type Token struct {
	Token string `json:"token"`
}
