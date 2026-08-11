import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:cryptography/cryptography.dart';

/// Verifies the authenticity and integrity of a downloaded package archive
/// BEFORE it is ever imported. Two independent checks must both pass:
///   1. **SHA-256 checksum** — the bytes match the manifest (integrity).
///   2. **Ed25519 signature** — the bytes were signed by the trusted key
///      (authenticity). The app holds only the PUBLIC key.
///
/// If either check fails, the package is rejected and the caller deletes the
/// downloaded bytes. Unsigned packages are never trusted.
class PackageVerifier {
  PackageVerifier({PackageSignatureVerifier? signatureVerifier})
      : signatureVerifier =
            signatureVerifier ?? const Ed25519SignatureVerifier();

  final PackageSignatureVerifier signatureVerifier;

  /// Hex-encoded SHA-256 of [bytes].
  String sha256Hex(List<int> bytes) => sha256.convert(bytes).toString();

  /// True if [bytes] hash to [expectedHex] (case-insensitive).
  bool verifyChecksum(List<int> bytes, String expectedHex) {
    final actual = sha256Hex(bytes);
    return _constantTimeEquals(actual, expectedHex.trim().toLowerCase());
  }

  /// Verifies the package: checksum first, then signature. Returns a result
  /// describing exactly what failed so callers can show the right message and
  /// safely clean up. Never throws for bad input.
  Future<PackageVerificationResult> verify({
    required List<int> bytes,
    required String expectedSha256,
    required String signatureBase64,
    required String publicKeyBase64,
  }) async {
    if (!verifyChecksum(bytes, expectedSha256)) {
      return PackageVerificationResult.checksumFailed;
    }
    if (publicKeyBase64.trim().isEmpty || signatureBase64.trim().isEmpty) {
      // No key or no signature → we refuse to trust the package.
      return PackageVerificationResult.signatureFailed;
    }
    try {
      final sig = base64Decode(signatureBase64.trim());
      final pub = base64Decode(publicKeyBase64.trim());
      final ok = await signatureVerifier.verify(
        data: bytes,
        signature: sig,
        publicKey: pub,
      );
      return ok
          ? PackageVerificationResult.ok
          : PackageVerificationResult.signatureFailed;
    } catch (_) {
      // Malformed base64/key/signature → treat as a failed signature.
      return PackageVerificationResult.signatureFailed;
    }
  }

  static bool _constantTimeEquals(String a, String b) {
    if (a.length != b.length) return false;
    var diff = 0;
    for (var i = 0; i < a.length; i++) {
      diff |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
    }
    return diff == 0;
  }
}

/// The outcome of verifying a package.
enum PackageVerificationResult { ok, checksumFailed, signatureFailed }

/// Pluggable signature verification so the algorithm can evolve without
/// touching callers. The app never holds a private key.
abstract class PackageSignatureVerifier {
  Future<bool> verify({
    required List<int> data,
    required List<int> signature,
    required List<int> publicKey,
  });
}

/// Ed25519 signature verification (pure Dart, offline). The public key and
/// signature are raw bytes (32 and 64 bytes respectively).
class Ed25519SignatureVerifier implements PackageSignatureVerifier {
  const Ed25519SignatureVerifier();

  @override
  Future<bool> verify({
    required List<int> data,
    required List<int> signature,
    required List<int> publicKey,
  }) async {
    if (publicKey.length != 32 || signature.length != 64) return false;
    final algorithm = Ed25519();
    final pub =
        SimplePublicKey(publicKey, type: KeyPairType.ed25519);
    return algorithm.verify(
      data,
      signature: Signature(signature, publicKey: pub),
    );
  }
}
