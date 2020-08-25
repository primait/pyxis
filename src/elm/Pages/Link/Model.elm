module Pages.Link.Model exposing (Model, Msg(..), init)

import Dict
import Pages.Component exposing (WithCodeInspectors)


type Msg
    = NoOp
    | ToggleInspect String Bool
    | CopyToClipboard String


type alias Model =
    WithCodeInspectors {}


init : Model
init =
    { inspectMode = Dict.empty
    }
