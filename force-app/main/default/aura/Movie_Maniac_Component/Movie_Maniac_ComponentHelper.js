({

getMovieGenres: function(component) {

     var action1 = component.get("c.getMovieGenres");
      action1.setCallback(this, function(response) {
                                                        let state = response.getState();
                                                        let movieGenresList = [];

                                                        if (state === "SUCCESS") {
                                                            component.set("v.movieGenres", response.getReturnValue());
for (var key in response.getReturnValue()) {
       movieGenresList.push(response.getReturnValue()[key]);
}
component.set("v.movieGenresValues", movieGenresList);
                                                        }

                                                    });

                                                    $A.enqueueAction(action1);
}

})