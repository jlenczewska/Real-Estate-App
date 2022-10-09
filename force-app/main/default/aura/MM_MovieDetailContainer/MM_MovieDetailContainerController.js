({
    doInit :function(component,event,helper){
        component.isInit = true;
        component.set("v.showSpinner", true);
        helper.getMovieDetails(component);
        window.setTimeout(
            $A.getCallback(function(){
              component.isInit = false;
            }),3000
          );
    },
    handleEvent : function(component, event, helper)
     {
 component.isInit = true;
        component.set("v.showSpinner", true);
        helper.getMovieDetails(component);
        window.setTimeout(
            $A.getCallback(function(){
              component.isInit = false;
            }),3000
          );
      }
})