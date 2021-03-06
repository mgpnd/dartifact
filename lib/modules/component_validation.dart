part of dartifact;

abstract class ComponentValidation {

  /** This is not to be updated manually. Validations for descenndants are defined along
    * all other validations in #validations Map, but dot (.) is used to separate roles of
    * descendants and property names. For example:
    *
    *   Map validations = {
    *     'form.input.text' => ...
    *   }
    *
    * would define a validation on the .text property of a component which has an "input" role,
    * which is also a child of an element with role "form", which, in turn, is a child of
    * the current component.
    */
  Map descendant_validations = {};

  /** Reloads standart Validatable module method for two reasons:
    * 1. Collect all validation errors and write a String represenation of them
    *    to display somehwere in UI.
    * 2. Run validations on children too if deep is set to true.
    */
  @override
  bool _validate({ deep: true }) {

    try {
      if(!valid) {
        var validation_errors_summary_map = [];
        for(var ve in validation_errors.keys)
          validation_errors_summary_map.add("${validation_errors[ve].join('; ')}");
        this.validation_errors_summary = validation_errors_summary_map.join(', ');
      } else {
        this.validation_errors_summary = '';
      }
    }
    on NoSuchMethodError {
      // Ignore if no such attribute validation_errors_summary;
    }

    if(deep) {
      for(var c in this.children) {
        if(!c.validate(deep: true)) {
          valid = false;
          break;
        }
      }
    }
    valid ? behave('hideErrors') : behave('showErrors');
    return valid;
  }

  /** Extracts validations with keys containing dots .
    * as those are validations defined for descendants.
    */
  void _separateDescendantValidations() {
    for(var k in this.validations.keys) {
      if(k.contains('.')) {
        this.descendant_validations[k] = this.validations[k];
      }
    }
    for(var dv in this.descendant_validations.keys)
      this.validations.remove(dv);
  }

  /** Adds validations to children by looking at #descendants_validations.
    * Worth noting that if one of the validation keys contains more than one dot (.)
    * it means that this validation is for one of the child's children and it gets added
    * to child's #descendant_validations, not to #validations.
    */
  void _addValidationsToChild(c) {
    for(var dr in this.descendant_validations.keys) {
      var dr_map = dr.split('.');
      var r      = dr_map.removeAt(0);
      if(c.roles.contains(r)) {
        
        var validation = this.descendant_validations[dr];
        if(validation.containsKey('function'))
          validation["object"] = this;

        if(dr_map.length > 1)
          c.descendant_validations[dr_map.join('.')] = validation;
        else
          c.validations[dr_map[0]] = validation;
      }
    }
  }

  /** Adds translated validation error messages for those fields where
    * validations are defined with i18n_message option.
    * Example:

    * final Map validations = {
    *   'contract_value_input.value' : { 'function' : { 'name': 'validateAmountMatchesOffer',     'i18n_message': "OfferComponent.should_be_within_volume_range" }},
    *   'contract_volume'            : { 'function' : { 'name': 'validateVolumeIsAboveThreshold', 'i18n_message': "OfferComponent.volume_below_threshold"        }},
    *   'contract_volume'            : { 'isMoreThan' : { 'value': 1, 'i18n_message': "OfferComponent.hello_world" }}
    * };
    */
  void _i18nize_validation_messages() {
    validations.forEach((field_name,field_validations) {

      field_validations.forEach((k,v) {

        if(k != "object" && v is Map && v.containsKey("i18n_message")) {
          var i18n_key = v["i18n_message"].split(".");
          var component_name = i18n_key.removeAt(0);
          validations[field_name][k]["message"] = t("validations.${i18n_key.join(".")}", component_name);
        }
      
      });

    });
  }

}
