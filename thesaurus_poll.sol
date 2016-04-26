import 'token.sol';
import 'voting.sol';
import 'agent_storage.sol';

contract ThesaurusPoll is Mortal {
    /* Operating agent storage with thesaurus */
    HumanAgentStorage agentStorage;

    /* Government shares */
    Token shares;

    /* Mapping for fast term access */
    mapping(string => Voting.Poll) termOf;

    /* Use Voting library */
    using Voting for Voting.Poll;
    
    /**
     * @dev ThesaurusPoll construction
     */
    function ThesaurusPoll(HumanAgentStorage _has, Token _shares) {
        agentStorage = _has;
        shares = _shares;
    }

    /**
     * @dev Calc poll of target term and set thesaurus according
     *      to high vote results
     * @param _termName the name of calc term
     */
    function updateThesaurus(string _termName) internal {
        var term = termOf[_termName];

        // Check for knowledge already set
		var current = Knowledge(term.current);
        if (agentStorage.getKnowledgeByName(_termName) != current)
            agentStorage.appendKnowledgeByName(_termName, current);
    }

    /**
     * @dev Increase poll for given term
     * @param _termName name of term
     * @param _value knowledge presents given term
     * @param _count how much shares given for increase
     * @notice Given knownledge should be `finalized`
     */
    function pollUp(string _termName, Knowledge _value, uint _count) {
        // So throw when knowledge is not finalized 
        if (!_value.isFinalized()) throw;

        // Poll up given term name
        var voter = msg.sender;
        var term = termOf[_termName];
        term.up(voter, _value, shares, _count);

        // Update thesaurus
        updateThesaurus(_termName);
    }

    /**
     * @dev Decrease shares for given term
     * @param _termName name of term
     * @param _count count of refunded shares
     */
    function pollDown(string _termName, uint _count) {
        // Poll down given term name
        var voter = msg.sender;
        var term = termOf[_termName];
        term.down(voter, shares, _count);

        // Update thesaurus
        updateThesaurus(_termName);
    }
}
