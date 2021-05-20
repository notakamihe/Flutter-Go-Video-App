package main

import (
	"context"
	"fmt"
	"log"
	"net/http"

	"github.com/gorilla/handlers"
	"github.com/notakamihe/video_app/server/db"
	"github.com/notakamihe/video_app/server/router"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

func main() {
	clientOptions := options.Client().ApplyURI("mongodb://localhost:27017/?readPreference=primary&appname=MongoDB%20Compass&ssl=false")
	client, err := mongo.Connect(context.TODO(), clientOptions)

	if err != nil {
		log.Fatal(err)
	}

	db.UsersCollection = client.Database("videosappdb").Collection("users")
	db.VideosCollection = client.Database("videosappdb").Collection("videos")

	if err = client.Ping(context.TODO(), nil); err != nil {
		log.Fatal(err)
	}

	headers := handlers.AllowedHeaders([]string{"X-Requested-With", "Content-Type", "x-access-token"})
	methods := handlers.AllowedMethods([]string{"GET", "POST", "PUT", "DELETE"})
	origins := handlers.AllowedOrigins([]string{"*"})

	r := router.NewRouter()

	fmt.Println("Successfully connected to the Mongo database.")
	fmt.Println("Successfully started server on port 8000.")
	log.Fatal(http.ListenAndServe(":8000", handlers.CORS(headers, methods, origins)(r)))
}
