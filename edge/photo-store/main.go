package main

import (
	"io"
	"net/http"
	"os"
)

func main() {
	createImageHandler := http.HandlerFunc(createImage)
	
	http.Handle("/image", createImageHandler)
	http.ListenAndServe(":5431", nil)
}
func enableCors(w *http.ResponseWriter) {
	(*w).Header().Set("Access-Control-Allow-Origin", "*")
	(*w).Header().Set("Access-Control-Allow-Headers", "Content-Type")

}

func createImage(w http.ResponseWriter, request *http.Request) {
	enableCors(&w)
	err := request.ParseMultipartForm(32 << 20) // maxMemory 32MB
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		return
	}
	//Access the photo key - First Approach
	file, h, err := request.FormFile("photoTaken")
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		return
	}
	tmpfile, err := os.Create("./" + h.Filename)
	defer tmpfile.Close()
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}
	_, err = io.Copy(tmpfile, file)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	w.WriteHeader(200)
	return
}