# android_kernel_realme_mt6991

Single-repo kernel **workspace** for the realme RMX6688 (realme GT7, CN) — MediaTek **MT6991**,
Android 16 / LineageOS 23.2.

It is a verbatim merge of the two halves realme publishes, laid out the way the MTK build
expects (`kernel-6.6` next to `kernel/`), so one clone is a buildable workspace.

## Layout

```
kernel-6.6/            GKI common kernel 6.6.89 (snapshot, no upstream history)
kernel/                from the vendor half
├── build/             kleaf + bazel_mgk_rules
├── kernel_device_modules-6.6/   MTK drivers, mt6991 DTS (338 MB)
├── oplus/             Oplus bazel glue
├── tools/bazel
├── WORKSPACE
└── kernel-6.6 -> ../kernel-6.6
vendor/
├── mediatek/kernel_modules/     gpu (mali-r49p1), connectivity (gen4m), mtkcam, udc, …
└── oplus/kernel/                30 subsystems (touchpanel, vibrator, charger, camera, …)
scripts/sync-upstream.sh
```

## Sources

| Half | Upstream | Snapshot |
|---|---|---|
| GKI | `realme-kernel-opensource/realme_gt7-AndroidB-kernel-source` | `d93723d4f66c` (6.6.89, `BRANCH=android15-6.6`, `KMI_GENERATION=8`) |
| Vendor | `realme-kernel-opensource/realme_gt7-AndroidB-vendor-source` | `3fe6bdc55` (RMX6688_16.0.0.212) |

The GKI half is imported as a **snapshot** (`git archive` of the upstream tip), not with upstream
history, and every upstream drop is a squashed snapshot anyway.

## Build (kleaf)

`_setup_env.sh` expects `prebuilts/` under the workspace root it runs from (`<ws>/kernel/`).
They are **not** committed. Point them at an AOSP/LineageOS prebuilts tree and add the clang
version the tree declares (`r510928`):

```bash
ln -s /path/to/lineage-23.2/prebuilts kernel/prebuilts      # after adding clang-r510928
cd kernel
PROJECT=mgk_64_k66 MODE=user ./kernel_device_modules-6.6/build.sh
# outputs: kernel/out/dist/kernel_device_modules-6.6/mgk_64_k66_*
```

The GKI `Image` and the vendor/system_dlkm modules come out of the same build, so their
modversion CRCs always match each other.

## Sync upstream

```bash
# vendor half (this repo's root history is the vendor repo)
git fetch realme-vendor master && git merge --no-edit realme-vendor/master

# GKI half (re-imports the snapshot into kernel-6.6/)
scripts/sync-upstream.sh
```

## Notes

- Branch `lineage-23.2` tracks the LineageOS 23.2 device bring-up.
- 738 module names are expected; 717 have source in this tree. The ~21 missing ones
  (`oplus_network_*` acceleration family, `oplus_powermodel*`, other projects' camera/panel
  drivers, `wonder`) are not available upstream — keep them as prebuilts or drop them.
- No prebuilts, no `out/`, no vendor blobs are committed here.
- Kernel code is GPL-2.0; the vendor half is published by realme under the same terms.
