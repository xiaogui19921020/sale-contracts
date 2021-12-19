// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IERC20.sol";
import "./Safemath.sol";
import "./Ownable.sol";
contract GraySale is Ownable{

    using SafeMath for uint256;
    IERC20 public dai;
    uint256 public daiprice = 1000000000000000000;
    mapping(uint=>address[]) public userBetArr;


    modifier callerIsUser() {
        require(tx.origin == msg.sender, "The caller is another contract");
        _;
    }

    

    function bet(uint16 amount,uint number) callerIsUser
        external
    {
        userBetArr[number].push(msg.sender);
        uint256 totalMintDAIPrice = daiprice.mul(amount);
        dai.transferFrom(msg.sender, address(this), totalMintDAIPrice);
    }


    function setDAIAddress(address _daiAddr) onlyOwner external onlyOwner{
        dai = IERC20(_daiAddr);
    }

    function withdrawDAI(address _to, uint256 _amount) external onlyOwner {
        dai.transfer(_to, _amount);
    }


    function rand(uint256 _length) public view returns(uint256) {
        uint256 random = uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp)));
        return random%_length;
    }

    function draw() public view returns(uint256) {
        return rand(100000000) % 2;
    }

    
}