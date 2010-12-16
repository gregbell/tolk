// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults


var Tolk = { }

Tolk.saveTranslation = function(translationForm) {
  // Mark the button as saving...
  var saveBtn = translationForm.down('input[type=submit]');
  saveBtn.value = "Saving..."
  saveBtn.disable();

  // Submit the ajax form
  translationForm.request({
    onComplete: function(transport){ 
      var row = translationForm.up('tr')
      row.removeClassName('active');
      Element.replace(translationForm, transport.responseText);
      if(transport.responseText.match(/class\=\"formError\"/)) {
        row.addClassName('active');
        row.down("textarea").focus();
      } 
    }
  })

  // Disbale the form field
  var input = translationForm.down('textarea');
  input.disable();
  input.addClassName("disabled");


}
