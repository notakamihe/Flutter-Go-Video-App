package router

import (
	"context"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"regexp"
	"strings"
	"time"
	"unicode"

	"github.com/dgrijalva/jwt-go"
	"github.com/gorilla/mux"
	"github.com/notakamihe/video_app/server/db"
	"github.com/notakamihe/video_app/server/models"
	"github.com/notakamihe/video_app/server/utils"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"go.mongodb.org/mongo-driver/mongo"
	"golang.org/x/crypto/bcrypt"
)

func addUserSubroutes(s *mux.Router) {
	s.HandleFunc("/users", getAllUsers).Methods("GET")
	s.HandleFunc("/users/{id}", getUserById).Methods("GET")
	s.HandleFunc("/user", getUserByToken).Methods("GET")
	s.HandleFunc("/register", register).Methods("POST")
	s.HandleFunc("/login", login).Methods("POST")
	s.HandleFunc("/users/{id}", updateUser).Methods("PUT")
	s.HandleFunc("/users/{id}/password", updateUserPassword).Methods("PUT")
	s.HandleFunc("/users/{id}", deleteUser).Methods("DELETE")
}

func deleteUser(w http.ResponseWriter, r *http.Request) {
	var params = mux.Vars(r)

	id, _ := primitive.ObjectIDFromHex(params["id"])

	result, err := db.UsersCollection.DeleteOne(context.TODO(), bson.M{"_id": id})

	if err != nil {
		log.Fatal(err)
	}

	if result.DeletedCount == 0 {
		http.Error(w, fmt.Sprintf("Could not delete user w/ id of %s", params["id"]), 400)
		return
	}

	json.NewEncoder(w).Encode(result)
}

func getAllUsers(w http.ResponseWriter, r *http.Request) {
	var users []models.User

	result, err := db.UsersCollection.Find(context.TODO(), bson.M{})

	if err != nil {
		log.Fatal(err)
	}

	for result.Next(context.TODO()) {
		var user models.User
		err := result.Decode(&user)

		if err != nil {
			log.Fatal(err)
		}

		users = append(users, user)
	}

	json.NewEncoder(w).Encode(users)
}

func getUserById(w http.ResponseWriter, r *http.Request) {
	var user models.User
	params := mux.Vars(r)

	id, _ := primitive.ObjectIDFromHex(params["id"])

	err := db.UsersCollection.FindOne(context.TODO(), bson.M{"_id": id}).Decode(&user)

	if err != nil {
		if err == mongo.ErrNoDocuments {
			http.Error(w, fmt.Sprintf("Could not find user w/ id of %s", params["id"]), 400)
			return
		}

		log.Fatal(err)
	}

	json.NewEncoder(w).Encode(user)
}

func getUserByToken(w http.ResponseWriter, r *http.Request) {
	var user models.User

	headerToken := r.Header.Get("x-access-token")

	token, err := jwt.Parse(headerToken, func(token *jwt.Token) (interface{}, error) {
		if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
			return nil, fmt.Errorf("Unexpected signing method: %v", token.Header["alg"])
		}

		return []byte("secret"), nil
	})

	if err != nil {
		http.Error(w, err.Error(), 401)
		return
	}

	if _, ok := token.Claims.(jwt.Claims); !ok && !token.Valid {
		http.Error(w, err.Error(), 401)
		return
	}

	claims, ok := token.Claims.(jwt.MapClaims)

	if !ok && !token.Valid {
		return
	}

	id, ok := claims["user_id"]

	if !ok {
		http.Error(w, "Could not obtain user id.", 401)
		return
	}

	oid, _ := primitive.ObjectIDFromHex(id.(string))

	err = db.UsersCollection.FindOne(context.TODO(), bson.M{"_id": oid}).Decode(&user)

	if err != nil {
		log.Fatal(err)
		return
	}

	json.NewEncoder(w).Encode(user)
}

func login(w http.ResponseWriter, r *http.Request) {
	var user models.User
	var foundUser models.User

	json.NewDecoder(r.Body).Decode(&user)

	if user.Email == "" {
		http.Error(w, "Must provide an email.", 400)
		return
	} else {
		matched, err := regexp.Match(`^[a-zA-Z0-9.!#$%&'*+/=?^_{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)`, []byte(user.Email))

		if err != nil || !matched {
			http.Error(w, "Email is invalid.", 400)
			return
		}
	}

	err := db.UsersCollection.FindOne(context.TODO(), bson.M{"email": user.Email}).Decode(&foundUser)

	if err != nil {
		if err == mongo.ErrNoDocuments {
			http.Error(w, "No user found with this email.", 400)
			return
		}

		log.Fatal(err)
	}

	err = bcrypt.CompareHashAndPassword([]byte(foundUser.Password), []byte(user.Password))

	if err != nil {
		http.Error(w, "Incorrect password.", 400)
		return
	}

	token, err := utils.CreateToken(foundUser.Id.Hex())

	if err != nil {
		log.Fatal(err)
	}

	json.NewEncoder(w).Encode(token)
}

func register(w http.ResponseWriter, r *http.Request) {
	var user models.User

	json.NewDecoder(r.Body).Decode(&user)

	if user.Name == "" {
		http.Error(w, "Must provide a name.", 400)
		return
	}

	if user.Email == "" {
		http.Error(w, "Must provide an email.", 400)
		return
	} else {
		matched, err := regexp.Match(`^[a-zA-Z0-9.!#$%&'*+/=?^_{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)`, []byte(user.Email))

		if err != nil || !matched {
			http.Error(w, "Email is invalid.", 400)
			return
		}
	}

	if user.Password == "" {
		http.Error(w, "Must provide a password.", 400)
		return
	} else if len(user.Password) < 6 {
		http.Error(w, "Password must be at least 6 characters.", 400)
		return
	} else {
		hasUppercaseLetter := false
		hasNumber := false
		hasSymbol := false

		for _, char := range user.Password {
			if unicode.IsUpper(char) {
				hasUppercaseLetter = true
			} else if unicode.IsDigit(char) {
				hasNumber = true
			} else if unicode.IsSymbol(char) || unicode.IsPunct(char) {
				hasSymbol = true
			}
		}

		if !hasUppercaseLetter || !hasNumber || !hasSymbol {
			http.Error(w, "Password must have at least one uppercase letter, one digit and one symbol.", 400)
			return
		}
	}

	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(user.Password), 10)

	if err != nil {
		log.Fatal(err)
	}

	user.Id = primitive.NewObjectID()
	user.Password = string(hashedPassword)
	user.CreatedOn = time.Now()

	result, err := db.UsersCollection.InsertOne(context.TODO(), user)

	if err != nil {
		e := err.(mongo.WriteException)

		for _, we := range e.WriteErrors {
			if we.Code == 11000 {
				if strings.Contains(we.Message, `email_1 dup key`) {
					http.Error(w, "Email is unavailable.", 400)
					return
				}
			}
		}

		log.Fatal(err)
	}

	token, err := utils.CreateToken(result.InsertedID.(primitive.ObjectID).Hex())

	if err != nil {
		log.Fatal(err)
	}

	json.NewEncoder(w).Encode(token)
}

func updateUser(w http.ResponseWriter, r *http.Request) {
	var user models.User
	params := mux.Vars(r)

	json.NewDecoder(r.Body).Decode(&user)

	if user.Name == "" {
		http.Error(w, "Must provide a name.", 400)
		return
	}

	if user.Email == "" {
		http.Error(w, "Must provide an email.", 400)
		return
	} else {
		matched, err := regexp.Match(`^[a-zA-Z0-9.!#$%&'*+/=?^_{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)`, []byte(user.Email))

		if err != nil || !matched {
			http.Error(w, "Email is invalid.", 400)
			return
		}
	}

	id, _ := primitive.ObjectIDFromHex(params["id"])

	result, err := db.UsersCollection.UpdateOne(context.TODO(), bson.M{"_id": id}, bson.M{
		"$set": bson.M{
			"name":  user.Name,
			"email": user.Email,
		}})

	if err != nil {
		e := err.(mongo.WriteException)

		for _, we := range e.WriteErrors {
			if we.Code == 11000 {
				if strings.Contains(we.Message, `email_1 dup key`) {
					http.Error(w, "Email is unavailable.", 400)
					return
				}
			}
		}

		log.Fatal(err)
	}

	if result.MatchedCount == 0 {
		http.Error(w, fmt.Sprintf("Could not update user w/ id of %s", params["id"]), 400)
		return
	}

	err = db.UsersCollection.FindOne(context.TODO(), bson.M{"_id": id}).Decode(&user)

	if err != nil {
		log.Fatal(err)
	}

	json.NewEncoder(w).Encode(user)
}

func updateUserPassword(w http.ResponseWriter, r *http.Request) {
	var user models.User
	params := mux.Vars(r)
	var passwords map[string]interface{}

	json.NewDecoder(r.Body).Decode(&passwords)

	old := passwords["old"].(string)
	new := passwords["new"].(string)

	if new == "" {
		http.Error(w, "Must provide a password.", 400)
		return
	} else if len(new) < 6 {
		http.Error(w, "New password must be at least 6 characters.", 400)
		return
	} else {
		hasUppercaseLetter := false
		hasNumber := false
		hasSymbol := false

		for _, char := range new {
			if unicode.IsUpper(char) {
				hasUppercaseLetter = true
			} else if unicode.IsDigit(char) {
				hasNumber = true
			} else if unicode.IsSymbol(char) || unicode.IsPunct(char) {
				hasSymbol = true
			}
		}

		if !hasUppercaseLetter || !hasNumber || !hasSymbol {
			http.Error(w, "New password must have at least one uppercase letter, one digit and one symbol.", 400)
			return
		}
	}

	id, _ := primitive.ObjectIDFromHex(params["id"])

	err := db.UsersCollection.FindOne(context.TODO(), bson.M{"_id": id}).Decode(&user)

	if err != nil {
		if err == mongo.ErrNoDocuments {
			http.Error(w, fmt.Sprintf("Could not find user w/ id of %s", params["id"]), 400)
			return
		}

		log.Fatal(err)
	}

	err = bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(old))

	if err != nil {
		http.Error(w, "Incorrect password.", 400)
		return
	}

	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(new), 10)

	if err != nil {
		log.Fatal(err)
	}

	_, err = db.UsersCollection.UpdateOne(context.TODO(), bson.M{"_id": id}, bson.M{
		"$set": bson.M{
			"password": string(hashedPassword),
		}})

	user.Password = string(hashedPassword)

	json.NewEncoder(w).Encode(user)
}
