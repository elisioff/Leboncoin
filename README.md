# Leboncoin
Application Exercise

## Notes
Bearing in mind that this is an exercise to show general knowledge, some things were not paid much attention to:
- iPad UI
- A class was fully Unit Tested but no more than one class, enough to demonstrate genral approach
- Network API was simplified
    - Usually I would expect there to be a call to an endpoint to get the ads list with the simplified data and then another call to another endpoint when opening a detail which would get all the data for that instance only
    - Generally I would also expect that the categories would not be a different call
- Logic could be added to cancel request tasks if data is no longer necessary, due to reusability or leaving the view to background or previous screen, for instance 
- Throw statements could be improved all over
- Currency code should be defined in view model and could come from BE 
- Other options are possible to fetch images, this was a simplified approach
- The work was made on the main branch which is not to be expected in a project scenario
- Other possibilities of showing the text in the detail view. This was chosen for simplification reasons. It does however portray the possibility of such data coming from the backend in an array, even with some attached styling options, which is a common approach, reducing app releases and increasing product iterations
