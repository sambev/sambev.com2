package main

import (
    "github.com/gorilla/mux"
    "net/http"
    "sambev.com/reports"
)

func main() {
    r := mux.NewRouter()

    r.HandleFunc("/reports/totals", reports.ReportTotalHandler)
    r.HandleFunc("/people/{personName}", reports.PersonHandler)
    r.PathPrefix("/").Handler(http.FileServer(http.Dir("static")))

    http.ListenAndServe(":6789", r)
}
