
module Overlay where

import Graphics.Input (..)
import Mouse (..)
import Transform2D (..)
import Window (..)

port media : String

type Tag = { x : Float, y : Float, text : String, id : Int }

newTagOn : Input Bool
newTagOn = input False

tagInput : Input (Maybe Int)
tagInput = input Nothing

inactiveTag : Int -> Int -> Element
inactiveTag w h = collage w h [outlined (solid gray) <| rect 20 20]

renderTag : (Int,Int) -> Tag -> Form
renderTag (w,h) tag = 
  let tagTextElem = asText tag.text 
      tagWidth = widthOf tagTextElem
      tagHeight = heightOf tagTextElem
      tagBounds = filled white <| rect (toFloat tagWidth) (toFloat tagHeight)
      tagElem = collage tagWidth tagHeight [tagBounds, toForm tagTextElem]
      tagFullElem = customButton tagInput.handle (Just tag.id) (inactiveTag tagWidth tagHeight) tagElem tagTextElem
  in groupTransform (translation (toFloat w * (tag.x - 0.5)) (toFloat w * (0.5 - tag.y))) [toForm tagFullElem]

newTagToggle : Bool -> Element
newTagToggle b = 
  let but = button newTagOn.handle True "Tag"
  in if b then but else empty

tagCross : (Int,Int) -> (Int,Int) -> Bool -> Element
tagCross (w,h) (x,y) b = 
  let vert = traced (solid red) <| segment (0,10) (0,-10)
      hori = traced (solid red) <| segment (10,0) (-10,0)
      cross = collage 20 20 [vert, hori]
      crossElem = container w h (middleAt (absolute x) (absolute y)) cross
  in if b then crossElem else empty

tagClickArea : (Int,Int) -> Bool -> Element
tagClickArea (w,h) b = 
  let box = collage w h [alpha 0.3 <| filled green <| rect (toFloat w) (toFloat h)]
      area = clickable newTagOn.handle False box
  in if b then area else empty

draw : (Int,Int) -> (Int,Int) -> Bool -> [Tag] -> Element
draw (w,h) (x,y) newTag tags = 
  flow outward <|
    [ flow down [ newTagToggle (not newTag), asText newTag ]
    , tagCross (w,h) (x,y) newTag
    , tagClickArea (w,h) newTag
    , collage w h <| map (renderTag (w,h)) tags]

mediaTags = constant <|
  [ { x = 0.3, y = 0.3, text = "foo", id = 1 }
  , { x = 0.5, y = 0.5, text = "bar", id = 2 }
  , { x = 0.7, y = 0.7, text = "baz", id = 3 }
  ]

main = draw <~ dimensions ~ position  ~ newTagOn.signal ~ mediaTags

