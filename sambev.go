package main

import (
    "github.com/gorilla/mux"
    "net/http"
    "github.com/reports"
)

func main() {
    r := mux.NewRouter()
    r.HandleFunc("/reports/totals", reports.ReportTotalHandler)
    r.HandleFunc("/person/{personName}", reports.PersonHandler)
    http.Handle("/", r)
    http.ListenAndServe(":6789", nil)
}
