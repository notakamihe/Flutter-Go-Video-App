package router

import (
	"context"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"path/filepath"
	"strings"
	"time"

	"github.com/gorilla/mux"
	"github.com/notakamihe/video_app/server/db"
	"github.com/notakamihe/video_app/server/models"
	"github.com/notakamihe/video_app/server/utils"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

func addVideoSubroutes(s *mux.Router) {
	s.HandleFunc("/videos", getAllVideos).Methods("GET")
	s.HandleFunc("/videos/{id}", getVideoById).Methods("GET")
	s.HandleFunc("/videos/user/{id}", getVideosByUserId).Methods("GET")
	s.HandleFunc("/videos", createVideo).Methods("POST")
	s.HandleFunc("/videos/{id}/file", updateVideoFile).Methods("PUT")
	s.HandleFunc("/videos/{id}/thumbnail", updateVideoThumbnail).Methods("PUT")
	s.HandleFunc("/videos/{id}/add-view", addVideoPlay).Methods("PUT")
	s.HandleFunc("/videos/{id}/toggle-like/{userId}", toggleVideoLike).Methods("PUT")
	s.HandleFunc("/videos/{id}", deleteVideo).Methods("DELETE")
}

func addVideoPlay(w http.ResponseWriter, r *http.Request) {
	var video models.Video
	params := mux.Vars(r)

	oid, _ := primitive.ObjectIDFromHex(params["id"])
	after := options.After

	err := db.VideosCollection.FindOneAndUpdate(context.TODO(), bson.M{"_id": oid}, bson.M{
		"$inc": bson.M{"views": 1},
	}, &options.FindOneAndUpdateOptions{ReturnDocument: &after}).Decode(&video)

	if err != nil {
		if err == mongo.ErrNoDocuments {
			http.Error(w, fmt.Sprintf("Could not find video w/ id of %s", params["id"]), 400)
			return
		}

		log.Fatal(err)
	}

	json.NewEncoder(w).Encode(video)
}

func deleteVideo(w http.ResponseWriter, r *http.Request) {
	var params = mux.Vars(r)

	id, _ := primitive.ObjectIDFromHex(params["id"])

	result, err := db.VideosCollection.DeleteOne(context.TODO(), bson.M{"_id": id})

	if err != nil {
		log.Fatal(err)
	}

	if result.DeletedCount == 0 {
		http.Error(w, fmt.Sprintf("Could not delete user w/ id of %s", params["id"]), 400)
		return
	}

	json.NewEncoder(w).Encode(result)
}

func createVideo(w http.ResponseWriter, r *http.Request) {
	var video models.Video

	json.NewDecoder(r.Body).Decode(&video)

	if video.Title == "" {
		http.Error(w, "Must provide title.", 400)
		return
	}

	if !utils.IsOIdInCollection(db.UsersCollection, video.User.Hex()) {
		http.Error(w, "User OID must exist.", 400)
		return
	}

	video.Id = primitive.NewObjectID()
	video.CreatedOn = time.Now()
	video.Likes = []primitive.ObjectID{}
	video.Views = 0

	_, err := db.VideosCollection.InsertOne(context.TODO(), video)

	if err != nil {
		log.Fatal(err)
	}

	json.NewEncoder(w).Encode(video)
}

func getAllVideos(w http.ResponseWriter, r *http.Request) {
	var videos []bson.M

	query := []bson.M{
		{"$lookup": bson.M{"from": "users", "localField": "user", "foreignField": "_id", "as": "user"}},
		{"$unwind": "$user"}}

	result, err := db.VideosCollection.Aggregate(context.TODO(), query)

	if err != nil {
		log.Fatal(err)
	}

	if err = result.All(context.TODO(), &videos); err != nil {
		panic(err)
	}

	json.NewEncoder(w).Encode(videos)
}

func getVideoById(w http.ResponseWriter, r *http.Request) {
	var video []bson.M
	params := mux.Vars(r)

	oid, _ := primitive.ObjectIDFromHex(params["id"])

	query := []bson.M{
		{"$match": bson.M{"_id": oid}},
		{"$lookup": bson.M{"from": "users", "localField": "user", "foreignField": "_id", "as": "user"}},
		{"$unwind": "$user"}}

	result, err := db.VideosCollection.Aggregate(context.TODO(), query)

	if err != nil {
		log.Fatal(err)
	}

	if err = result.All(context.TODO(), &video); err != nil {
		log.Fatal(err)
	}

	if len(video) == 0 {
		http.Error(w, fmt.Sprintf("Could not find video w/ id of %s", params["id"]), 400)
		return
	}

	json.NewEncoder(w).Encode(video[0])
}

func getVideosByUserId(w http.ResponseWriter, r *http.Request) {
	var videos []bson.M
	params := mux.Vars(r)

	oid, _ := primitive.ObjectIDFromHex(params["id"])

	query := []bson.M{
		{"$match": bson.M{"user": oid}},
		{"$lookup": bson.M{"from": "users", "localField": "user", "foreignField": "_id", "as": "user"}},
		{"$unwind": "$user"}}

	result, err := db.VideosCollection.Aggregate(context.TODO(), query)

	if err != nil {
		log.Fatal(err)
	}

	if err = result.All(context.TODO(), &videos); err != nil {
		log.Fatal(err)
	}

	json.NewEncoder(w).Encode(videos)
}

func toggleVideoLike(w http.ResponseWriter, r *http.Request) {
	var video models.Video
	params := mux.Vars(r)

	if !utils.IsOIdInCollection(db.UsersCollection, params["userId"]) {
		http.Error(w, "User OID must exist.", 400)
		return
	}

	oid, _ := primitive.ObjectIDFromHex(params["id"])
	userOId, _ := primitive.ObjectIDFromHex(params["userId"])

	err := db.VideosCollection.FindOne(context.TODO(), bson.M{"_id": oid}).Decode(&video)

	if err != nil {
		if err == mongo.ErrNoDocuments {
			http.Error(w, fmt.Sprintf("Could not find video w/ id of %s", params["id"]), 400)
			return
		}

		log.Fatal(err)
	}

	i := utils.IndexOfOID(video.Likes, userOId)

	if i != -1 {
		video.Likes = append(video.Likes[:i], video.Likes[i+1:]...)
	} else {
		video.Likes = append(video.Likes, userOId)
	}

	_, err = db.VideosCollection.UpdateOne(context.TODO(), bson.M{"_id": oid}, bson.M{
		"$set": bson.M{
			"likes": video.Likes,
		}})

	if err != nil {
		log.Fatal(err)
	}

	json.NewEncoder(w).Encode(video.Likes)
}

func updateVideoFile(w http.ResponseWriter, r *http.Request) {
	var video models.Video
	fileUrl := ""
	params := mux.Vars(r)

	r.ParseMultipartForm(1000 << 20)

	file, handler, err := r.FormFile("file")

	if err != nil {
		if file != nil {
			http.Error(w, "Error retrieving file.", 400)
			return
		}
	}

	if file != nil {
		defer file.Close()
	}

	if handler != nil {
		if !strings.Contains(handler.Header.Get("Content-Type"), "video") {
			http.Error(w, "Must provide a video file.", 400)
			return
		}

		fileUrl = filepath.Join("videos", time.Now().Format("20060102150405")+handler.Filename)
	}

	oid, _ := primitive.ObjectIDFromHex(params["id"])
	after := options.After

	err = db.VideosCollection.FindOneAndUpdate(context.TODO(), bson.M{"_id": oid}, bson.M{
		"$set": bson.M{"fileurl": fileUrl},
	}, &options.FindOneAndUpdateOptions{ReturnDocument: &after}).Decode(&video)

	if err != nil {
		if err == mongo.ErrNoDocuments {
			http.Error(w, fmt.Sprintf("Could not find video w/ id of %s", params["id"]), 400)
			return
		}

		log.Fatal(err)
	}

	if file != nil {
		path := filepath.Join("uploads", fileUrl)
		newFile, err := os.Create(path)

		if err != nil {
			log.Fatal(err)
		}

		defer newFile.Close()

		bytes, err := ioutil.ReadAll(file)

		if err != nil {
			log.Fatal(err)
		}

		newFile.Write(bytes)
	}

	json.NewEncoder(w).Encode(video)
}

func updateVideoThumbnail(w http.ResponseWriter, r *http.Request) {
	var video models.Video
	thumbnailUrl := ""
	params := mux.Vars(r)

	r.ParseMultipartForm(16 << 20)

	file, handler, err := r.FormFile("thumbnail")

	if err != nil {
		if file != nil {
			http.Error(w, "Error retrieving file.", 400)
			return
		}
	}

	if file != nil {
		defer file.Close()
	}

	if handler != nil {
		if !strings.Contains(handler.Header.Get("Content-Type"), "image") {
			http.Error(w, "Must provide a image file.", 400)
			return
		}

		thumbnailUrl = filepath.Join("images", time.Now().Format("20060102150405")+handler.Filename)
	}

	oid, _ := primitive.ObjectIDFromHex(params["id"])
	after := options.After

	err = db.VideosCollection.FindOneAndUpdate(context.TODO(), bson.M{"_id": oid}, bson.M{
		"$set": bson.M{"thumbnailurl": thumbnailUrl},
	}, &options.FindOneAndUpdateOptions{ReturnDocument: &after}).Decode(&video)

	if err != nil {
		if err == mongo.ErrNoDocuments {
			http.Error(w, fmt.Sprintf("Could not find video w/ id of %s", params["id"]), 400)
			return
		}

		log.Fatal(err)
	}

	if file != nil {
		path := filepath.Join("uploads", thumbnailUrl)
		newFile, err := os.Create(path)

		if err != nil {
			log.Fatal(err)
		}

		defer newFile.Close()

		bytes, err := ioutil.ReadAll(file)

		if err != nil {
			log.Fatal(err)
		}

		newFile.Write(bytes)
	}

	json.NewEncoder(w).Encode(video)
}
