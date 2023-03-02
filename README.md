# voting_system_in_move
## This module has two basic entites:
  
   **Candidate**: A person who is running for election and each candidate has three properties i.e name,candidate_id and vote_count
  
   **Voter**: A pereson who is giving vote and each Voter has four properties i.e name,voter_id,has_voted and candidate_id

## Calculating Result
Two list are formed in order to keep track of the events, one is for the voters and another is for the candidates
In order to decide the winner of the election the "result" function is invoked which firstly assign votes to the candidates which the voter has choosen to elect,then it
calculate the candidate with highest vote count and declare it as a winner


## Testing of the module:

In order to test this module 3 candidates are pushed in candidates_list and 8 voters are pushed in the voters_list.
Then the "result" function is invoked which evaluates the winner and return it.
Then the returned winner is checked using assert ,and if the winner name doesn't match the required answer an error occurs and if the name matches then the test pass.





