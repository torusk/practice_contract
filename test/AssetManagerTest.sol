// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/AssetManager.sol";

contract AssetManagerTest is Test {
    AssetManager private assetManager;

    // テストセットアップ：コントラクトをデプロイ
    function setUp() public {
        assetManager = new AssetManager();
    }

    // registAddress関数のテスト
    function testRegistAddress() public {
        // テストアドレス1を登録
        address testAddr1 = address(0x123);
        assetManager.registAddress(testAddr1);

        // 登録結果を確認
        address[] memory addresses = assetManager.getRegisteredAddresses();
        assertEq(addresses.length, 1);
        assertEq(addresses[0], testAddr1);

        // テストアドレス2を登録
        address testAddr2 = address(0x456);
        assetManager.registAddress(testAddr2);

        // 再確認
        addresses = assetManager.getRegisteredAddresses();
        assertEq(addresses.length, 2);
        assertEq(addresses[1], testAddr2);
    }

    // getRegisteredAddresses関数のテスト
    function testGetRegisteredAddresses() public {
        // アドレスを複数登録
        address testAddr1 = address(0x123);
        address testAddr2 = address(0x456);
        assetManager.registAddress(testAddr1);
        assetManager.registAddress(testAddr2);

        // 取得したアドレスリストを確認
        address[] memory addresses = assetManager.getRegisteredAddresses();
        assertEq(addresses.length, 2);
        assertEq(addresses[0], testAddr1);
        assertEq(addresses[1], testAddr2);
    }

    // getAddressCount関数のテスト
    function testGetAddressCount() public {
        // 初期状態でのカウントを確認
        uint256 count = assetManager.getAddressCount();
        assertEq(count, 0);

        // アドレスを登録
        assetManager.registAddress(address(0x123));
        count = assetManager.getAddressCount();
        assertEq(count, 1);

        // さらにアドレスを登録
        assetManager.registAddress(address(0x456));
        count = assetManager.getAddressCount();
        assertEq(count, 2);
    }

    // registAddress関数がイベントを発火するかテスト
    function testRegistAddressEmitsEvent() public {
        // テストアドレス
        address testAddr = address(0x789);

        // イベントの期待値を設定して関数を実行
        vm.expectEmit(true, true, true, true);
        emit AssetManager.AddressRegistered(testAddr);
        assetManager.registAddress(testAddr);
    }
}
