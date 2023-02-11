module Route exposing (Route(..), fromUrl, replaceUrl, toUrl)

import Browser.Navigation as Nav
import Url exposing (Url)


type Route
    = Root
    | Home
    | NewArticle
    | Settings
    | SignIn
    | SignUp


fromUrl : Url -> Maybe Route
fromUrl url =
    case url.fragment of
        Nothing ->
            Just Root

        Just "" ->
            Just Root

        Just "/" ->
            Just Home

        Just "/editor" ->
            Just NewArticle

        Just "/settings" ->
            Just Settings

        Just "/login" ->
            Just SignIn

        Just "/register" ->
            Just SignUp

        _ ->
            let
                _ =
                    Debug.log "fromUrl fragment" url.fragment
            in
            Nothing


toUrl : Route -> String
toUrl route =
    "#/"
        ++ (case route of
                Root ->
                    ""

                Home ->
                    ""

                NewArticle ->
                    "editor"

                Settings ->
                    "settings"

                SignIn ->
                    "login"

                SignUp ->
                    "register"
           )


replaceUrl : Nav.Key -> Route -> Cmd msg
replaceUrl key route =
    Nav.replaceUrl key (toUrl route)
