// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AssetManager {
    // アドレスのリストを保存する配列
    address[] private registeredAddresses;

    // イベント：アドレスが登録された際に発火
    event AddressRegistered(address indexed addr);

    // registAddress関数：入力されたアドレスをリストに追加
    function registAddress(address addr) public {
        // 配列内にアドレスが存在するかチェック
        for (uint i = 0; i < registeredAddresses.length; i++) {
            if (registeredAddresses[i] == addr) {
                revert("Address is already registered");
            }
        }
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

    // アドレスごとの資産を管理するmapping
    mapping(address => uint256) private assets;

    // イベント：資産が登録または更新された際に発火
    event AssetUpdated(address indexed addr, uint256 amount);

    // addAsset関数：資産を登録または更新する
    function addAsset(uint256 amount) public {
        // 呼び出し元アドレスが登録されているか確認
        bool isRegistered = false;
        for (uint i = 0; i < registeredAddresses.length; i++) {
            if (registeredAddresses[i] == msg.sender) {
                isRegistered = true;
                break;
            }
        }

        if (!isRegistered) {
            revert("Address is not registered");
        }

        // 資産を追加または更新
        assets[msg.sender] += amount;

        // イベントを発火
        emit AssetUpdated(msg.sender, assets[msg.sender]);
    }

    // getAsset関数：指定されたアドレスの資産額を取得
    function getAsset(address addr) public view returns (uint256) {
        return assets[addr];
    }

    mapping(address => bytes[]) private documentHashes;

    // addAsset関数：資産を登録または更新する
    function addAssetWithHash(uint256 amount, bytes calldata hashvalue) public {
        // 呼び出し元アドレスが登録されているか確認
        bool isRegistered = false;
        for (uint i = 0; i < registeredAddresses.length; i++) {
            if (registeredAddresses[i] == msg.sender) {
                isRegistered = true;
                break;
            }
        }

        if (!isRegistered) {
            revert("Address is not registered");
        }

        // ハッシュが登録されているか確認
        bool isHashRegistered = false;
        for (uint i = 0; i < documentHashes[msg.sender].length; i++) {
            for (uint j = 0; j < 32; j++) {
                if (documentHashes[msg.sender][i][j] != hashvalue[j]) {
                    break;
                }
                if (j == 31) {
                    isHashRegistered = true;
                }
            }
            if (isHashRegistered) {
                break;
            }
        }
        if (isHashRegistered) {
            revert("Hash is already registered");
        }

        // 資産を追加または更新
        assets[msg.sender] += amount;

        // ハッシュを配列に追加
        documentHashes[msg.sender].push(hashvalue);

        // イベントを発火
        emit AssetUpdated(msg.sender, assets[msg.sender]);
    }

    function getHash(address addr) public view returns (bytes[] memory) {
        return documentHashes[addr];
    }
}
