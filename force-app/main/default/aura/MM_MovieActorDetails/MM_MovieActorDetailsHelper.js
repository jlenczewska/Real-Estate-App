({
    getFetchedActor: function(component) {
        setTimeout(() => {
            var action = component.get("c.fetchActorMovies");
            var action1 = component.get("c.fetchActorInfo");
            var currentIdToFetch = component.get("v.actorId");

            action.setParams({
                idActorToFetch: currentIdToFetch
            });

            action1.setParams({
                idActorToFetch: currentIdToFetch
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
                    component.set("v.actorInfo", response.getReturnValue());
                    console.log(response.getReturnValue())
                }
            });

            $A.enqueueAction(action);
            $A.enqueueAction(action1);
            component.set("v.showSpinner", false);
        }, 300)
    }
})