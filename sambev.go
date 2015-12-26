package main

import (
    "github.com/gorilla/mux"
    "net/http"
    "github.com/reports"
)

func main() {
    r := mux.NewRouter()
    r.HandleFunc("/reports/totals", reports.ReportTotalHandler)
    http.Handle("/", r)
    http.ListenAndServe(":6789", nil)
}
