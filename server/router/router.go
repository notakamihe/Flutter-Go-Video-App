package router

import (
	"net/http"

	"github.com/gorilla/mux"
)

func NewRouter() *mux.Router {
	router := mux.NewRouter()
	subrouter := router.PathPrefix("/api").Subrouter()

	router.PathPrefix("/uploads").Handler(http.StripPrefix("/uploads", http.FileServer(http.Dir("uploads"))))

	addUserSubroutes(subrouter)
	addVideoSubroutes(subrouter)

	return router
}
