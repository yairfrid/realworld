module Page.Home exposing (CurrentFeed(..), Model, Msg, init, toSession, update, view)

import Html exposing (Html, a, button, div, h1, i, img, li, p, span, text, ul)
import Html.Attributes exposing (class, classList, href, src)
import Html.Events exposing (onClick)
import Session exposing (Session)
import Time exposing (millisToPosix)
import Types exposing (Article, Tag)


type Msg
    = TagClicked Tag


type CurrentFeed
    = Personal
    | Global


init : Session -> Model
init session =
    { session = session
    , currentFeed = Personal
    , articles =
        [ { slug = "my-slug"
          , title = "If we quantify the alarm, we can get to the FTP pixel through the online SSL interface!"
          , description = "Omnis perspiciatis qui quia commodi sequi modi. Nostrum quam aut cupiditate est facere omnis possimus. Tenetur similique nemo illo soluta molestias facere quo. Ipsam totam facilis delectus nihil quidem soluta vel est omnis."
          , body = "My body"
          , tagList = [ "tag" ]
          , createdAt = millisToPosix 0
          , updatedAt = millisToPosix 0
          , favorited = False
          , favoritesCount = 13
          , author =
                { username = "user"
                , bio = "bio"
                , image = "http://i.imgur.com/Qr71crq.jpg"
                , following = True
                }
          }
        ]
    , tags = [ "programming", "javascript", "emberjs", "angularjs", "react", "mean", "node", "rails" ]
    }


type alias Model =
    { session : Session
    , currentFeed : CurrentFeed
    , articles : List Article
    , tags : List Tag
    }


toSession : Model -> Session
toSession model =
    model.session



-- UPDATE


update : Msg -> Model -> Model
update msg _ =
    case msg of
        TagClicked _ ->
            Debug.todo "implement TagClicked"



-- VIEW


banner : Html msg
banner =
    -- TODO(yairfrid) hide banner if not logged in
    div [ class "banner" ]
        [ div [ class "container" ]
            [ h1 [ class "logo-font" ] [ text "conduit" ], p [] [ text "A place to share your knowledge." ] ]
        ]


feedToggle : Model -> Html msg
feedToggle model =
    div [ class "feed-toggle" ]
        [ ul [ class "nav nav-pills outline-active" ]
            [ li [ class "nav-item" ]
                -- TODO(yairfrid) Disable Your Feed only if not logged in..
                [ a [ classList [ ( "nav-link", True ), ( "disabled", model.currentFeed /= Personal ), ( "enabled", model.currentFeed == Personal ) ] ] [ text "Your Feed" ] ]
            , li [ class "nav-item" ]
                [ a [ classList [ ( "nav-link", True ), ( "disabled", model.currentFeed /= Global ), ( "enabled", model.currentFeed == Global ) ] ] [ text "Global Feed" ] ]
            ]
        ]


articlePreview : Article -> Html msg
articlePreview article =
    div [ class "article-preview" ]
        [ div [ class "article-meta" ]
            -- TODO(yairfrid) should link creation be in another place?
            [ a [ href ("#/@" ++ article.author.username) ] [ img [ src article.author.image ] [] ]
            , div [ class "info" ]
                [ a [ href ("#/@" ++ article.author.username), class "author" ] [ text article.author.username ]

                -- TODO(yairfrid) parse time correctly
                , span [ class "date" ] [ text "January 20th" ]
                ]
            , button [ class "btn btn-outline-primary btn-sm pull-xs-right" ]
                [ i [ class "ion-heart" ] []
                , text (String.fromInt article.favoritesCount)
                ]
            ]

        -- TODO(yairfrid) move /article to a proper route
        , a [ href ("#/article/" ++ article.slug), class "preview-link" ]
            [ h1 [] [ text article.title ]
            , p [] [ text article.description ]
            , span [] [ text "Read more..." ]
            ]
        ]


articlePreviews : Model -> List (Html msg)
articlePreviews model =
    List.map articlePreview model.articles


tagList : List Tag -> List (Html Msg)
tagList tags =
    List.map (\tag -> a [ href "", class "tag-pill tag-default", onClick (TagClicked tag) ] [ text tag ]) tags


popularTags : Model -> Html Msg
popularTags model =
    div [ class "col-md-3" ]
        [ div [ class "sidebar" ]
            [ p [] [ text "Popular Tags" ]
            , div [ class "tag-list" ] (tagList model.tags)
            ]
        ]


view : Model -> List (Html Msg)
view model =
    [ div [ class "home-page" ]
        [ banner
        , div [ class "container page" ]
            [ div [ class "row" ]
                [ div [ class "col-md-9" ]
                    (feedToggle model :: articlePreviews model)
                , popularTags model
                ]
            ]
        ]
    ]
