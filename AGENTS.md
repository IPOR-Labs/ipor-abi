# AGENTS.md

How to read this repository as an AI agent or a script. It is the source of
truth for the addresses and ABIs of contracts deployed by IPOR Labs: IPOR
Fusion (vault factories, fuses, pre-hooks, price feeds, cross-chain
contracts) and the older IPOR Protocol (router, IPOR token, liquidity mining).

## Where things are

```
mainnet/
  addresses.json                    # aggregated, per chain name: protocol contracts plus
                                    # generated lists of vaults, fuses, prehooks, price_oracles
  mainnet-<chain>-fusion/           # IPOR Fusion on one chain: the place to start
    addresses.json                  # { "ContractName": "0x…", … } flat map
    abis/pretty/<Name>.abi.sol      # human-readable ABI (Solidity interface)
    abis/ugly/<Name>.abi.json       # JSON ABI
  mainnet-<chain>/                  # older IPOR Protocol deployments on that chain
  mainnet-<chain>-<name>/           # deployments made for one product or client
chain-id/normal/<chainId>/<address>.abi.json   # JSON ABI by chain id and address
chain-id/pretty/<chainId>/<address>.abi.sol    # the same, human-readable
testnet/                            # test and pilot deployments; never use for mainnet work
scripts/                            # generators of mainnet/addresses.json and the README lists
```

`<chain>` is one of: ethereum, arbitrum, base, unichain, tac, ink, plasma,
avalanche, katana, botanix, hyperevm, robinhood, monad, flare (the top-level
keys of `mainnet/addresses.json`; the `mainnet-<chain>-fusion` folders that
exist are the chains Fusion is deployed on).

Raw file URLs, for tools that fetch instead of cloning:

```
https://raw.githubusercontent.com/IPOR-Labs/ipor-abi/main/mainnet/mainnet-base-fusion/addresses.json
```

Pin a commit sha instead of `main` when a result must be reproducible.

## Rules that prevent reverts

1. **Proxy, not Impl.** Contracts behind a proxy are listed twice: `<Name>Proxy`
   is the address to call, `<Name>Impl` is the implementation behind it.
   Calling an `Impl` directly reverts or reads empty storage. Example: deploy
   vaults with `IporFusionFactoryProxy`; `clone` on `IporFusionFactoryImpl`
   reverts with `DaoFeePackagesArrayEmpty` (`0x8745fbfd`).
2. **One chain, one folder.** An address from `mainnet-base-fusion` is only
   valid on Base (8453). The same name can map to different addresses on
   different chains, and not every name exists on every chain (e.g.
   `BalanceFuseAaveV3` is listed on Base but not on Arbitrum, where the Aave V3
   balance fuse is `AaveV3WithPriceOracleMiddlewareBalanceFuse`). Look the
   name up in the folder of the chain you deploy on.
3. **Fusion work uses `mainnet-<chain>-fusion`.** The per-product folders and
   `testnet/` hold deployments that are not the shared Fusion infrastructure.
4. **A listed fuse is not necessarily an approved one.** Which fuses a vault may
   use on a chain is decided by the on-chain FuseWhitelist
   (`IporFusionFuseWhitelistProxy` in the same `addresses.json`); check it
   before adding a fuse to a vault.
5. **Compare addresses case-insensitively.** Most are checksummed, not all.

## Related

- IPOR Fusion docs: https://ipor.io/docs (index for agents: https://ipor.io/llms.txt)
- Python SDK and CLI, which read these files: https://github.com/IPOR-Labs/ipor-fusion.py
  (`pip install ipor-fusion`)
- Hosted read-only MCP server: https://mcp.ipor.io/mcp
- Smart contracts: https://github.com/IPOR-Labs/ipor-fusion

## Changing this repository

Addresses are added by IPOR Labs when contracts are deployed, in a pull
request per deployment. `scripts/fill-addresses.sh` regenerates
`mainnet/addresses.json` and the fuse lists in `README.md`; do not edit those
generated parts by hand.
