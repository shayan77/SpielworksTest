//
//  Account.swift
//  eosio
//
//  Created by Shayanairmee01 on 2022-03-27.
//

import Foundation

// MARK: - Account
struct Account: Codable {
    let accountName: String?
    let headBlockNum: Int?
    let headBlockTime: String?
    let privileged: Bool?
    let lastCodeUpdate, created, coreLiquidBalance: String?
    let ramQuota, netWeight, cpuWeight: Int?
    let netLimit, cpuLimit: Limit?
    let ramUsage: Int?
    let permissions: [PermissionElement]?
    let totalResources: TotalResources?
    let selfDelegatedBandwidth: SelfDelegatedBandwidth?
    let voterInfo: VoterInfo?
    let subjectiveCPUBillLimit: Limit?

    enum CodingKeys: String, CodingKey {
        case accountName = "account_name"
        case headBlockNum = "head_block_num"
        case headBlockTime = "head_block_time"
        case privileged
        case lastCodeUpdate = "last_code_update"
        case created
        case coreLiquidBalance = "core_liquid_balance"
        case ramQuota = "ram_quota"
        case netWeight = "net_weight"
        case cpuWeight = "cpu_weight"
        case netLimit = "net_limit"
        case cpuLimit = "cpu_limit"
        case ramUsage = "ram_usage"
        case permissions
        case totalResources = "total_resources"
        case selfDelegatedBandwidth = "self_delegated_bandwidth"
        case voterInfo = "voter_info"
        case subjectiveCPUBillLimit = "subjective_cpu_bill_limit"
    }
}

// MARK: - Limit
struct Limit: Codable {
    let used, available, max: Int?
}

// MARK: - PermissionElement
struct PermissionElement: Codable {
    let permName, parent: String?
    let requiredAuth: RequiredAuth?

    enum CodingKeys: String, CodingKey {
        case permName = "perm_name"
        case parent
        case requiredAuth = "required_auth"
    }
}

// MARK: - RequiredAuth
struct RequiredAuth: Codable {
    let threshold: Int?
    let keys: [Key]?
    let accounts: [AccountElement]?
}

// MARK: - AccountElement
struct AccountElement: Codable {
    let permission: AccountPermission?
    let weight: Int?
}

// MARK: - AccountPermission
struct AccountPermission: Codable {
    let actor, permission: String?
}

// MARK: - Key
struct Key: Codable {
    let key: String?
    let weight: Int?
}

// MARK: - SelfDelegatedBandwidth
struct SelfDelegatedBandwidth: Codable {
    let from, to, netWeight, cpuWeight: String?

    enum CodingKeys: String, CodingKey {
        case from, to
        case netWeight = "net_weight"
        case cpuWeight = "cpu_weight"
    }
}

// MARK: - TotalResources
struct TotalResources: Codable {
    let owner, netWeight, cpuWeight: String?
    let ramBytes: Int?

    enum CodingKeys: String, CodingKey {
        case owner
        case netWeight = "net_weight"
        case cpuWeight = "cpu_weight"
        case ramBytes = "ram_bytes"
    }
}

// MARK: - VoterInfo
struct VoterInfo: Codable {
    let owner, proxy: String?
    let staked: Int?
    let lastVoteWeight, proxiedVoteWeight: String?
    let isProxy, flags1, reserved2: Int?
    let reserved3: String?

    enum CodingKeys: String, CodingKey {
        case owner, proxy, staked
        case lastVoteWeight = "last_vote_weight"
        case proxiedVoteWeight = "proxied_vote_weight"
        case isProxy = "is_proxy"
        case flags1, reserved2, reserved3
    }
}



