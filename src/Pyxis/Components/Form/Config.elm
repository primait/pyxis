module Pyxis.Components.Form.Config exposing (..)

import DatePicker exposing (DatePicker)
import Html exposing (..)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Maybe.Extra exposing (isJust)
import Prima.Form as Form
    exposing
        ( AutocompleteOption
        , CheckboxOption
        , FormField
        , FormFieldConfig
        , RadioOption
        , SelectOption
        , Validation(..)
        )
import Pyxis.Components.Form.Model
    exposing
        ( Field(..)
        , Model
        , Msg(..)
        )
import Pyxis.Helpers exposing (datepickerSettings)
import Regex exposing (regex)


textFieldConfig : Bool -> FormField Model Msg
textFieldConfig isDisabled =
    Form.textConfig
        "text_field"
        "Text field"
        isDisabled
        []
        .textField
        (UpdateText Text)
        ((Just << htmlInspector) "[data-form-field='text_field']")
        [ NotEmpty "Empty value is not acceptable"
        , Expression (regex "prima") "The value must contains `prima` substring."
        ]


textareaFieldConfig : Bool -> FormField Model Msg
textareaFieldConfig isDisabled =
    Form.textareaConfig
        "textarea_field"
        "Textarea field"
        isDisabled
        []
        .textareaField
        (UpdateText Textarea)
        ((Just << htmlInspector) "[data-form-field='textarea_field']")
        [ NotEmpty "Empty value is not acceptable"
        , Custom ((<=) 10 << String.length << Maybe.withDefault "" << .textareaField) "The value must be at least 10 characters length."
        ]


radioFieldConfig : Bool -> FormField Model Msg
radioFieldConfig isDisabled =
    Form.radioConfig
        "radio_field"
        "Radio field"
        isDisabled
        []
        .radioField
        (UpdateText Radio)
        [ RadioOption "Option A" "a"
        , RadioOption "Option B" "b"
        , RadioOption "Option C" "c"
        ]
        ((Just << htmlInspector) "[data-form-field='radio_field']")
        [ Custom ((==) "b" << Maybe.withDefault "b" << .radioField) "You must choose `Option B`." ]


checkboxFieldConfig : Bool -> FormField Model Msg
checkboxFieldConfig isDisabled =
    Form.checkboxConfig
        "checkbox_field"
        "Checkbox field"
        isDisabled
        []
        .checkboxField
        (UpdateFlag Checkbox)
        ((Just << htmlInspector) "[data-form-field='checkbox_field']")
        []


checkboxWithOptionsFieldConfig : Model -> FormField Model Msg
checkboxWithOptionsFieldConfig model =
    let
        options =
            model.checkboxMultiField

        isDisabled =
            model.formDisabled
    in
    Form.checkboxWithOptionsConfig
        "checkbox_multifield"
        "Checkbox multi field"
        isDisabled
        []
        (List.map (\option -> ( option.slug, option.isChecked )) << .checkboxMultiField)
        (UpdateMultiCheckbox MultiCheckbox)
        options
        ((Just << htmlInspector) "[data-form-field='checkbox_multifield']")
        [ Custom
            (\{ checkboxMultiField } ->
                (List.all ((==) False) << List.map .isChecked) checkboxMultiField
                    || (isJust
                            << List.head
                            << List.filter (\{ slug, isChecked } -> slug == "b" && isChecked)
                       )
                        checkboxMultiField
            )
            "You must choose `Option B`."
        ]


selectFieldConfig : Model -> FormField Model Msg
selectFieldConfig model =
    let
        isDisabled =
            model.formDisabled

        isOpen =
            model.isSelectFieldOpen

        options =
            List.sortBy .label
                [ SelectOption "Milano" "MI"
                , SelectOption "Torino" "TO"
                , SelectOption "Roma" "RO"
                , SelectOption "Napoli" "NA"
                , SelectOption "Genova" "GE"
                , SelectOption "Savona" "SA"
                ]
    in
    Form.selectConfig
        "select_field"
        "Select field"
        isDisabled
        isOpen
        []
        .selectField
        (Toggle Select)
        (UpdateText Select)
        options
        True
        ((Just << htmlInspector) "[data-form-field='select_field']")
        [ Custom ((==) "SA" << Maybe.withDefault "SA" << .selectField) "You must choose `Savona`. ;)" ]


datepickerFieldConfig : Bool -> DatePicker -> FormField Model Msg
datepickerFieldConfig isDisabled datepicker =
    Form.datepickerConfig
        "datepicker_field"
        "Datepicker field"
        isDisabled
        .datepickerField
        (UpdateDate Datepicker)
        datepicker
        datepickerSettings
        ((Just << htmlInspector) "[data-form-field='datepicker_field']")
        []


autocompleteFieldConfig : Model -> FormField Model Msg
autocompleteFieldConfig ({ isAutocompleteFieldOpen, formDisabled } as model) =
    let
        isDisabled =
            formDisabled

        lowerFilter =
            (String.toLower << Maybe.withDefault "" << .autocompleteFilter) model

        options =
            [ AutocompleteOption "Italy" "ITA"
            , AutocompleteOption "Brasil" "BRA"
            , AutocompleteOption "France" "FRA"
            , AutocompleteOption "Great Britain" "GBR"
            , AutocompleteOption "USA" "USA"
            , AutocompleteOption "Japan" "JAP"
            ]
                |> List.filter (String.contains lowerFilter << String.toLower << .label)
    in
    Form.autocompleteConfig
        "autocomplete_field"
        "Autocomplete field"
        isDisabled
        isAutocompleteFieldOpen
        (Just "Nessun risultato trovato.")
        []
        .autocompleteFilter
        .autocompleteField
        (UpdateAutocomplete Autocomplete)
        (UpdateText Autocomplete)
        options
        ((Just << htmlInspector) "[data-form-field='autocomplete_field']")
        [ NotEmpty "Empty value is not acceptable" ]


htmlInspector : String -> Html Msg
htmlInspector selector =
    i
        [ class "pyIcon pyIconInspect icon-search"
        , (onClick << InspectHtml) selector
        ]
        []
