module Home exposing (CurrentFeed(..), Model, Msg, view)

import Html exposing (Html, a, button, div, h1, i, img, li, p, span, text, ul)
import Html.Attributes exposing (class, classList, href, src)
import Html.Events exposing (onClick)
import Types exposing (Article, Tag)


type Msg
    = TagClicked Tag


type CurrentFeed
    = Personal
    | Global


type alias Model =
    { currentFeed : CurrentFeed
    , articles : List Article
    , tags : List Tag
    }



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
        , a [ href "", class "preview-link" ]
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


view : Model -> Html Msg
view model =
    div [ class "home-page" ]
        [ banner
        , div [ class "container page" ]
            [ div [ class "row" ]
                [ div [ class "col-md-9" ]
                    (feedToggle model :: articlePreviews model)
                , popularTags model
                ]
            ]
        ]
