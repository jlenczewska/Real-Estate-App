({
    checkForComments: function(component) {
        setTimeout(() => {
            var action = component.get("c.checkForCommentsApex");
            var action1 = component.get("c.checkUserLicense");
            var action2 = component.get("c.getAllCommentsApex");

            var currentIdToCheck = component.get("v.movieId");

            var userId = $A.get("$SObjectType.CurrentUser.Id");
            component.set("v.userId", userId);

            action.setParams({
                movieID: currentIdToCheck
            });

            action2.setParams({
                movieID: currentIdToCheck
            });

            action.setCallback(this, function(response) {
                let state = response.getState();
                if (state === "SUCCESS" && response.getReturnValue() != null) {
                    component.set("v.addedComment", response.getReturnValue());
                }
            });

            action1.setCallback(this, function(response) {
                let state = response.getState();
                if (state === "SUCCESS" && response.getReturnValue() != null) {
                    component.set("v.activeLicense", response.getReturnValue());
                }
            });

            action2.setCallback(this, function(response) {
                let state = response.getState();
                if (state === "SUCCESS" && response.getReturnValue() != null) {
                    component.set("v.allComments", response.getReturnValue());
                }

            });
            $A.enqueueAction(action);
            $A.enqueueAction(action1);
            $A.enqueueAction(action2);

        }, 100)
    }
})