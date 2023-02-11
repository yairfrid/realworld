module Page.SignIn exposing (Model, Msg, init, toSession, update, view)

import Html exposing (Html, a, button, div, fieldset, form, h1, input, li, p, text, ul)
import Html.Attributes exposing (class, href, placeholder, type_, value)
import Html.Events exposing (onInput, onSubmit)
import Route
import Session exposing (Session)


type alias Model =
    { session : Session
    , email : String
    , password : String
    , errors : List String
    }


toSession : Model -> Session
toSession model =
    model.session


type Msg
    = SignInSubmitted
    | EmailInputTyped String
    | PasswordInputTyped String


init : Session -> Model
init session =
    { session = session
    , email = ""
    , password = ""
    , errors = []
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
        SignInSubmitted ->
            Debug.todo "SignInSubmitted"

        EmailInputTyped email ->
            { model | email = email }

        PasswordInputTyped password ->
            { model | password = password }


viewErrors : List String -> List (Html Msg)
viewErrors errors =
    List.map (\error -> li [] [ text error ]) errors


view : Model -> List (Html Msg)
view model =
    [ div
        [ class "auth-page"
        ]
        [ div
            [ class "container page"
            ]
            [ div [ class "row" ]
                [ div
                    [ class "col-md-6 offset-md-3 col-xs-12"
                    ]
                    [ h1
                        [ class "text-xs-center"
                        ]
                        [ text "Sign in" ]
                    , p
                        [ class "text-xs-center"
                        ]
                        [ a [ href (Route.toUrl Route.SignUp) ] [ text "Don't have an account?" ] ]
                    , ul
                        [ class "error-messages"
                        ]
                        (viewErrors model.errors)
                    , form
                        [ onSubmit SignInSubmitted
                        ]
                        [ fieldset
                            [ class "form-group"
                            ]
                            [ input
                                [ class "form-control form-control-lg"
                                , type_ "email"
                                , placeholder "Email"
                                , value model.email
                                , onInput EmailInputTyped
                                ]
                                []
                            ]
                        , fieldset
                            [ class "form-group"
                            ]
                            [ input
                                [ class "form-control form-control-lg"
                                , type_ "password"
                                , placeholder "Password"
                                , value model.password
                                , onInput PasswordInputTyped
                                ]
                                []
                            ]
                        , button
                            [ class "btn btn-lg btn-primary pull-xs-right"
                            , href ""
                            ]
                            [ text "Sign in" ]
                        ]
                    ]
                ]
            ]
        ]
    ]
