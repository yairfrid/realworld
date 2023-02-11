module Main exposing (..)

import Browser exposing (UrlRequest)
import Browser.Navigation as Nav
import Html exposing (Html, a, div, footer, i, li, nav, span, text, ul)
import Html.Attributes exposing (class, classList, href)
import Page exposing (..)
import Page.Home as Home
import Page.Login as Login
import Route exposing (..)
import Session exposing (Session)
import Url exposing (Url)


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        , onUrlRequest = LinkClicked
        , onUrlChange = UrlChanged
        }


init : () -> Url -> Nav.Key -> ( Model, Cmd msg )
init _ url key =
    changeRouteTo (Route.fromUrl url) (Redirect { key = key })


subscriptions : Model -> Sub Msg
subscriptions model =
    case model of
        Redirect _ ->
            Session.changes GotSession (toSession model)

        _ ->
            Sub.none


type Model
    = Home Home.Model
    | NewArticle
    | Settings
    | SignIn Login.Model
    | SignUp
    | NotFound Session
    | Redirect Session


type Msg
    = LinkClicked UrlRequest
    | UrlChanged Url
    | GotHomeMsg Home.Msg
    | GotSignInMsg Login.Msg
    | GotSession Session


toSession : Model -> Session
toSession model =
    case model of
        Redirect session ->
            session

        Home home ->
            Home.toSession home

        NewArticle ->
            Debug.todo "branch 'NewArticle' not implemented"

        Settings ->
            Debug.todo "branch 'Settings' not implemented"

        SignIn signIn ->
            Login.toSession signIn

        SignUp ->
            Debug.todo "branch 'SignUp' not implemented"

        NotFound session ->
            session


changeRouteTo : Maybe Route.Route -> Model -> ( Model, Cmd msg )
changeRouteTo route model =
    let
        _ =
            Debug.log "changeRouteTo" route

        session =
            toSession model
    in
    case route of
        Nothing ->
            ( NotFound session, Cmd.none )

        Just Route.Root ->
            ( model, Route.replaceUrl (Session.navKey (toSession model)) Route.Home )

        Just Route.Home ->
            ( Home (Home.init (toSession model)), Cmd.none )

        Just Route.NewArticle ->
            Debug.todo "branch 'Just NewArticle' not implemented"

        Just Route.Settings ->
            Debug.todo "branch 'Just Settings' not implemented"

        Just Route.SignIn ->
            ( SignIn (Login.init (toSession model)), Cmd.none )

        Just Route.SignUp ->
            Debug.todo "branch 'Just SignUp' not implemented"


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model ) of
        ( LinkClicked urlRequest, _ ) ->
            case urlRequest of
                Browser.Internal url ->
                    case url.fragment of
                        Nothing ->
                            -- If we got a link that didn't include a fragment,
                            -- it's from one of those (href "") attributes that
                            -- we have to include to make the RealWorld CSS work.
                            ( model, Cmd.none )

                        Just _ ->
                            ( model, Nav.pushUrl (Session.navKey (toSession model)) (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        ( UrlChanged url, _ ) ->
            changeRouteTo (Route.fromUrl url) model

        ( GotSession session, Redirect _ ) ->
            ( Redirect session
            , Route.replaceUrl (Session.navKey session) Route.Home
            )

        ( GotHomeMsg subMsg, Home home ) ->
            ( Home (Home.update subMsg home), Cmd.none )

        ( GotSignInMsg subMsg, SignIn signIn ) ->
            ( SignIn (Login.update subMsg signIn), Cmd.none )

        ( GotHomeMsg _, _ ) ->
            ( model, Cmd.none )

        ( GotSignInMsg _, _ ) ->
            ( model, Cmd.none )

        ( GotSession _, _ ) ->
            ( model, Cmd.none )


header : Page -> Html msg
header activePage =
    nav [ classList [ ( "navbar", True ), ( "navbar-light", True ) ] ]
        [ div [ class "container" ]
            [ a [ class "navbar-brand", href (Route.toUrl Route.Home) ]
                [ text "conduit" ]
            , ul [ classList [ ( "nav", True ), ( "navbar-nav", True ), ( "pull-xs-right", True ) ] ]
                [ li [ class "nav-item" ]
                    [ a [ classList [ ( "nav-link", True ), ( "active", activePage == Page.Home ) ], href (toUrl Route.Home) ]
                        [ text "Home" ]
                    ]
                , li [ class "nav-item" ]
                    [ a [ classList [ ( "nav-link", True ), ( "active", activePage == Page.NewArticle ) ], href (Route.toUrl Route.NewArticle) ]
                        [ i [ class "ion-compose" ] [], text "\u{00A0}New Article" ]
                    ]
                , li [ class "nav-item" ]
                    [ a [ classList [ ( "nav-link", True ), ( "active", activePage == Page.Settings ) ], href (Route.toUrl Route.Settings) ]
                        [ i [ class "ion-gear-a" ] [], text "\u{00A0}Settings" ]
                    ]
                , li [ class "nav-item" ]
                    [ a [ classList [ ( "nav-link", True ), ( "active", activePage == Page.SignIn ) ], href (Route.toUrl Route.SignIn) ]
                        [ text "Sign in" ]
                    ]
                , li [ class "nav-item" ]
                    [ a [ classList [ ( "nav-link", True ), ( "active", activePage == Page.SignUp ) ], href (Route.toUrl Route.SignUp) ]
                        [ text "Sign up" ]
                    ]
                ]
            ]
        ]


ftr : Html msg
ftr =
    footer []
        [ div [ class "container" ]
            [ a [ href (Route.toUrl Route.Home), class "logo-font" ] [ text "conduit" ]
            , span [ class "attribution" ]
                [ text "An interactive learning project from "
                , a [ href "https://thinkster.io" ] [ text "Thinkster" ]
                , text " Code design licensed under MIT."
                ]
            ]
        ]


template : Page -> List (Html msg) -> List (Html msg)
template activePage pageContent =
    header activePage :: pageContent ++ [ ftr ]


viewPage : (msg -> Msg) -> List (Html msg) -> List (Html Msg)
viewPage toMsg content =
    List.map (Html.map toMsg) content


view : Model -> Browser.Document Msg
view model =
    { title = "Conduit"
    , body =
        case model of
            Home m ->
                template Page.Home (viewPage GotHomeMsg (Home.view m))

            NewArticle ->
                Debug.todo "branch 'NewArticle' not implemented"

            Settings ->
                Debug.todo "branch 'Settings' not implemented"

            SignIn m ->
                template Page.SignIn (viewPage GotSignInMsg (Login.view m))

            SignUp ->
                Debug.todo "branch 'SignUp' not implemented"

            NotFound _ ->
                Debug.todo "branch 'NotFound _' not implemented"

            Redirect _ ->
                template Page.Other []
    }
