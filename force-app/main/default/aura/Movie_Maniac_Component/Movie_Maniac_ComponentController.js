({
    onMovieDetailsSet: function(component, event) {
        var param1 = event.getParam("whatToShow");
        var param2 = event.getParam("MovieIdToFetch");

        component.set("v.whatComponentToDisplay", param1);
        component.set("v.MovieIdToFetch", param2);
    },

    onActorDetailsSet: function(component, event) {
        var param1 = event.getParam("whatToShow");
        var param2 = event.getParam("ActorIdToFetch");

        component.set("v.whatComponentToDisplay", param1);
        component.set("v.ActorIdToFetch", param2);
    },
       doInit: function(component, event, helper) {
            helper.getMovieGenres(component);
        },
})