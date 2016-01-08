package reports

import (
    "encoding/json"
    "net/http"
)

func check(e error) {
    if e != nil {
        panic(e)
    }
}

func writeJSONResp(writer http.ResponseWriter, body interface{}, status int) {
    json_resp, _ := json.Marshal(body)
    writer.Header().Set("Content-Type", "text/json")
    writer.WriteHeader(status)
    writer.Write(json_resp)
}
