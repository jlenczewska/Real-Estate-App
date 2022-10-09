({
    getFetchMovies: function(component) {

        var action = component.get("c.fetchMovies");
        var action1 = component.get("c.fetchActors");


        var currentPage = component.get("v.currPage");

        action.setParams({
            currentPage: currentPage
        });

        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                let result = response.getReturnValue();

                result.forEach((e) => {
                    e.release_date = e.release_date.slice(0, 4);
                })

                component.set("v.movieList", response.getReturnValue());
            }
        });

        action1.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                let result = response.getReturnValue();

                const resultFiltered = result.filter((e) => {
                    if (e.known_for_department == 'Acting') {
                        return true
                    } else {
                        return false
                    }
                })
                component.set("v.actorList", resultFiltered);
                console.log(response.getReturnValue())
            }
        });


        $A.enqueueAction(action);
        $A.enqueueAction(action1);
        component.set("v.showSpinner", false);

    }
})