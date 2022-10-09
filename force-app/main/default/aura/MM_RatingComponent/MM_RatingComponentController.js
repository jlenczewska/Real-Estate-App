({
    doInit: function(component, event, helper) {
        helper.checkForComments(component);
    },

    changeStars: function() {
        document.querySelector(':radio').change(
            function() {
                document.querySelector('.choice').text(this.value + ' stars');
            }
        )
    },

    deleteMovie: function(component, event, helper) {

        if (confirm("Are you sure you want to delete this review?")) {
                    var id = event.currentTarget.dataset.id;
                    var getTargetedButton = component.find(id);

                    var movieIDToDelete = (event.currentTarget.dataset.id).split(',')[0];
                    var personIDToDelete = (event.currentTarget.dataset.id).split(',')[1];
                    var action = component.get("c.deleteComment");

                    action.setParams({
                        personID: personIDToDelete,
                        movieID: movieIDToDelete,
                    });

                    action.setCallback(this, function(response) {
                        let state = response.getState();
                    });
                    $A.enqueueAction(action);
          }

          helper.checkForComments(component);
         var event1 = component.getEvent("cmpEvent");
                   event1.setParams({
                    "eventResponse" : "Refresh"
                    });
         console.log('wykonało się')
                   event1.fire();
    },

    saveStar: function(component, event, helper) {
        var numberOfStars = event.target.getAttribute("id");
        numberOfStars = numberOfStars.replace('rating', '')
        component.set('v.rating', numberOfStars);
    },

    addReview: function(component, event, helper) {
        event.preventDefault();
        var textInput = component.find('textArea').get("v.value");
        component.set('v.comment', textInput);

        var ratingToAdd = component.get("v.rating");
        var commentToAdd = component.get("v.comment");
        var movieId = component.get("v.movieId");


        var action = component.get("c.addReviewApex");

if(ratingToAdd>0){

        action.setParams({
            numberOfStars: ratingToAdd,
            comment: commentToAdd,
            movieID: movieId
        });

        action.setCallback(this, function(response) {
            let state = response.getState();
        });
        $A.enqueueAction(action);
helper.checkForComments(component);

var event1 = component.getEvent("cmpEvent");
          event1.setParams({
           "eventResponse" : "Refresh"
           });

          event1.fire();
}


    },
})