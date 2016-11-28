Shiny.addCustomMessageHandler("handle1", function(message1) {
  alert(message1);
});

function doAwesomeThing(id, data) {
  var message = {id: id, data:data};
  Shiny.onInputChange("selectedSpecies", message);
}