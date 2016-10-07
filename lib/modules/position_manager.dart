part of nest_ui;

class PositionManager {

  Map<double> base_offset = { "x": 0, "y": 0 };

  Map getPosition(HtmlElement el) {
    var pos = el.getBoundingClientRect();
    return { 'x': pos.left, 'y': pos.top };
  }

  Map getDimensions(HtmlElement el) {
    var pos = el.getBoundingClientRect();
    return { 'x': pos.width, 'y': pos.height };
  }
  
  void placeAt(el,x,y) {
    el.style..top  = ((y + document.body.scrollTop).toString() + 'px')
            ..left = ((x + document.body.scrollLeft).toString() + 'px');
  }

  void placeBy(
    HtmlElement el1,
    HtmlElement el2,
    { double left: 0.0, double top: 0.0, double gravity_top: 0.0, double gravity_left: 0.0 }
  ) {
    
    var el2_pos = getPosition(el2);
    var el1_dim = getDimensions(el1);
    var el2_dim = getDimensions(el2);

    var pos_offset     = { 'x': el2_dim['x']*left, 'y': el2_dim['y']*top };
    var gravity_offset = { 'x': el1_dim['x']*gravity_left , 'y': el1_dim['y']*gravity_top };
    var new_pos        = { 'x': pos_offset['x']+el2_pos['x']-gravity_offset['x'], 'y': pos_offset['y']+el2_pos['y']-gravity_offset['y'] };

    var base_offset_for_el = { "x": base_offset["x"]*el1_dim["x"], "y": base_offset["y"]*el1_dim["y"] };
    if(new_pos["x"] < el2_pos["x"])
      base_offset_for_el["x"] = -base_offset_for_el["x"];
    if(new_pos["y"] < el2_pos["y"])
      base_offset_for_el["y"] = -base_offset_for_el["y"];
    new_pos = { "x" : new_pos["x"] + base_offset_for_el["x"], "y" : new_pos["y"] + base_offset_for_el["y"] };

    placeAt(el1, new_pos['x'], new_pos['y']);

  }

  void placeByCenter(HtmlElement el1, HtmlElement el2) {
    placeBy(el1, el2, top: 0.5, left: 0.5, gravity_top: 0.5, gravity_left: 0.5);
  }

  void placeByTopLeft(HtmlElement el1, HtmlElement el2) {
    placeBy(el1, el2);
  }

  void placeByTopRight(HtmlElement el1, HtmlElement el2) {
    placeBy(el1, el2, left: 1.0, gravity_left: 1.0);
  }

  void placeByBottomLeft(HtmlElement el1, HtmlElement el2) {
    placeBy(el1, el2, top: 1.0, gravity_top: 1.0);
  }

  void placeByBottomRight(HtmlElement el1, HtmlElement el2) {
    placeBy(el1, el2, top: 1.0, left: 1.0, gravity_left: 1.0, gravity_top: 1.0);
  }

  void placeAboveTopLeft(HtmlElement el1, HtmlElement el2) {
    placeBy(el1, el2, gravity_top: 1.0);
  }

  void placeBelowBottomLeft(HtmlElement el1, HtmlElement el2) {
    placeBy(el1, el2, top: 1.0);
  }

  void placeAboveTopRight(HtmlElement el1, HtmlElement el2) {
    placeBy(el1, el2, left: 1.0, gravity_left: 1.0, gravity_top: 1.0);
  }

  void placeBelowBottomRight(HtmlElement el1, HtmlElement el2) {
    placeBy(el1, el2, top: 1.0, left: 1.0, gravity_left: 1.0);
  }

  void placeAboveTopRightCorner(HtmlElement el1, HtmlElement el2) {
    placeBy(el1, el2, left: 1.0, gravity_top: 1.0);
  }

  void placeAboveTopLeftCorner(HtmlElement el1, HtmlElement el2) {
    placeBy(el1, el2, gravity_top: 1.0, gravity_left: 1.0);
  }

  void placeBelowBottomLeftCorner(HtmlElement el1, HtmlElement el2) {
    placeBy(el1, el2, top: 1.0, gravity_left: 1.0);
  }

  void placeBelowBottomRightCorner(HtmlElement el1, HtmlElement el2) {
    placeBy(el1, el2, top: 1.0, left: 1.0);
  }

}
