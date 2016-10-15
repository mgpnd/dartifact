part of nest_ui;

class SimpleNotificationComponent extends Component {

  final List attribute_names = ["message", "autohide_delay", "permanent", "container_selector"];
        List native_events   = ["close.click"];
        Map default_attribute_values = {
          "container_name": "#simple_notifications_container",
          "permanent": false,
          "autohide_delay": 10
        };

  Future autohide_future;

  List behaviors = [SimpleNotificationComponentBehaviors];
  bool visible   = false;
  HtmlElement container;

  SimpleNotificationComponent({ attrs: null }) {
    updateAttributes(attrs);
    this.container = querySelector("#simple_notifications_container");
    event_handlers.add(event: "click", role: "self.close", handler: (self, event) => self.hide());
  }

  @override afterInitialize() {
    super.afterInitialize();
    updatePropertiesFromNodes();
    this.show();
  }

  void show() {
    behave("show");
    this.visible = true;

    if(this.autohide_delay != null) {
      var f = new Future.delayed(new Duration(seconds: this.autohide_delay));
      this.autohide_future = f;
      f.then((r) {
        if(this.autohide_future == f)
          this.hide();
      });
    }

  }

  void hide() {
    if(this.permanent == null || this.permanent == false) {
      behave("hide");
      this.visible = false;
      this.parent.removeChild(this);
    }
  }

}
