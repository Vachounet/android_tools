
# Android tools
Collection of scripts to help with Android ROM stuff.  
  
**Setup**:  
`chmod +x setup.sh`  
`sudo ./setup.sh`
  
1. **common_blobs.sh**: A script to list common and device specific blob's between two ROM's.  
Usage:  
`./tools/common_blobs.sh <path to source rom dump> <path to target rom dump>`

2. **common_props.sh**: A script to list common and device specific prop's between two ROM's.  
Usage:  
`./tools/common_props.sh <path to source rom dump> <path to target rom dump>`

3. **deltaota.sh**: A script to extract delta OTA.  
Usage:   
`./tools/deltaota.sh <path to full OTA> <path to patch OTA>`

4. **dt_repos.sh**: A script to create Device, kernel & vendor tree of a device in GitHub with model as repo descripton.  
Usage:  
`export GIT_TOKEN=<KEY>`  
`./tools/dt_repos.sh <path to rom>`

5. **dummy_dt.sh**: A script which prepares a dummy device tree from ROM dump. Can handle dump stored both locally OR in online git repository (as long as all_files.txt exists in its root). See its GitHub [repo](https://github.com/ShivamKumarJha/Dummy_DT/).  
Usage:  
Usage: `./tools/dummy_dt.sh <path to ROM dump OR raw link of dump repo>`  
*Optional*:  
For Telegram notification, `export TG_API=<KEY>` before running script.

6. **dump_push.sh**: A script to push local dump to GitHib.  
Usage:  
`export GIT_TOKEN=<KEY>`  
`./tools/dump_push.sh <path to xml(s)>`

7. **dumpyara_blobs_downloader.sh**: A script to download selected blobs from [AndroidDumps](https://github.com/AndroidDumps) repo, https://del.dog/denadegebi.  
Usage:  
`./tools/dumpyara_blobs_downloader.sh <raw dump repo URL> <path to proprietary-files.txt>`

8. **proprietary-files.sh**: A script to prepare proprietary blobs list from ROM.  
Usage:  
For online git repo: `./tools/proprietary-files.sh <raw file link of all_files.txt>`  
For local dump: `./tools/proprietary-files.sh <path to ROM dump OR path to all_files.txt>`

9. **rebase_kernel.sh**: A script to rebase OEM compressed kernel source to its best CAF base.  
Usage:  
`./tools/rebase_kernel.sh <kernel zip link/file> <repo name> <tag suffix>`

10. **rom_compare.sh**: A script to compare source & target ROM. It lists `Added, common, missing & modified` blobs.  
Usage:  
`./tools/rom_compare.sh <path to source ROM dump> <path to target ROM dump>`

11. **rom_extract.sh**: A script to extract OTA files.  
Usage:  
`./tools/rom_extract.sh <path to OTA file(s)>`

12. **rootdir.sh**: A script to prepare rootdir from a ROM dump along with Makefile.  
Usage:  
`./tools/rootdir.sh <path to ROM dump>`

13. **sony_rom.sh**: A script to extract Sony ftf ROM.  
Usage:  
`./tools/sony_rom.sh <path to ROM dump>`

14. **system_vendor_prop.sh**: A script to prepare properties Makefile from a ROM dump.  
Usage: `./tools/system_vendor_prop.sh <path to ROM dump>`  
Output: `system.prop` & `vendor_prop.mk` files.  

15. **vendor_prop.sh**: A script to prepare and filter properties Makefile from a ROM dump.  
Usage: `./tools/vendor_prop.sh <path to ROM dump>`  
Output: `vendor_prop.mk` file.  

16. **vendor_tree.sh**: A script to prepare vendor tree from a ROM dump after generating proprietary-files.txt and push it to GitHub.  
To extract from a specific proprietary-files.txt, place it before in `working/proprietary-files.txt`.  
Usage:  
`export GIT_TOKEN=<KEY>`  
`./tools/vendor_tree.sh <path to ROM dump>`  
