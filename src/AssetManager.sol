// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AssetManager {
    // アドレスのリストを保存する配列
    address[] private registeredAddresses;

    // イベント：アドレスが登録された際に発火
    event AddressRegistered(address indexed addr);

    // registAddress関数：入力されたアドレスをリストに追加
    function registAddress(address addr) public {
        // アドレスを配列に追加
        registeredAddresses.push(addr);

        // イベントを発火
        emit AddressRegistered(addr);
    }

    // getRegisteredAddresses関数：登録されたアドレスのリストを取得
    function getRegisteredAddresses() public view returns (address[] memory) {
        return registeredAddresses;
    }

    // getAddressCount関数：登録されたアドレスの数を取得
    function getAddressCount() public view returns (uint256) {
        return registeredAddresses.length;
    }
}
