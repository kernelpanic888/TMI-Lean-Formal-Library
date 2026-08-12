#import <Foundation/Foundation.h>
#import <Security/Security.h>

static void fail(NSString *message) {
  fprintf(stderr, "HOLD | %s\n", message.UTF8String);
  exit(2);
}

static NSString *statusMessage(OSStatus status, NSString *operation) {
  CFStringRef raw = SecCopyErrorMessageString(status, NULL);
  NSString *detail = CFBridgingRelease(raw) ?: [NSString stringWithFormat:@"OSStatus %d", (int)status];
  return [NSString stringWithFormat:@"%@: %@", operation, detail];
}

static NSData *tagData(NSString *tag) {
  return [tag dataUsingEncoding:NSUTF8StringEncoding];
}

static SecKeyRef loadPrivateKey(NSString *tag) {
  NSDictionary *query = @{
    (__bridge id)kSecClass: (__bridge id)kSecClassKey,
    (__bridge id)kSecAttrKeyClass: (__bridge id)kSecAttrKeyClassPrivate,
    (__bridge id)kSecAttrApplicationTag: tagData(tag),
    (__bridge id)kSecUseDataProtectionKeychain: @YES,
    (__bridge id)kSecReturnRef: @YES
  };
  CFTypeRef item = NULL;
  OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, &item);
  if (status == errSecItemNotFound) return NULL;
  if (status != errSecSuccess) fail(statusMessage(status, @"load private key"));
  return (SecKeyRef)item;
}

static SecKeyRef createPrivateKey(NSString *tag) {
  CFErrorRef error = NULL;
  SecAccessControlRef access = SecAccessControlCreateWithFlags(
    NULL, kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly,
    kSecAccessControlPrivateKeyUsage, &error);
  if (!access) fail([(__bridge NSError *)error localizedDescription]);
  NSDictionary *attributes = @{
    (__bridge id)kSecAttrKeyType: (__bridge id)kSecAttrKeyTypeECSECPrimeRandom,
    (__bridge id)kSecAttrKeySizeInBits: @256,
    (__bridge id)kSecAttrTokenID: (__bridge id)kSecAttrTokenIDSecureEnclave,
    (__bridge id)kSecUseDataProtectionKeychain: @YES,
    (__bridge id)kSecPrivateKeyAttrs: @{
      (__bridge id)kSecAttrIsPermanent: @YES,
      (__bridge id)kSecAttrApplicationTag: tagData(tag),
      (__bridge id)kSecAttrAccessControl: (__bridge id)access
    }
  };
  SecKeyRef key = SecKeyCreateRandomKey((__bridge CFDictionaryRef)attributes, &error);
  CFRelease(access);
  if (!key) fail([(__bridge NSError *)error localizedDescription]);
  return key;
}

static SecKeyRef ensureHardwareKey(NSString *tag, NSString *publicPath) {
  SecKeyRef key = loadPrivateKey(tag);
  if (!key) key = createPrivateKey(tag);

  CFDictionaryRef rawAttrs = SecKeyCopyAttributes(key);
  NSDictionary *attrs = CFBridgingRelease(rawAttrs);
  id token = attrs[(__bridge id)kSecAttrTokenID];
  if (!token || ![token isEqual:(__bridge id)kSecAttrTokenIDSecureEnclave])
    fail(@"key is not backed by Secure Enclave");

  CFErrorRef privateError = NULL;
  CFDataRef privateData = SecKeyCopyExternalRepresentation(key, &privateError);
  if (privateData) {
    CFRelease(privateData);
    fail(@"private key unexpectedly exportable");
  }
  if (privateError) CFRelease(privateError);

  SecKeyRef publicKey = SecKeyCopyPublicKey(key);
  if (!publicKey) fail(@"public key unavailable");
  CFErrorRef publicError = NULL;
  CFDataRef rawPublic = SecKeyCopyExternalRepresentation(publicKey, &publicError);
  CFRelease(publicKey);
  if (!rawPublic) fail([(__bridge NSError *)publicError localizedDescription]);
  NSData *publicData = CFBridgingRelease(rawPublic);
  NSError *writeError = nil;
  if (![publicData writeToFile:publicPath options:NSDataWritingAtomic error:&writeError])
    fail(writeError.localizedDescription);
  return key;
}

static SecKeyRef importPublicKey(NSString *path) {
  NSData *data = [NSData dataWithContentsOfFile:path];
  if (!data) fail(@"public key file unavailable");
  NSDictionary *attributes = @{
    (__bridge id)kSecAttrKeyType: (__bridge id)kSecAttrKeyTypeECSECPrimeRandom,
    (__bridge id)kSecAttrKeyClass: (__bridge id)kSecAttrKeyClassPublic,
    (__bridge id)kSecAttrKeySizeInBits: @256
  };
  CFErrorRef error = NULL;
  SecKeyRef key = SecKeyCreateWithData((__bridge CFDataRef)data,
    (__bridge CFDictionaryRef)attributes, &error);
  if (!key) fail([(__bridge NSError *)error localizedDescription]);
  return key;
}

static NSData *readData(NSString *path, NSString *label) {
  NSData *data = [NSData dataWithContentsOfFile:path];
  if (!data) fail([NSString stringWithFormat:@"%@ unavailable", label]);
  return data;
}

int main(int argc, const char *argv[]) {
  @autoreleasepool {
    if (argc == 4 && strcmp(argv[1], "ensure") == 0) {
      SecKeyRef key = ensureHardwareKey(@(argv[2]), @(argv[3]));
      CFRelease(key);
      puts("SECURE_ENCLAVE_READY");
      return 0;
    }
    if (argc == 6 && strcmp(argv[1], "sign") == 0) {
      NSString *tag = @(argv[2]);
      NSString *payloadPath = @(argv[3]);
      NSString *signaturePath = @(argv[4]);
      NSString *publicPath = @(argv[5]);
      SecKeyRef key = ensureHardwareKey(tag, publicPath);
      NSData *payload = readData(payloadPath, @"payload");
      CFErrorRef error = NULL;
      CFDataRef rawSignature = SecKeyCreateSignature(key,
        kSecKeyAlgorithmECDSASignatureMessageX962SHA256,
        (__bridge CFDataRef)payload, &error);
      CFRelease(key);
      if (!rawSignature) fail([(__bridge NSError *)error localizedDescription]);
      NSData *signature = CFBridgingRelease(rawSignature);
      NSError *writeError = nil;
      if (![signature writeToFile:signaturePath options:NSDataWritingAtomic error:&writeError])
        fail(writeError.localizedDescription);
      puts("SECURE_ENCLAVE_SIGNED");
      return 0;
    }
    if (argc == 5 && strcmp(argv[1], "verify") == 0) {
      SecKeyRef key = importPublicKey(@(argv[2]));
      NSData *payload = readData(@(argv[3]), @"payload");
      NSData *signature = readData(@(argv[4]), @"signature");
      CFErrorRef error = NULL;
      bool valid = SecKeyVerifySignature(key,
        kSecKeyAlgorithmECDSASignatureMessageX962SHA256,
        (__bridge CFDataRef)payload, (__bridge CFDataRef)signature, &error);
      CFRelease(key);
      if (!valid) fail([(__bridge NSError *)error localizedDescription]);
      puts("SECURE_ENCLAVE_SIGNATURE_VALID");
      return 0;
    }
    fail(@"usage: ensure <tag> <public> | sign <tag> <payload> <signature> <public> | verify <public> <payload> <signature>");
  }
}
