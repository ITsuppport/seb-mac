//
//  SEBKeychainManager.h
//  SafeExamBrowser
//
//  Created by Daniel R. Schneider on 07.11.12.
//
//

#include <Security/Security.h>
#import <CommonCrypto/CommonDigest.h>
//#import <Security/SecRandom.h> //for SecRandom


@interface SEBKeychainManager : NSObject

- (NSArray*) getIdentities;
- (NSArray*) getCertificates;
- (NSData*) getPublicKeyHashFromCertificate:(SecCertificateRef)certificate;
- (SecKeyRef) getPrivateKeyFromPublicKeyHash:(NSData*)publicKeyHash;
- (SecKeyRef*) copyPublicKeyFromCertificate:(SecCertificateRef)certificate;
- (SecIdentityRef) createIdentityWithCertificate:(SecCertificateRef)certificate;
- (SecKeyRef) privateKeyFromIdentity:(SecIdentityRef*)identityRef;

//- (NSData*)encryptData:(NSData*)inputData withPublicKey:(SecKeyRef*)publicKey;
- (NSData*) encryptData:(NSData*)plainData withPublicKeyFromCertificate:(SecCertificateRef)certificate;
- (NSData*) decryptData:(NSData*)cipherData withPrivateKey:(SecKeyRef)privateKey;
- (NSString*) generateSHAHashString:(NSString*)inputString;

@end