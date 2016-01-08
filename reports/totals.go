package reports

import (
    "net/http"
    "strconv"
    "gopkg.in/mgo.v2"
    "gopkg.in/mgo.v2/bson"
)

type TotalResponse struct {
    TotalDays int `json:"days"`
    TotalReports int `json:"reports"`
    AvgPerDay float32 `json:"avgPerDay"`
    TotalPeople int `json:"people"`
    TotalLocations int `json:"locations"`
    TotalCoffees int `json:"coffees"`
    CoffeesPerDay float32 `json:"coffeesPerDay"`
}

/**
 * Iterate over the snapshots and aggregate total data
 */
func getTotals(snapshots []Snapshot) TotalResponse {
    reports := len(snapshots)
    days := make(map[string]int)
    people := make(map[string]int)
    locations := make(map[string]int)
    coffees := 0

    for _, snapshot := range snapshots {
        // Count people
        date := snapshot.Date[:10]
        days[date]++

        for _, response := range snapshot.Responses {
            question := response.QuestionPrompt
            // Count people
            if question == "Who are you with?" {
                for _, token := range response.Tokens {
                    people[token.Text]++
                }
            } else if question == "Where are you?" {
                // count locations
                locations[response.LocationResponse.Text]++
            } else if question == "How many coffees did you have today?" {
                // count coffees
                amount, err := strconv.Atoi(response.NumericResponse)
                if err == nil {
                    coffees += amount
                }
            }
        }
    }

    return TotalResponse{
        TotalDays: len(days),
        TotalReports: reports,
        TotalPeople: len(people),
        TotalLocations: len(locations),
        AvgPerDay: float32(reports)/float32(len(days)),
        TotalCoffees: coffees,
        CoffeesPerDay: float32(coffees)/float32(len(days)),
    }
}

/**
 * HTTP handler to get the total reports, days, avg/day, tokens, locations,
 * people, and other things.
 */
func ReportTotalHandler(writer http.ResponseWriter, request *http.Request) {
    session, err := mgo.Dial("10.11.12.13:27017")
    check(err)
    defer session.Close()

    snapshots := make([]Snapshot, 1)

    c := session.DB("reports").C("snapshots")
    c.Find(bson.M{}).All(&snapshots)

    resp := getTotals(snapshots)

    writeJSONResp(writer, resp, 200)
}
