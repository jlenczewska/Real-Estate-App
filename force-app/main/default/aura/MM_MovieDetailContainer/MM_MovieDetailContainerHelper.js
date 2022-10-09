({
    getMovieDetails: function(component) {

        setTimeout(() => {
            var action = component.get("c.fetchMovieDetails");
            var action1 = component.get("c.getMovieRating");

            var currentIdToFetch = component.get("v.movieId");

            action.setParams({
                idMovieToFetch: currentIdToFetch
            });
            action1.setParams({
                idMovieToFetch: currentIdToFetch
            });

            action.setCallback(this, function(response) {
                let state = response.getState();

                if (state === "SUCCESS") {
                    component.set("v.detailedMovie", response.getReturnValue());

                    var movieInfoChild = response.getReturnValue().genres;
                    var movieGenres = component.get("v.movieGenres")[0];

                    let resultsArray = [];
                    let tempList = [];

                    for (let i = 0; i < movieInfoChild.length; i++) {
                        tempList.push(movieInfoChild[i].name)
                    }

                    for (const [key, value] of Object.entries(movieGenres)) {
                        if (tempList.includes(value)) {
                            
                            resultsArray.push(value)
                        }
                    }

                    component.set("v.movieGenresString", resultsArray)
                }
            });

            action1.setCallback(this, function(response) {
                let state = response.getState();

                if (state === "SUCCESS") {
                    component.set("v.reviewsList", response.getReturnValue());
                }
            });
            $A.enqueueAction(action);
            $A.enqueueAction(action1);
            component.set("v.showSpinner", false);
        }, 1000)
    }
})