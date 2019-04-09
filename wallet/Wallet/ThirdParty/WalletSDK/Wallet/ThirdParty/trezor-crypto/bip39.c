

#include <string.h>
#include <stdbool.h>

#include "bip39.h"
#include "hmac.h"
#include "rand.h"
#include "sha2.h"
#include "pbkdf2.h"
#include "bip39_english.h"
#include "options.h"

#if USE_BIP39_CACHE

static int bip39_cache_index = 0;

static struct {
	bool set;
	char mnemonic[256];
	char passphrase[64];
	uint8_t seed[512 / 8];
} bip39_cache[BIP39_CACHE_SIZE];

#endif

const char *mnemonic_generate(int strength)
{
	if (strength % 32 || strength < 128 || strength > 256) {
		return 0;
	}
	uint8_t data[32];
	random_buffer(data, 32);
	return mnemonic_from_data(data, strength / 8);
}

const uint16_t *mnemonic_generate_indexes(int strength)
{
	if (strength % 32 || strength < 128 || strength > 256) {
		return 0;
	}
	uint8_t data[32];
	random_buffer(data, 32);
	return mnemonic_from_data_indexes(data, strength / 8);
}

const char *mnemonic_from_data(const uint8_t *data, int len)
{
	if (len % 4 || len < 16 || len > 32) {
		return 0;
	}

	uint8_t bits[32 + 1];

	sha256_Raw(data, len, bits);
	// checksum
	bits[len] = bits[0];
	// data
	memcpy(bits, data, len);

	int mlen = len * 3 / 4;
	static char mnemo[24 * 10];

	int i, j, idx;
	char *p = mnemo;
	for (i = 0; i < mlen; i++) {
		idx = 0;
		for (j = 0; j < 11; j++) {
			idx <<= 1;
			idx += (bits[(i * 11 + j) / 8] & (1 << (7 - ((i * 11 + j) % 8)))) > 0;
		}
		strcpy(p, wordlist[idx]);
		p += strlen(wordlist[idx]);
		*p = (i < mlen - 1) ? ' ' : 0;
		p++;
	}

	return mnemo;
}

const uint16_t *mnemonic_from_data_indexes(const uint8_t *data, int len)
{
	if (len % 4 || len < 16 || len > 32) {
		return 0;
	}

	uint8_t bits[32 + 1];

	sha256_Raw(data, len, bits);
	// checksum
	bits[len] = bits[0];
	// data
	memcpy(bits, data, len);

	int mlen = len * 3 / 4;
	static uint16_t mnemo[24];

	int i, j, idx;
	for (i = 0; i < mlen; i++) {
		idx = 0;
		for (j = 0; j < 11; j++) {
			idx <<= 1;
			idx += (bits[(i * 11 + j) / 8] & (1 << (7 - ((i * 11 + j) % 8)))) > 0;
		}
		mnemo[i] = idx;
	}

	return mnemo;
}

int data_from_mnemonic(const char *mnemonic, uint8_t *data) {
    if (!mnemonic) {
        return 0;
    }
    
    uint32_t i, n;
    
    i = 0; n = 0;
    while (mnemonic[i]) {
        if (mnemonic[i] == ' ') {
            n++;
        }
        i++;
    }
    n++;
    // check number of words
    if (n != 12 && n != 15 && n != 18 && n != 21 && n != 24) {
        return 0;
    }
    
    if (n % 3 != 0) {
        return 0;
    }
    char current_word[10];
    uint32_t j, k, ki, bi;
    //uint8_t bits[32 + 1];
    memset(data, 0, MAXIMUM_BIP39_DATA_LENGTH);
    i = 0; bi = 0;
    while (mnemonic[i]) {
        j = 0;
        while (mnemonic[i] != ' ' && mnemonic[i] != 0) {
            if (j >= sizeof(current_word) - 1) {
                return 0;
            }
            current_word[j] = mnemonic[i];
            i++; j++;
        }
        current_word[j] = 0;
        if (mnemonic[i] != 0) i++;
        k = 0;
        for (;;) {
            if (!wordlist[k]) { // word not found
                return 0;
            }
            if (strcmp(current_word, wordlist[k]) == 0) { // word found on index k
                for (ki = 0; ki < 11; ki++) {
                    if (k & (1 << (10 - ki))) {
                        data[bi / 8] |= 1 << (7 - (bi % 8));
                    }
                    bi++;
                }
                break;
            }
            k++;
        }
    }
    
    if (bi != n * 11) {
        return 0;
    }
    
    char expectedChecksum = data[n * 4 / 3];

    // Compute the checksum
    uint8_t computedChecksum[SHA256_DIGEST_LENGTH];
    sha256_Raw(data, n * 4 / 3, computedChecksum);
    
    // Compute checksum mask
    int mask = 0;
    for (int i = 0; i < (n / 3); i++) {
        mask |= (0x80 >> i);
    }
    
    // Check checksum bits
    if ((computedChecksum[0] & mask) != (expectedChecksum & mask)) {
        return 0;
    }

    return n * 4 / 3;
}


int mnemonic_check(const char *mnemonic)
{
    uint8_t data[MAXIMUM_BIP39_DATA_LENGTH];
    int length = data_from_mnemonic(mnemonic, data);
    memset(data, 0, MAXIMUM_BIP39_DATA_LENGTH);
    return (length > 0);
}

// passphrase must be at most 256 characters or code may crash
void mnemonic_to_seed(const char *mnemonic, const char *passphrase, uint8_t seed[512 / 8], void (*progress_callback)(uint32_t current, uint32_t total))
{
	int passphraselen = (int)strlen(passphrase);
#if USE_BIP39_CACHE
	int mnemoniclen = (int)strlen(mnemonic);
	// check cache
	if (mnemoniclen < 256 && passphraselen < 64) {
		for (int i = 0; i < BIP39_CACHE_SIZE; i++) {
			if (!bip39_cache[i].set) continue;
			if (strcmp(bip39_cache[i].mnemonic, mnemonic) != 0) continue;
			if (strcmp(bip39_cache[i].passphrase, passphrase) != 0) continue;
			// found the correct entry
			memcpy(seed, bip39_cache[i].seed, 512 / 8);
			return;
		}
	}
#endif
	uint8_t salt[8 + 256];
	memcpy(salt, "mnemonic", 8);
	memcpy(salt + 8, passphrase, passphraselen);
	PBKDF2_HMAC_SHA512_CTX pctx;
	pbkdf2_hmac_sha512_Init(&pctx, (const uint8_t *)mnemonic, (int)strlen(mnemonic), salt, passphraselen + 8);
	if (progress_callback) {
		progress_callback(0, BIP39_PBKDF2_ROUNDS);
	}
	for (int i = 0; i < 16; i++) {
		pbkdf2_hmac_sha512_Update(&pctx, BIP39_PBKDF2_ROUNDS / 16);
		if (progress_callback) {
			progress_callback((i + 1) * BIP39_PBKDF2_ROUNDS / 16, BIP39_PBKDF2_ROUNDS);
		}
	}
	pbkdf2_hmac_sha512_Final(&pctx, seed);
#if USE_BIP39_CACHE
	// store to cache
	if (mnemoniclen < 256 && passphraselen < 64) {
		bip39_cache[bip39_cache_index].set = true;
		strcpy(bip39_cache[bip39_cache_index].mnemonic, mnemonic);
		strcpy(bip39_cache[bip39_cache_index].passphrase, passphrase);
		memcpy(bip39_cache[bip39_cache_index].seed, seed, 512 / 8);
		bip39_cache_index = (bip39_cache_index + 1) % BIP39_CACHE_SIZE;
	}
#endif
}

const char * const *mnemonic_wordlist(void)
{
	return wordlist;
}
