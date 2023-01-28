module Types exposing (Article, Profile, Tag)

import Time


type alias Tag =
    String


type alias Profile =
    { username : String
    , bio : String
    , image : String
    , following : Bool
    }


type alias Article =
    { slug : String
    , title : String
    , description : String
    , body : String
    , tagList : List Tag
    , createdAt : Time.Posix
    , updatedAt : Time.Posix
    , favorited : Bool
    , favoritesCount : Int
    , author : Profile
    }
