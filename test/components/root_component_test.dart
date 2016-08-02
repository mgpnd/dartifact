import '../../lib/nest_ui.dart';
import "package:test/test.dart";
import "dart:html";

@TestOn("browser")

class MyComponentBehaviors {
  Component component;
  MyComponentBehaviors(this.component) {}
  externalClickResponse() {
    component.external_events.add("click");
  }
}


class MyComponent extends Component {
  List behaviors = [MyComponentBehaviors];
  List external_events = [];
}

void main() {

  var c;
  var child;
  var grand_child;

  setUp(() {
    c                 = new RootComponent();
    child             = new MyComponent();
    grand_child       = new MyComponent();
    c.dom_element     = new DivElement();
    child.dom_element = new DivElement();
    grand_child.dom_element = new DivElement();
    c.after_initialize();
    child.after_initialize();
    grand_child.after_initialize();
    c.addChild(child);
    child.addChild(grand_child);
  });

  group("RootComponent", () {

    test("sends externalClickResponse behavior call to all it's children", () {
      c.dom_element.click();
      expect(child.external_events[0], equals('click'));
      expect(grand_child.external_events[0], equals('click'));
    });

  });

}