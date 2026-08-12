# I³-L10: fault-domain independence and quorum liveness

L09 proves that a threshold of distinct authenticated witness identities voted
for one anchor. L10 asks whether those identities can fail together.

## Admission rule

An admission requires all L09 conditions plus pairwise distinct declared
administrative, network and host domains among the votes used by the
certificate. The signed vote also binds the digest of the complete domain
policy. Relabelling a domain after a vote therefore invalidates the vote.

```text
ADMIT = threshold signatures
      AND one target
      AND distinct(adminDomain)
      AND distinct(networkDomain)
      AND distinct(hostDomain)
```

## Liveness rule

Safety and availability are separate. A policy is live for the current
availability set only if that set contains an independent subset whose size is
the configured threshold. A 2-of-3 policy can therefore survive one unavailable
witness only when the remaining pair is independent in every required domain.

## Executable protocol

`i3_domain_quorum vote` signs the policy digest, round, witness/key identity,
generation, receipt HEAD and checkpoint digest. `admit` emits a certificate only
after both signature and domain checks. `verify` reproduces the certificate from
the policy, target and signed vote corpus.

## Honest boundary

Lean proves the decision rule over supplied labels. A configuration file does
not establish real physical, organisational, administrative or network
independence. Deployment evidence, key custody audits and transport tests are
required. The layer does not prove Byzantine safety above the threshold, OS or
OpenSSL correctness, consciousness, digital life or true AI.
