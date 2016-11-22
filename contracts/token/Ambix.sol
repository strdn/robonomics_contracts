pragma solidity ^0.4.4;
import 'token/TokenEmission.sol';
import 'common/Mortal.sol';
/**
  @dev Ambix contract is used for morph Token set to another
  Token's by rule (recipe). In distillation process given
  Token's are burned and result generated by emission.
  
  The recipe presented as equation in form:
  (N1 * A1 | N'1 * A'1 | N''1 * A''1 ...)
  & (N2 * A2 | N'2 * A'2 | N''2 * A''2 ...) ...
  & (Nn * An | N'n * A'n | N''n * A''n ...)
  = M1 * B1 & M2 * B2 ... & Mm * Bm 
    where A, B - input and output tokens
          N, M - token value coeficients
          n, m - input / output dimetion size 
          | - is alternative operator (logical OR)
          & - is associative operator (logical AND)
  This says that `Ambix` should receive (approve) left
  part of equation and send (transfer) right part.
*/
contract Ambix is Mortal {
    /* Recipe fields */
    TokenEmission[][] public rSource;
    uint[][]          public rSourceCoef;
    TokenEmission[]   public rSink;
    uint[]            public rSinkCoef;
    /* Recipe end */

    /**
     * @dev Set source by index
     * @param _index is a source index
     * @param _source is a list of source alternatives
     * @param _coef is a list of source alternatives coeficients
     */
    function setSource(uint _index, TokenEmission[] _source, uint[] _coef) onlyOwner {
        if (_source.length != _coef.length) throw;

        // Lenght fix
        if (rSource.length < _index + 1) {
            rSource.length = _index + 1;
            rSourceCoef.length = _index + 1;
        }

        // Push values
        delete rSource[_index];
        delete rSourceCoef[_index];
        for (uint i = 0; i < _source.length; ++i) {
            rSource[_index].push(_source[i]);
            rSourceCoef[_index].push(_coef[i]);
        }
    }

    /**
     * @dev Set sink
     * @param _sink is a list of sink tokens
     * @param _coef is a list of sink coeficients
     */
    function setSink(TokenEmission[] _sink, uint[] _coef) onlyOwner {
        if (_sink.length != _coef.length) throw;

        delete rSink;
        delete rSource;
        for (uint i = 0; i < _sink.length; ++i) {
            rSink.push(_sink[i]);
            rSinkCoef.push(_coef[i]);
        }
    }

    /**
     * @dev Run distillation process
     * @notice Input tokens(any one of alternative) should be approved to this
     */
    function run() {
        TokenEmission token;
        uint value;
        uint i;
        uint j;

        // Take a source tokens
        for (i = 0; i < rSource.length; ++i) {
            bool tokenBurned = false;

            // Try to transfer alternatives and burn it
            for (j = 0; j < rSource[i].length; ++j) {
                token = rSource[i][j];
                value = rSourceCoef[i][j];
                if (token.transferFrom(msg.sender, this, value)) {
                    token.burn(value);
                    tokenBurned = true;
                    break;
                }
            }

            if (!tokenBurned) throw;
        }

        // Generate sink tokens
        for (i = 0; i < rSink.length; ++i) {
            token = rSink[i];
            value = rSinkCoef[i];
            token.emission(value);
            if (!token.transfer(msg.sender, value)) throw;
        }
    }
}
