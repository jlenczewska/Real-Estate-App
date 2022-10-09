({
    getMovieGenresTransformed: function(component) {

        var movieInfoChild = component.get("v.movieInfoChild");
        var movieGenres = component.get("v.movieGenres")[0];

        let resultsArray = [];

        let tempList = Object.values(movieInfoChild.genre_ids);

        for (const [key, value] of Object.entries(movieGenres)) {
            if (tempList.includes(parseInt(key))) {
                resultsArray.push(value)
            }
        }

        component.set("v.movieGenresString", resultsArray)

    }
})