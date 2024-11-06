# Security policy

## Release cycle

Only the latest minor version of major versions supported in an Ubuntu LTS release receive security support, with only the latest patch of that being supported. Backports to previous minor releases or other unsupported releases are made on a best-effort basis and will typically only be done for critical vulnerabilities.

Additionally, when a major release drops support for an LTS release of Ubuntu, the previous major release will become supported _only_ for that Ubuntu release. For example, say v1.2.0 supports Ubuntu 20.04, 22.04 and 24.04. Then v2.0.0 releases, dropping support for Ubuntu 20.04 in favor of 26.04. After this, v1.2.0 will only receive security fixes for Ubuntu 20.04, while v2.0.0 will receive security fixes for Ubuntu 22.04, 24.04 and 26.04.

Once an LTS release of Ubuntu is sunset, new security fixes for this software will no longer be provided.

## Reporting a vulnerability

To report a security issue, please email [security@ubuntu.com](mailto:security@ubuntu.com) with a description of the issue, the steps you took to create the issue, and, if known, mitigations for the issue.

The [Ubuntu Security disclosure and embargo policy](https://ubuntu.com/security/disclosure-policy) contains more information about what you can expect when you contact us and what we expect from you.
