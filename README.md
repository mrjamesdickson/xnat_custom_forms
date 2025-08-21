# XNAT Custom Forms Bundle

This bundle contains four ready-to-import Custom Forms for XNAT and a helper script to upload them via the API.

## Contents
- subject_consent.json  — Subject-level consent capture (site-wide)
- mri_safety_short.json — Subject-level MRI safety screener (project-specific: change 'proj1')
- mr_session_qc.json    — MR session QC checklist (site-wide)
- project_intake.json   — Project intake metadata (site-wide)
- upload_forms.sh       — Bash script to upload the forms with curl
- .env.example          — Example environment configuration

## Quick Start
1) Copy `.env.example` to `.env` and set:
```
BASE_URL=https://your-xnat
XNAT_TOKEN=your_pat_token   # or XNAT_USER/XNAT_PASS
```
2) Run the upload:
```
chmod +x upload_forms.sh
./upload_forms.sh *.json
```
3) Verify in XNAT: Tools → Custom Forms → Manage Data Forms.

### Notes
- `mri_safety_short.json` currently targets project `proj1`. Edit the `"submission.data.xnatProject"` array to your project ID(s) before uploading, or change it afterwards in the UI.
- If you re-upload a JSON, XNAT will create a new form UUID. If you intend to *update* a form, use the UI editor or the specific update endpoint with the existing UUID.

- pet_session_qc.json   — PET session QC checklist (site-wide)

## Added forms
- ct_contrast_administration.json
- ct_dose_summary.json
- ct_session_qc.json
- mr_bids_metadata.json
- mr_contrast_administration.json
- mr_phantom_acr_qc.json
- mr_phantom_fbirn_qc.json
- mr_protocol_capture.json
- pet_acquisition_log.json
- pet_dose_log.json
- pet_mr_attenuation_qc.json
- project_data_transfer_plan.json
- project_image_processing_plan.json
- project_imaging_deviation_log.json
- project_randomization_blinding_log.json
- project_site_readiness.json
- subject_adverse_events.json
- subject_allergies.json
- subject_conmeds.json
- subject_demographics.json
- subject_inclusion_exclusion.json
- subject_medical_history.json
- subject_pregnancy_test.json
- subject_withdrawal.json
