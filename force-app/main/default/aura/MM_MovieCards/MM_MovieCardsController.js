({
    doInit: function(component, event, helper) {
        helper.getFetchMovies(component);
    },

    searchByTitle: function(component, event) {

        if(component.get("v.searchKeyword").trim().length >0  &&  component.get("v.searchKeyword") != null){
               component.set("v.showSpinner", true);
                    component.set("v.currPage", 1);
                    component.set("v.movieGenreValue", 'default');
                    component.set("v.searchOption", 'searchByTitle');

                    setTimeout(() => {
                        var action = component.get("c.fetchMovieByPhrase");
                        var currentSearchKeyword = component.get("v.searchKeyword");
                        var currentPage = component.get("v.currPage");

                        action.setParams({
                            searchPhrase: currentSearchKeyword,
                            currentPage: currentPage
                        });

                        action.setCallback(this, function(response) {
                            let state = response.getState();
                            let result = response.getReturnValue();

                            result.forEach((e) => {
                                e.release_date = e.release_date.slice(0, 4);
                            })

                            if (state === "SUCCESS") {
                                component.set("v.movieListBySearch", response.getReturnValue());
                            }
                        });
                        $A.enqueueAction(action);
                    }, 100)
                    setTimeout(() => {
                        component.set("v.showSpinner", false);
                    }, 1000)
        }

    },

    searchByTitleActor: function(component, event) {


        if(component.get("v.searchKeywordActor").trim().length >0  &&  component.get("v.searchKeywordActor") != null){
        component.set("v.currPage", 1);
        component.set("v.showSpinner", true);

        setTimeout(() => {
            var action = component.get("c.fetchActorsByPhrase");
            var currentSearchKeyword = component.get("v.searchKeywordActor");

            action.setParams({
                searchPhrase: currentSearchKeyword
            });

            action.setCallback(this, function(response) {
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
                    component.set("v.actorListBySearch", resultFiltered);
                }
            });
            $A.enqueueAction(action);
        }, 100)
        setTimeout(() => {
            component.set("v.showSpinner", false);
        }, 1000)
        }
    },

    searchByActor: function(component, event) {

         if(component.get("v.searchKeyword").trim().length >0  &&  component.get("v.searchKeyword") != null){

        component.set("v.currPage", 1);
        component.set("v.showSpinner", true);
        component.set("v.movieGenreValue", 'default');
        component.set("v.searchOption", 'searchByActor');

        setTimeout(() => {
            var action = component.get("c.fetchMovieByPhraseActor");
            var currentSearchKeyword = component.get("v.searchKeyword");
            var currentPage = component.get("v.currPage");

            action.setParams({
                searchPhrase: currentSearchKeyword,
                currentPage: currentPage
            });

            action.setCallback(this, function(response) {
                let state = response.getState();
                let result = response.getReturnValue();

                result.forEach((e) => {
                    e.release_date = e.release_date.slice(0, 4);
                })
                if (state === "SUCCESS") {
                    component.set("v.movieListBySearch", response.getReturnValue());
                }
            });
            $A.enqueueAction(action);

        }, 100)
        setTimeout(() => {
            component.set("v.showSpinner", false);
        }, 1000)
        }
    },

    searchByGenre: function(component, event) {
        component.set("v.showSpinner", true);
        component.set("v.currPage", 1);
        component.set("v.searchKeyword", '');
        component.set("v.searchOption", 'searchByGenre');

        let selectOption = component.find("select1").get("v.value")
        component.set("v.movieGenreValue", selectOption)

        setTimeout(() => {
            var action = component.get("c.fetchMovieByPhraseGenre");
            var currentPage = component.get("v.currPage");
            var movieGenresList = component.get("v.movieGenres");

            action.setParams({
                searchPhrase: selectOption,
                movieGenres: movieGenresList[0],
                currentPage: currentPage
            });

            action.setCallback(this, function(response) {
                let state = response.getState();
                let result = response.getReturnValue();

                result.forEach((e) => {
                    e.release_date = e.release_date.slice(0, 4);
                })
                if (state === "SUCCESS") {
                    component.set("v.movieListBySearch", response.getReturnValue());
                }
            });
            $A.enqueueAction(action);

        }, 100)
        setTimeout(() => {
            component.set("v.showSpinner", false);
        }, 1000)
    },

    prevPage: function(component, event) {

        if (component.get("v.searchOption") == 'searchByTitle') {

            var action = component.get("c.fetchMovieByPhrase");
            var currentSearchKeyword = component.get("v.searchKeyword");
            var currentPage = component.get("v.currPage") - 1;
            component.set("v.currPage", currentPage);

            action.setParams({
                searchPhrase: currentSearchKeyword,
                currentPage: currentPage
            });

            action.setCallback(this, function(response) {
                let state = response.getState();
                if (state === "SUCCESS") {
                    let result = response.getReturnValue();

                    result.forEach((e) => {
                        e.release_date = e.release_date.slice(0, 4);
                    })
                    component.set("v.movieListBySearch", response.getReturnValue());
                }
            });
            window.scrollTo(0, 0);
            $A.enqueueAction(action);
        } else if (component.get("v.searchOption") == 'searchByGenre') {

            component.set("v.showSpinner", true);

            let selectOption = component.find("select1").get("v.value")
            component.set("v.movieGenreValue", selectOption)
            var currPage = component.get("v.currPage") - 1;
            component.set("v.currPage", currPage);

            setTimeout(() => {
                var action = component.get("c.fetchMovieByPhraseGenre");
                var movieGenresList = component.get("v.movieGenres");

                action.setParams({
                    searchPhrase: selectOption,
                    movieGenres: movieGenresList[0],
                    currentPage: currPage
                });

                action.setCallback(this, function(response) {
                    let state = response.getState();
                    let result = response.getReturnValue();

                    result.forEach((e) => {
                        e.release_date = e.release_date.slice(0, 4);
                    })
                    if (state === "SUCCESS") {
                        component.set("v.movieListBySearch", response.getReturnValue());
                    }
                });
                $A.enqueueAction(action);

            }, 100)
            window.scrollTo(0, 0);
            setTimeout(() => {
                component.set("v.showSpinner", false);
            }, 1000)

        } else {
            var action = component.get("c.fetchMovies");
            var currentPage = component.get("v.currPage") - 1;
            component.set("v.currPage", currentPage);
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
            window.scrollTo(0, 0);
            $A.enqueueAction(action);
        }
    },

    nextPage: function(component, event) {

        if (component.get("v.searchOption") == 'searchByTitle') {

            var action = component.get("c.fetchMovieByPhrase");
            var currentSearchKeyword = component.get("v.searchKeyword");
            var currentPage = component.get("v.currPage") + 1;
            component.set("v.currPage", currentPage);

            action.setParams({
                searchPhrase: currentSearchKeyword,
                currentPage: currentPage
            });

            action.setCallback(this, function(response) {
                let state = response.getState();
                if (state === "SUCCESS") {
                    let result = response.getReturnValue();

                    result.forEach((e) => {
                        e.release_date = e.release_date.slice(0, 4);
                    })
                    component.set("v.movieListBySearch", response.getReturnValue());
                }
            });
            window.scrollTo(0, 0);
            $A.enqueueAction(action);
        } else if (component.get("v.searchOption") == 'searchByGenre') {

            component.set("v.showSpinner", true);

            let selectOption = component.find("select1").get("v.value")
            component.set("v.movieGenreValue", selectOption)
            var currPage = component.get("v.currPage") + 1;
            component.set("v.currPage", currPage);

            setTimeout(() => {
                var action = component.get("c.fetchMovieByPhraseGenre");
                var movieGenresList = component.get("v.movieGenres");

                action.setParams({
                    searchPhrase: selectOption,
                    movieGenres: movieGenresList[0],
                    currentPage: currPage
                });

                action.setCallback(this, function(response) {
                    let state = response.getState();
                    let result = response.getReturnValue();

                    result.forEach((e) => {
                        e.release_date = e.release_date.slice(0, 4);
                    })
                    if (state === "SUCCESS") {
                        component.set("v.movieListBySearch", response.getReturnValue());
                    }
                });
                $A.enqueueAction(action);

            }, 100)
            window.scrollTo(0, 0);
            setTimeout(() => {
                component.set("v.showSpinner", false);
            }, 1000)

        } else {
            var action = component.get("c.fetchMovies");
            var currentPage = component.get("v.currPage") + 1;
            component.set("v.currPage", currentPage);
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
            window.scrollTo(0, 0);
            $A.enqueueAction(action);
        }
    },
})