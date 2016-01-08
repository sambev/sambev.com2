package reports

type ReporterExport struct {
    Snapshots []Snapshot
}

type Snapshot struct {
    Steps int
    Responses []Response
    Battery float64
    SectionIdentifier string
    Audio Audio
    Backgroud int
    Date string
    UniqueIdentifier string
    Location Location
    Weather Weather
    Connection int
    Altitude Altitude
    ReportImpetus int
    Draft int
}

type Response struct {
    LocationResponse LocationResponse `bson:",omitempty"`
    NumericResponse string `bson:",omitempty"`
    AnsweredOptions []string `bson:",omitempty"`
    Tokens []Token `bson:",omitempty"`
    UniqueIdentifier string
    QuestionPrompt string
}

type LocationResponse struct {
    Text string
    Location Location
    UniqueIdentifier string
    FoursquareVenueId string
}

type Token struct {
    UniqueIdentifier string
    Text string
}

type Audio struct {
    Avg float64
    Peak float64
    UniqueIdentifier string
}

type Location struct {
    Speed int
    Placemark Placemark
    Timestamp string
    Longitude float64
    Latitude float64
    VerticalAccuracy float64
    UniqueIdentifier string
    Course int
    Altitude float64
    HorizontalAccuracy int
}

type Placemark struct {
    SubAdministrativeArea string
    SubLocality string
    Thoroughfare string
    AdministrativeArea string
    UniqueIdentifier string
    SubThoroughfare string
    PostalCode string
    Region string
    Country string
    Locality string
    Name string
}

type Weather struct {
    RelativeHumidity string
    VisibilityKM float64
    TempC float64
    UniqueIdentifier string
    PrecipTodayIn int
    WindKPH int
    WindDegrees int
    Latitude float64
    StationID string
    VisibilityMi int
    PressureIn float64
    PressureMb int
    FeelslikeF int
    TempF float64
    PrecipTodayMetric int
    WindGustKPH float64
    WindDirection string
    DewpointC int
    Uv int
    Weather string
    WindGustMPH int
    WindMPH int
}

type Altitude struct {
    GpsAltitudeFromLocation float64
    UniqueIdentifier string
    GpsRawAltitude float64
}


