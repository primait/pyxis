module Pyxis.Components.Jumbotron.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (alt, attribute, class, classList, src, type_)
import Pyxis.Components.Jumbotron.Model as Model exposing (Image, Jumbotron, Model, Msg(..))
import Pyxis.Helpers exposing (picture)
import Pyxis.ViewHelpers exposing (componentShowdown, componentTitle, divider, renderHTMLContent)


view : Model -> List (Html Msg)
view model =
    [ componentTitle [ text "Jumbotron" ]
    , divider
    ]
        ++ List.map (componentShowdown "Jumbotron with paragraph" "jumbotronWithParagraph" InspectHtml << renderJumbotron) model.jumbotrons


renderJumbotron : Jumbotron -> List (Html Msg)
renderJumbotron model =
    [ div [ class "o-jumbotron a-container" ]
        [ div [ class "o-jumbotron__wrapper--left" ] <|
            List.append
                [ h1 [ class "o-jumbotron__title" ] [ text model.title ]
                , h2 [ class "o-jumbotron__subtitle" ] [ text model.subtitle ]
                ]
                (Maybe.withDefault [] (Maybe.map renderHTMLContent model.content))
        , div [ class "o-jumbotron__wrapper--right" ] [ Maybe.withDefault (div [] []) <| Maybe.map renderImage model.image ]
        ]
    ]


renderImage : Image -> Html Msg
renderImage image =
    let
        stripExtension : String -> Maybe String
        stripExtension str =
            List.head <| String.split "." str

        ext =
            (Maybe.withDefault "" << Maybe.map ((++) ".webp") << stripExtension) image
    in
    picture [ class "o-jumbotron__picture" ]
        [ source [ attribute "srcset" ext, type_ "image/webp" ] []
        , source [ attribute "srcset" image, type_ "image/jpeg" ] []
        , img [ class "o-jumbotron__picture__image", src image, alt "alt-placeholder" ] []
        ]