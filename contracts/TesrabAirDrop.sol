pragma solidity ^0.4.20;
import "./Ownable.sol";
import "./TesrabNetworkToken.sol";

contract TesrabAirDrop is Ownable {
  
    uint public numDrops;
    uint public dropAmount;

    function TesrabAirDrop( address dropper ) private {
        transferOwnership(dropper);
  }

    event TokenDrop( address receiver, uint amount );
    function public airDrop( ERC20Interface token,
        address   tokenRepo,
        address[] recipients,
        uint amount,
        bool kgt,
        KyberGenesisToken kgtToken ) onlyOwner {
    require( amount == 0 || amount == (2*(10**18)) || amount == (5*(10**18)) );

    if( amount > 0 ) {
      for( uint i = 0 ; i < recipients.length ; i++ ) {
          assert( token.transferFrom( tokenRepo, recipients[i], amount ) );
          TokenDrop( recipients[i], amount );
      }
    }

    if( tnt ) {
      tntToken.mint(recipients);
    }

    numDrops += recipients.length;
    dropAmount += recipients.length * amount;
  }

  function tranferMinterOwnership( KyberGenesisToken kgtToken, address newOwner ) onlyOwner {
    tntToken.transferOwnership(newOwner);
  }

  function emergencyERC20Drain( ERC20Interface token, uint amount ) {
      // callable by anyone
      address tesrabMultisig = 0x3EB01B3391EA15CE752d01Cf3D3F09deC596F650;
      token.transfer( tesrabMultisig, amount );
  }
}
