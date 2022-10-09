({
     displayMovieDetails: function(component, event, helper) {
            var currentIdToFetch = event.currentTarget.dataset.id;
            var whatToShowMovieCard = component.getEvent("displayMovieDetailsEvent");

            whatToShowMovieCard.setParams({
                "whatToShow": "movieDetails",
                "MovieIdToFetch": currentIdToFetch
            });

            whatToShowMovieCard.fire();
             window.scrollTo(0,0);
        }
})