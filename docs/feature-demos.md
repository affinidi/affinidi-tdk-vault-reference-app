# Feature Demonstrations

Each section below documents one interactive feature built into this reference app.

<details open id="panel-claim-credentials">
<summary><strong>Claim Credential</strong></summary>

Claim a Verifiable Credential from an issuer using the OID4VCI flow. You share your DID with the credential issuer, who returns a credential offer. You paste the offer URL, review the credential details, and save it into your vault, ready to be shared.

<table>
<tr>
<td align="center" width="33%"><strong>1. Open your Vault</strong></td>
<td align="center" width="33%"><strong>2. Open your profile</strong></td>
<td align="center" width="33%"><strong>3. Go to Claimed Credentials</strong></td>
</tr>
<tr>
<td align="center" width="33%"><img src="../assets/images/claim-credentials/open-vault.png" alt="Open your Vault to claim a credential" /></td>
<td align="center" width="33%"><img src="../assets/images/claim-credentials/open-profile.png" alt="Open your profile" /></td>
<td align="center" width="33%"><img src="../assets/images/claim-credentials/goto-claimed-credentials.png" alt="Go to Claimed Credentials" /></td>
</tr>
<tr>
<td align="center" width="33%"><strong>4. Tap + to claim a credential</strong></td>
<td align="center" width="33%"><strong>5. Paste the credential offer URL</strong></td>
<td align="center" width="33%"><strong>6. Review the credential details</strong></td>
</tr>
<tr>
<td align="center" width="33%"><img src="../assets/images/claim-credentials/claim-credential.png" alt="Tap plus to claim a credential" /></td>
<td align="center" width="33%"><img src="../assets/images/claim-credentials/paste-credential-offer-url.png" alt="Paste the credential offer URL from the issuer" /></td>
<td align="center" width="33%"><img src="../assets/images/claim-credentials/review-credential-details-before-saving.png" alt="Review the credential details before saving" /></td>
</tr>
<tr>
<td align="center" width="33%"><strong>7. Save it to your vault</strong></td>
<td align="center" width="33%"><strong>8. Credential saved, ready to share</strong></td>
<td align="center" width="33%"></td>
</tr>
<tr>
<td align="center" width="33%"><img src="../assets/images/claim-credentials/save-credential.png" alt="Save the credential to your vault" /></td>
<td align="center" width="33%"><img src="../assets/images/claim-credentials/credential-saved-and-can-be-shared.png" alt="Credential saved and ready to be shared" /></td>
<td align="center" width="33%"></td>
</tr>
</table>

</details>

<details open id="panel-vault-backup-restore">
<summary><strong>Vault Backup and Restore</strong></summary>

Export an encrypted JSON backup from the vault list and restore it on the same or another device. The backup includes vault data, local profiles, credentials, files, and consent history. Cloud profile data is excluded from this local backup flow.

### Back up a vault

1. Open the vault list.
2. Tap the backup action on the vault card.
3. Enter the vault passphrase.
4. Save the encrypted JSON backup file.

### Restore a vault

1. Open the vault list.
2. Tap **Restore Vault**.
3. Choose the JSON backup file.
4. Enter the vault passphrase.
5. Confirm or edit the restored vault name.
6. Open the restored vault and verify its local profiles, credentials, files, and consent history.

The app rejects invalid backup files, incorrect passphrases, and backups whose wallet seed is already present on the device.

### Backup and restore screenshots

<table>
<tr>
<td align="center" width="33%"><strong>1. Vault list</strong></td>
<td align="center" width="33%"><strong>2. Enter backup passphrase</strong></td>
<td align="center" width="33%"><strong>3. Save backup</strong></td>
</tr>
<tr>
<td align="center" width="33%"><img src="../assets/images/backup-restore/vault-list.png" alt="Vault list with backup action" /></td>
<td align="center" width="33%"><img src="../assets/images/backup-restore/backup-with-passphrase.png" alt="Enter the vault passphrase for backup" /></td>
<td align="center" width="33%"><img src="../assets/images/backup-restore/backup-save.png" alt="Save the vault backup file" /></td>
</tr>
<tr>
<td align="center" width="33%"><strong>4. Backup saved</strong></td>
<td align="center" width="33%"><strong>5. Start restore</strong></td>
<td align="center" width="33%"><strong>6. Choose backup</strong></td>
</tr>
<tr>
<td align="center" width="33%"><img src="../assets/images/backup-restore/backup-save-confirmation.png" alt="Backup saved confirmation" /></td>
<td align="center" width="33%"><img src="../assets/images/backup-restore/restore.png" alt="Start restoring a vault" /></td>
<td align="center" width="33%"><img src="../assets/images/backup-restore/restore-selected-vault.png" alt="Choose a vault backup to restore" /></td>
</tr>
<tr>
<td align="center" width="33%"><strong>7. Restore form</strong></td>
<td align="center" width="33%"><strong>8. Restore success</strong></td>
<td align="center" width="33%"><strong>9. Restored vault list</strong></td>
</tr>
<tr>
<td align="center" width="33%"><img src="../assets/images/backup-restore/choose-vault-to-restore.png" alt="Enter the restore passphrase and vault name" /></td>
<td align="center" width="33%"><img src="../assets/images/backup-restore/vault-restored-successfully.png" alt="Vault restored successfully" /></td>
<td align="center" width="33%"><img src="../assets/images/backup-restore/vault-list-after-restore.png" alt="Vault list after restoring a vault" /></td>
</tr>
<tr>
<td align="center" width="33%"><strong>10. Wrong passphrase</strong></td>
<td align="center" width="33%"><strong>11. Duplicate restore</strong></td>
<td align="center" width="33%"></td>
</tr>
<tr>
<td align="center" width="33%"><img src="../assets/images/backup-restore/restore-with-wrong-passphrase.png" alt="Restore with an incorrect passphrase" /></td>
<td align="center" width="33%"><img src="../assets/images/backup-restore/restore-existing-vault-error.png" alt="Duplicate vault restore error" /></td>
<td align="center" width="33%"></td>
</tr>
</table>

### Vault removal

<table>
<tr>
<td align="center" width="50%"><strong>Delete a vault</strong></td>
<td align="center" width="50%"><strong>Vault list after deletion</strong></td>
</tr>
<tr>
<td align="center" width="50%"><img src="../assets/images/backup-restore/delete-vault.png" alt="Delete a vault" /></td>
<td align="center" width="50%"><img src="../assets/images/backup-restore/vault-list-after-deletion.png" alt="Vault list after deletion" /></td>
</tr>
</table>

### Consent history

<table>
<tr>
<td align="center" width="33%"><strong>1. Consent history</strong></td>
<td align="center" width="33%"><strong>2. Delete consent record</strong></td>
<td align="center" width="33%"><strong>3. History after deletion</strong></td>
</tr>
<tr>
<td align="center" width="33%"><img src="../assets/images/backup-restore/consent-history.png" alt="Consent history" /></td>
<td align="center" width="33%"><img src="../assets/images/backup-restore/consent-delete.png" alt="Delete a consent record" /></td>
<td align="center" width="33%"><img src="../assets/images/backup-restore/consent-history-after-deletion.png" alt="Consent history after deletion" /></td>
</tr>
</table>

</details>

<details open id="panel-share-credentials">
<summary><strong>Sharing Credentials</strong></summary>

Respond to a verifier's data request using the OID4VP share flow. You open a share request by pasting its URL, the app finds the matching credentials in your vault, and you choose which one(s) to share before submitting. When more than one credential matches the request, tap the credential name to choose which one to share.

<table>
<tr>
<td align="center" width="33%"><strong>1. Open your Vault</strong></td>
<td align="center" width="33%"><strong>2. Tap Share</strong></td>
<td align="center" width="33%"><strong>3. Paste the share request URL</strong></td>
</tr>
<tr>
<td align="center" width="33%"><img src="../assets/images/share-credentials/vault.png" alt="Open your Vault to share a credential" /></td>
<td align="center" width="33%"><img src="../assets/images/share-credentials/share-credential.png" alt="Tap Share to start a share" /></td>
<td align="center" width="33%"><img src="../assets/images/share-credentials/request-url.png" alt="Paste the share request URL" /></td>
</tr>
<tr>
<td align="center" width="33%"><strong>4. Review the requested data</strong></td>
<td align="center" width="33%"><strong>5. Choose which credential to share</strong></td>
<td align="center" width="33%"><strong>6. Shared successfully</strong></td>
</tr>
<tr>
<td align="center" width="33%"><img src="../assets/images/share-credentials/share-your-data.png" alt="Review the requested data found in your vault" /></td>
<td align="center" width="33%"><img src="../assets/images/share-credentials/select-credential-to-share.png" alt="Choose which credential to share when multiple match" /></td>
<td align="center" width="33%"><img src="../assets/images/share-credentials/shared-successfully.png" alt="Credential shared successfully" /></td>
</tr>
</table>

</details>
