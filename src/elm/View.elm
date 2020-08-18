module View exposing (view)

import Browser exposing (Document)
import Commons.NavBar as NavBar
import Html exposing (Html, div, footer, img, span, text)
import Html.Attributes exposing (class, classList, src)
import Model exposing (Model, Msg(..))
import Pages.Accordion as Accordion
import Pages.Button as Button
import Pages.Component as ComponentPage
import Pages.Home as Home
import Pages.Loader as LoaderPage
import Pages.NotFound as NotFound
import Route


view : Model -> Document Msg
view model =
    { title = "Pyxis"
    , body =
        [ viewBody model
        ]
    }


viewBody : Model -> Html Msg
viewBody model =
    div
        [ class "pyxis" ]
        [ div
            [ class "pyxis__navbar", classList [ ( "pyxis__navbar--open", model.isMenuOpen ) ] ]
            [ NavBar.view model ]
        , div
            [ class "pyxis__content" ]
            [ div
                [ class "pyxis-page" ]
                [ div
                    [ class "pyxis-page__content" ]
                    [ viewRouter model ]
                , footer [ class "pyxis-page__footer" ]
                    [ viewBrandLogo ]
                ]
            ]
        ]


viewBrandLogo : Html Msg
viewBrandLogo =
    div
        [ class "brand-logo" ]
        [ img
            [ class "brand-logo__image"
            , src "public/logo-prima.svg"
            ]
            []
        , span
            [ class "brand-logo__label" ]
            [ text "© Prima Assicurazioni S.p.A." ]
        ]


viewRouter : Model -> Html Msg
viewRouter model =
    case model.currentRoute of
        Route.Homepage ->
            Home.view model

        Route.Component Route.Accordion ->
            Html.map AccordionMsg <| Accordion.view model.accordionModel

        Route.Component Route.Button ->
            Html.map ButtonMsg <| Button.view model.buttonModel

        Route.Component Route.Loader ->
            Html.map LoaderMsg <| LoaderPage.view model.loaderModel

        Route.Component _ ->
            div []
                [ ComponentPage.view
                    { title = "Component"
                    , description = "Page under construction"
                    , specsList = [ "..." ]
                    , viewComponent = \_ -> text "<Preview>"
                    , sections = []
                    }
                ]

        Route.NotFound ->
            NotFound.view
