module Main where

import Halogen.VDom.Driver (runUI)

import CSS hiding (render)
import CSS.Styled (StyledComponent, styled, styledPage)
import Data.Maybe (Maybe(..))
import CSS.Extra (custom)
import Effect (Effect)
import Halogen as H
import Halogen.Aff as HA
import Halogen.HTML as HH
import Prelude (Unit, Void, bind, const, pure, unit, ($), discard)

-- QUERY
data Query a = Unit a

-- STATE
type State = Unit

initialState :: Unit
initialState = unit

-- CSS

-- some styled label
labelStyled :: StyledComponent
labelStyled = styled "label" $ do
    fontSize $ px 18.0
    marginRight $ px 20.0

-- div with gray background
divStyled :: StyledComponent
divStyled = styled "label" $
    custom "background-color" "#dadada"

-- RENDER
render :: State -> H.ComponentHTML Query
render state =
    styledPage
        -- you must provide list of all styled component elements
        -- which you will use in HTML section bellow
        [ labelStyled
        , divStyled
        ]
        -- html section bellow
        [ labelStyled.element [] [ HH.text "styled label" ]
        , divStyled.element []
            [ labelStyled.element []
                [ HH.text "styled label inside styled div with gray background" 
                ]
            ]
        ]

-- EVAL
eval :: forall a m. Query a -> H.ComponentDSL State Query Void m a
eval (Unit a) = pure a

-- UI
ui :: forall a. H.Component HH.HTML Query Unit Void a
ui = H.component
    { initialState: const initialState
    , render: render
    , eval: eval
    , receiver: const Nothing
    }

-- MAIN
main :: Effect Unit
main = HA.runHalogenAff do
    body <- HA.awaitBody
    runUI ui unit body
