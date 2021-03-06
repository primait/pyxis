module Pyxis.Page.Button exposing (Model, Msg(..), initialModel, update, view)

import Dict exposing (Dict)
import Html exposing (Attribute, Html, article, div, h1, h2, h5, li, p, section, text, ul)
import Html.Attributes exposing (class)
import Prima.Pyxis.Button as Button
import Prima.Pyxis.ButtonGroup as ButtonGroup
import Pyxis.DosAndDonts
import Pyxis.Page.Button.Ports as ButtonPorts
import Pyxis.TabbedContainer as TabbedContainer
import Pyxis.UpdateHelpers as UH


type Msg
    = AskInnerHTML String
    | ClickLink
    | ReceivedInnerHTML { target : String, innerHTML : String }
    | TabbedContainerUpdate String TabbedContainer.State


type ButtonVariant
    = Callout
    | Primary
    | Secondary
    | Tertiary


type InsetVariant
    = InsetLight
    | InsetDark
    | InsetBrand


type ButtonGroupVariant
    = SpaceBetween
    | SpaceEvenly
    | SpaceAround
    | Centered
    | ContentStart
    | ContentEnd
    | CoverFluid


type alias ButtonSampleSection =
    { sectionClass : String
    , headerText : String
    , insetVariants : List InsetVariant
    , buttonVariant : ButtonVariant
    , dos : List String
    , donts : List String
    }


type alias Model =
    { tabbedContainerStates : Dict String TabbedContainer.State
    , receivedInnerHTMLs :
        Dict String String
    }


initialModel : Model
initialModel =
    { tabbedContainerStates = Dict.empty
    , receivedInnerHTMLs = Dict.empty
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ClickLink ->
            model
                |> UH.withoutCmds

        TabbedContainerUpdate slug newTabbedContainerState ->
            { model
                | tabbedContainerStates = Dict.insert slug newTabbedContainerState model.tabbedContainerStates
            }
                |> UH.withoutCmds

        AskInnerHTML target ->
            model
                |> UH.withCmds [ ButtonPorts.requestInnerHTML target ]

        ReceivedInnerHTML { target, innerHTML } ->
            { model
                | receivedInnerHTMLs = Dict.insert target innerHTML model.receivedInnerHTMLs
            }
                |> UH.withoutCmds


view : Model -> Html Msg
view model =
    article []
        (List.concat
            [ [ sectionIntro ]
            , List.map
                (renderButtonSampleSection model)
                [ sectionCallout
                , sectionPrimary
                , sectionSecondary
                , sectionTertiary
                ]
            , [ sectionButtonGroup model ]
            , [ sectionButtonGroupCoverFluid model ]
            ]
        )


sectionIntro : Html Msg
sectionIntro =
    section [ class "page-button__section-intro" ]
        [ h1 [ class "page-button__heading" ]
            [ text "Component" ]
        , p [ class "page-button__section-intro__p" ]
            [ text "Aggiungere la classe a-btn con i suoi vari modificatori per ottenere un bottone di dimensioni standard. Un bottone standard di default si dispone automaticamente al centro orizzontale del suo elenento padre. Le varianti dark sono visibili correttamente solo su un background scuro. Quando ?? necessario impilare pi?? bottoni in uno stesso contenuto ?? opportuno utilizzare la classe m-btnGroup e le sue varianti."
            ]
        , div [ class "page-button__section-intro__button-primer" ]
            [ inset InsetLight
                [ class "page-button__section-intro__button-primer__sample" ]
                [ [ Button.callOut "BUTTON" ]
                    |> ButtonGroup.create
                    |> ButtonGroup.withAlignmentCentered
                    |> ButtonGroup.render
                ]
            , div [ class "page-button__section-intro__button-primer__specs" ]
                [ h5 []
                    [ text "SPECIFICHE TECNICHE" ]
                , ul [ class "page-button__section-intro__button-primer__specs__ul" ]
                    [ li [] [ text "Font uppercase" ]
                    , li [] [ text "Font family: Heavy" ]
                    , li [] [ text "Letter spacing: 1px" ]
                    ]
                ]
            ]
        ]


sectionCallout : ButtonSampleSection
sectionCallout =
    { sectionClass = "page-button__section-callout"
    , headerText = "Call Out Button"
    , insetVariants = [ InsetLight, InsetDark ]
    , buttonVariant = Callout
    , dos =
        [ "Il pulsante call out comunica grande enfasi ed ?? riservato per incoraggiare azioni molto importanti come la funzione Procedi nel flusso."
        , "Non esiste uno stile tiny per questo pulsante perch?? ?? pensato per essere intenzionalmente prominente."
        ]
    , donts =
        [ "Dovrebbe esserci solo un pulsante Call out per pagina."
        , "Non utilizzare il pulsante Call out su background on gradient color"
        ]
    }


sectionPrimary : ButtonSampleSection
sectionPrimary =
    { sectionClass = "page-button__section-primary"
    , headerText = "Primary Button"
    , insetVariants = [ InsetLight, InsetDark, InsetBrand ]
    , buttonVariant = Primary
    , dos =
        [ "Dovrebbe essere usato al posto di un pulsante cta quando l'azione richiede meno rilievo."
        , "Pu?? essere utilizzato in prossimit?? di pulsanti di Secondary e Tertiary."
        ]
    , donts =
        [ "Non dovr?? essere posizionato in prossimit?? del pulsante Call out."
        ]
    }


sectionSecondary : ButtonSampleSection
sectionSecondary =
    { sectionClass = "page-button__section-secondary"
    , headerText = "Secondary Button"
    , insetVariants = [ InsetLight, InsetDark, InsetBrand ]
    , buttonVariant = Secondary
    , dos =
        [ "Il pulsante secondario ?? per scarsa enfasi."
        , "Pu?? essere utilizzato in prossimit?? di altri pulsanti di Primary, Secondary e Tertiary."
        ]
    , donts =
        [ "Non dovr?? essere posizionato in prossimit?? del pulsante Call out."
        ]
    }


sectionTertiary : ButtonSampleSection
sectionTertiary =
    { sectionClass = "page-button__section-tertiary"
    , headerText = "Tertiary Button"
    , insetVariants = [ InsetLight, InsetDark, InsetBrand ]
    , buttonVariant = Tertiary
    , dos =
        [ "Il pulsante secondario ?? per scarsa enfasi.??????"
        , "Pu?? essere utilizzato in prossimit?? di altri pulsanti di Primary, Secondary e Tertiary."
        ]
    , donts =
        [ "Non dovr?? essere posizionato in prossimit?? del pulsante Call out."
        ]
    }


renderButtonSampleSection : Model -> ButtonSampleSection -> Html Msg
renderButtonSampleSection model sampleSection =
    section [ class sampleSection.sectionClass ]
        (List.concat
            [ [ h2
                    [ class "page-button__heading" ]
                    [ text sampleSection.headerText ]
              ]
            , List.map (renderButtonSampleTabbedContainer model sampleSection.buttonVariant) sampleSection.insetVariants
            , [ Pyxis.DosAndDonts.dosAndDonts { dos = sampleSection.dos, donts = sampleSection.donts } ]
            ]
        )


renderButtonSampleTabbedContainer : Model -> ButtonVariant -> InsetVariant -> Html Msg
renderButtonSampleTabbedContainer model buttonVariant insetVariant =
    let
        slug =
            getButtonSampleSlug buttonVariant insetVariant

        buttonCreator =
            buttonVariantToCreator buttonVariant
    in
    TabbedContainer.view
        (TabbedContainerUpdate slug)
        (model.tabbedContainerStates
            |> Dict.get slug
            |> Maybe.withDefault TabbedContainer.init
        )
        [ { label = "PREVIEW"
          , content =
                inset insetVariant
                    []
                    [ div [ class "page-button__preview-container" ]
                        [ div [ class "page-button__preview-container__label" ]
                            [ div [ class "fw-heavy" ] [ text "COMPONENT" ]
                            , div [] [ text (insetVariantToExplanation insetVariant) ]
                            ]
                        , [ buttonCreator "LARGE BUTTON"
                          , buttonCreator "DISABLED BUTTON" |> Button.withDisabled True
                          , buttonCreator "SMALL BUTTON" |> Button.withSmallSize
                          ]
                            |> ButtonGroup.create
                            |> ButtonGroup.withAlignmentSpaceBetween
                            |> ButtonGroup.withId slug
                            |> ButtonGroup.render
                        ]
                    ]
          }
        , { label = "</> CODE"
          , content =
                inset InsetLight
                    []
                    [ renderSampleInnerHTML model slug
                    ]
          }
        ]


buttonGroupVariantToModifier : ButtonGroupVariant -> (ButtonGroup.Config Msg -> ButtonGroup.Config Msg)
buttonGroupVariantToModifier buttonGroupVariant =
    case buttonGroupVariant of
        SpaceBetween ->
            ButtonGroup.withAlignmentSpaceBetween

        SpaceEvenly ->
            ButtonGroup.withAlignmentSpaceEvenly

        SpaceAround ->
            ButtonGroup.withAlignmentSpaceAround

        Centered ->
            ButtonGroup.withAlignmentCentered

        ContentStart ->
            ButtonGroup.withAlignmentContentStart

        ContentEnd ->
            ButtonGroup.withAlignmentContentEnd

        CoverFluid ->
            ButtonGroup.withAlignmentCoverFluid


renderButtonGroupSampleTabbedContainer : Model -> ButtonGroupVariant -> Html Msg
renderButtonGroupSampleTabbedContainer model buttonGroupVariant =
    let
        slug =
            getButtonGroupSampleSlug buttonGroupVariant

        buttonGroupModifier =
            buttonGroupVariantToModifier buttonGroupVariant
    in
    TabbedContainer.view
        (TabbedContainerUpdate slug)
        (model.tabbedContainerStates
            |> Dict.get slug
            |> Maybe.withDefault TabbedContainer.init
        )
        [ { label = "PREVIEW"
          , content =
                inset InsetLight
                    []
                    [ div [ class "page-button__preview-container" ]
                        [ div [ class "page-button__preview-container__label" ]
                            [ div [ class "fw-heavy" ] [ text "COMPONENT" ]
                            , div [] [ text slug ]
                            ]
                        , div [ class "page-button__preview-container__buttons" ]
                            [ [ Button.primary "LARGE BUTTON"
                              , Button.primary "LARGE BUTTON"
                              , Button.primary "LARGE BUTTON"
                              ]
                                |> ButtonGroup.create
                                |> buttonGroupModifier
                                |> ButtonGroup.withId slug
                                |> ButtonGroup.render
                            ]
                        ]
                    ]
          }
        , { label = "</> CODE"
          , content =
                inset InsetLight
                    []
                    [ renderSampleInnerHTML model slug
                    ]
          }
        ]


renderSampleInnerHTML : Model -> String -> Html Msg
renderSampleInnerHTML model slug =
    model.receivedInnerHTMLs
        |> Dict.get slug
        |> Maybe.map text
        |> Maybe.withDefault
            (Button.primary "Show code"
                |> Button.withOnClick (AskInnerHTML slug)
                |> Button.render
            )


getButtonSampleSlug : ButtonVariant -> InsetVariant -> String
getButtonSampleSlug buttonVariant insetVariant =
    buttonVariantToSlug buttonVariant ++ "_" ++ insetVariantToSlug insetVariant


getButtonGroupSampleSlug : ButtonGroupVariant -> String
getButtonGroupSampleSlug buttonGroupVariant =
    case buttonGroupVariant of
        SpaceBetween ->
            "space-between"

        SpaceEvenly ->
            "space-evenly"

        SpaceAround ->
            "space-around"

        Centered ->
            "centered"

        ContentStart ->
            "content-start"

        ContentEnd ->
            "content-end"

        CoverFluid ->
            "cover-fluid"


buttonVariantToSlug : ButtonVariant -> String
buttonVariantToSlug buttonVariant =
    case buttonVariant of
        Callout ->
            "callout"

        Primary ->
            "primary"

        Secondary ->
            "secondary"

        Tertiary ->
            "tertiary"


buttonVariantToCreator : ButtonVariant -> String -> Button.Config Msg
buttonVariantToCreator buttonVariant =
    case buttonVariant of
        Callout ->
            Button.callOut

        Primary ->
            Button.primary

        Secondary ->
            Button.secondary

        Tertiary ->
            Button.tertiary


insetVariantToSlug : InsetVariant -> String
insetVariantToSlug insetVariant =
    case insetVariant of
        InsetLight ->
            "light"

        InsetDark ->
            "dark"

        InsetBrand ->
            "brand"


insetVariantToExplanation : InsetVariant -> String
insetVariantToExplanation insetVariant =
    case insetVariant of
        InsetLight ->
            "on light color"

        InsetDark ->
            "on dark color"

        InsetBrand ->
            "on brand gradient"


sectionButtonGroup : Model -> Html Msg
sectionButtonGroup model =
    section [ class "page-button__section-button-group" ]
        [ h2 [] [ text "Button Group" ]
        , renderButtonGroupSampleTabbedContainer model SpaceBetween
        , renderButtonGroupSampleTabbedContainer model SpaceEvenly
        , renderButtonGroupSampleTabbedContainer model SpaceAround
        , renderButtonGroupSampleTabbedContainer model Centered
        , renderButtonGroupSampleTabbedContainer model ContentStart
        , renderButtonGroupSampleTabbedContainer model ContentEnd
        ]


sectionButtonGroupCoverFluid : Model -> Html Msg
sectionButtonGroupCoverFluid model =
    section [ class "page-button__section-button-group-cover-fluid" ]
        [ h2 [] [ text "Button Group Cover Fluid" ]
        , TabbedContainer.view
            (TabbedContainerUpdate "single-cover-fluid")
            (model.tabbedContainerStates
                |> Dict.get "single-cover-fluid"
                |> Maybe.withDefault TabbedContainer.init
            )
            [ { label = "PREVIEW"
              , content =
                    inset InsetLight
                        []
                        [ div [ class "page-button__preview-container" ]
                            [ div [ class "page-button__preview-container__label" ]
                                [ div [ class "fw-heavy" ] [ text "COMPONENT" ]
                                , div [] [ text "single-cover-fluid" ]
                                ]
                            , div [ class "page-button__preview-container__buttons" ]
                                [ [ Button.primary "LARGE BUTTON"
                                  ]
                                    |> ButtonGroup.create
                                    |> ButtonGroup.withAlignmentCoverFluid
                                    |> ButtonGroup.withId "single-cover-fluid"
                                    |> ButtonGroup.render
                                ]
                            ]
                        ]
              }
            , { label = "</> CODE"
              , content =
                    inset InsetLight
                        []
                        [ renderSampleInnerHTML model "single-cover-fluid"
                        ]
              }
            ]
        , renderButtonGroupSampleTabbedContainer model CoverFluid
        , Pyxis.DosAndDonts.dosAndDonts
            { dos =
                [ "Un bottone all'interno di un gruppo fluido ha una dimensione massima che non dipende dal testo, in caso di shrink oltre la sua dimensione prevista per mantenerlo su una linea il testo potr?? scendere su un massimo di due righe e poi verr?? tagliato"
                , "I margini automatici sono supportati fino a un massimo di 4 bottoni e funziona correttamente solo all'interno di un a-container o a-containerFluid diretto"
                , "Si pu?? utilizzare questa classe in unione a un container per realizzare bottoni singoli di larghezza arbitraria"
                , "Nel caso di contenitori innestati ?? necessario sovrascrivere le media query di margine."
                ]
            , donts = []
            }
        ]


inset :
    InsetVariant
    -> List (Attribute msg)
    -> List (Html msg)
    -> Html msg
inset insetVariant attributes contents =
    let
        insetDivClass =
            case insetVariant of
                InsetLight ->
                    "page-button__inset-light"

                InsetDark ->
                    "page-button__inset-dark"

                InsetBrand ->
                    "page-button__inset-brand"
    in
    div (class insetDivClass :: attributes) contents
