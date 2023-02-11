module Session exposing (Session, changes, navKey)

import Browser.Navigation as Nav


type alias Session =
    { key : Nav.Key
    }


navKey : Session -> Nav.Key
navKey session =
    session.key


changes : (Session -> msg) -> Session -> Sub msg
changes _ _ =
    Sub.none
