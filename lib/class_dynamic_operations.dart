part of nest_ui;

List findSubclasses(name) {

  final ms         = currentMirrorSystem();
  List  subclasses = [];

  ms.libraries.forEach((k,lib) {
    lib.declarations.forEach((k2, c) {
      if(c is ClassMirror && c.superclass != null) {
        final parentClassName = MirrorSystem.getName(c.superclass.simpleName);
        if (parentClassName == name) {
          subclasses.add(c);
        }
      }
    });
  });

  return subclasses;

}

Object new_instance_of(String class_name, String library) {

  MirrorSystem mirrors = currentMirrorSystem();
  LibraryMirror     lm = mirrors.libraries.values.firstWhere(
    (LibraryMirror lm) => lm.qualifiedName == new Symbol(library)
  );

  ClassMirror cm = lm.declarations[new Symbol(class_name)];

  InstanceMirror im = cm.newInstance(new Symbol(''), []);
  return im.reflectee;

}

List<String> list_of_methods_for(object) {
  var im = reflect(object);
  List methods = [];
  im.type.instanceMembers.values.forEach((MethodMirror method) {
    methods.add(symToString(method.simpleName));
  });
  return methods;
}

symToString(s) {
  return MirrorSystem.getName(s);
}
