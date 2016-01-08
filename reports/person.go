package reports

import (
    "github.com/gorilla/mux"
    // "fmt"
    "net/http"
    "gopkg.in/mgo.v2"
    "gopkg.in/mgo.v2/bson"
)

type PersonResponse struct {
    Person string `json:"person"`
    Places map[string]int `json:"places"`
    People map[string]int `json:"people"`
    Activities map[string]int `json:"activities"`
}

func getPersonInformation(person string, snapshots []Snapshot) PersonResponse {
    places := make(map[string]int)
    people := make(map[string]int)
    activities := make(map[string]int)

    for _, snapshot := range snapshots {
        for _, response := range snapshot.Responses {
            question := response.QuestionPrompt
            // handle places
            if question == "Where are you?" {
                places[response.LocationResponse.Text]++
            } else if question == "Who are you with?" {
                // handle people
                for _, token := range response.Tokens {
                    if token.Text != person {
                        people[token.Text]++
                    }
                }
            } else if question == "What are you doing?" {
                // handle activities
                for _, token := range response.Tokens {
                    activities[token.Text]++
                }
            }
        }
    }

    return PersonResponse{
        person,
        places,
        people,
        activities,
    }
}

func PersonHandler(writer http.ResponseWriter, request *http.Request) {
    person := mux.Vars(request)["personName"]
    session, err := mgo.Dial("10.11.12.13:27017")
    check(err)
    defer session.Close()
    c := session.DB("reports").C("snapshots")

    snapshots := make([]Snapshot, 1)
    // { responses: { $elemMatch: { tokens: { $elemMatch: { text: 'Deanna Dillard' } } } } }
    query := bson.M{
        "responses": bson.M{
            "$elemMatch": bson.M{
                "tokens": bson.M{
                    "$elemMatch": bson.M{
                        "text": person,
                    },
                },
            },
        },
    }

    c.Find(query).All(&snapshots)
    resp := getPersonInformation(person, snapshots)
    writeJSONResp(writer, resp, 200)
}
