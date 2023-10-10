import numpy as np

def _extract_3d_patches(arr, patch_radius):
    """ Extract 3D patches from 4D DWI data. """

    patch_radius = np.atleast_1d(patch_radius).astype(int)
    if patch_radius.size != 3:
        raise ValueError("patch_radius should have length 3")

    patch_size = 2 * patch_radius + 1
    dim = arr.shape[-1]

    # Calculate total number of patches and preallocate memory
    num_patches = (
        (arr.shape[0] - 2*patch_radius[0]) *
        (arr.shape[1] - 2*patch_radius[1]) *
        (arr.shape[2] - 2*patch_radius[2])
    )
    all_patches = np.empty((np.prod(patch_size), num_patches * dim), dtype=arr.dtype)

    patch_volume = np.prod(patch_size)
    
    # Calculate patch indices
    for counter, i in enumerate(range(patch_radius[0], arr.shape[0] - patch_radius[0])):
        for j in range(patch_radius[1], arr.shape[1] - patch_radius[1]):
            for k in range(patch_radius[2], arr.shape[2] - patch_radius[2]):
                # More efficient slicing
                patch = arr[
                    i-patch_radius[0]:i+patch_radius[0]+1, 
                    j-patch_radius[1]:j+patch_radius[1]+1, 
                    k-patch_radius[2]:k+patch_radius[2]+1
                ].ravel()
                
                # Direct assignment using computed indices
                all_patches[:, counter*dim:(counter+1)*dim] = patch[:, np.newaxis]

    return all_patches
