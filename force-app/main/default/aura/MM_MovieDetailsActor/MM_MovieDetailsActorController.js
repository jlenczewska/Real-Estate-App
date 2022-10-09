({
    displayActorDetails: function(component, event, helper) {
        var currentIdToFetch = event.currentTarget.dataset.id;
        console.log(currentIdToFetch)
        var whatToShowMovieCard = component.getEvent("MM_displayActorsDetailsEvent");

        whatToShowMovieCard.setParams({
            "whatToShow": "actorDetails",
            "ActorIdToFetch": currentIdToFetch
        });

        whatToShowMovieCard.fire();
    },
//    doInit: function(component, event, helper) {
//     helper.getFetchedActor(component);
//     }
})