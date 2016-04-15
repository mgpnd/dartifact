part of nest_ui;

class Component extends Object with observable.Subscriber,
                                    observable.Publisher,
                                    HeritageTree,
                                    Attributable
{

  /* Events emitted by the browser that we'd like to handle
  *  if you prefer to not listen to them all for your component,
  *  simply list the ones you'd like to listen to, ommiting all the others.
  *
  *  native_events_list is a variable defined in native_events_list.dart
  *  and it simply contains a List of all events Dart is capable of catching.
  *  If you'd like to listen to all of those native events, uncomment it and assign
  *  native_events to it, however not that it might affect performance.
  */
  List native_events = []; // native_events_list;

  // a DOM element associated with this component
  HtmlElement _dom_element;

  // ... and you can add more, for example [... ButtonBehaviors, LinkBehaviors] 
  List behaviors  = [BaseComponentBehaviors];
  // instantiated behavior objects, don't touch it
  List _behaviors = [];

  final Map attribute_callbacks = {
    'default' : (attr_name, self) => self.prvt_update_property_on_node(attr_name)
  };

  get dom_element => _dom_element;
  set dom_element(HtmlElement el) {
    _dom_element = el;
    _listen_to_native_events();
  }
  
  Component() {
    _create_behaviors();
  }

  behave(behavior) {
    _behaviors.forEach((b) {
      if(methods_of(b).contains(behavior)) {
        var im = reflect(b);
        im.invoke(new Symbol(behavior), []);
        return;
      }
    });
  }

  // Updates dom element's #text or attribute so it refelects Component's current property value.
  prvt_update_property_on_node(attr_name) {

    /// We're dealing with the #dom_element itself, no children involved!
    if(this.dom_element.getAttribute('data-component-property') == attr_name) {
      /// Basic case when property is tied to the node's text.
      this.dom_element.text = this.attributes[attr_name];
      /// Now deal with properties tied to an element's attribute, rather than it's text.
      _update_property_on_html_attribute(this.dom_element, attr_name);
    }

    /// We're dealing with a property which is tied to one of the children of the #dom_element
    else {
      var property_el = this.dom_element.querySelector('[data-component-property="${attr_name}"]');
      if(property_el != null) {
        /// Basic case when property is tied to the node's text.
        property_el.text = this.attributes[attr_name];
        /// Now deal with properties tied to an element's attribute, rather than it's text.
        _update_property_on_html_attribute(property_el, attr_name);
      }
    }
  }

  _listen_to_native_events() {
     this.native_events.forEach((e) {
       this.dom_element.on[e].listen((e) => this.captureEvent(e.type, [#self]));
    }); 
  }

  _create_behaviors() {
    behaviors.forEach((b) {
      b = new_instance_of(b.toString(), 'nest_ui');
      b.component = this;
      _behaviors.add(b);
    });
  }

  _update_property_on_html_attribute(node, attr_name) {
    var property_html_attr_name = node.getAttribute('data-component-property-attr-name');
    if(property_html_attr_name != null)
      node.setAttribute(property_html_attr_name, this.attributes[attr_name]);
  }

  // So far this is only required for Attributable module to work on this class.
  noSuchMethod(Invocation i) {  
    var result = prvt_noSuchGetterOrSetter(i);
    if(result)
      return result;
    else
      super.noSuchMethod(i);
  }

}
