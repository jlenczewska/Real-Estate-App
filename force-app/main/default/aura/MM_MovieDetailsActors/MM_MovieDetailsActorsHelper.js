({
    getActors : function(component){
       setTimeout(()=>{
              var action = component.get("c.fetchMovieActors");
              var currentIdToFetch = component.get("v.movieId");

              action.setParams({idMovieToFetch: currentIdToFetch});
              action.setCallback(this, function(response) {
                 let state = response.getState();
                 console.log(state);
                 if (state === "SUCCESS") {
                    component.set("v.actorsList", response.getReturnValue());
                 }
                 });
               $A.enqueueAction(action);
      } , 100)
    }
})