#include <sophia.h>

int sp_dir(void *env, uint32_t flags, char *dirname)
{
    return sp_ctl(env, SPDIR, flags, dirname);
}

int sp_set_key_comparison(void *env, spcmpf func, void *arg)
{
    return sp_ctl(env, SPCMP, func, arg);
}

int sp_set_keys_per_page(void *env, uint32_t count)
{
    return sp_ctl(env, SPPAGE, count);
}

int sp_set_gc_enabled(void *env, int enabled)
{
    return sp_ctl(env, SPGC, enabled);
}

int sp_set_gcf(void *env, double factor)
{
    return sp_ctl(env, SPGCF, factor);
}

int sp_grow(void *env, uint32_t new_size, double resize)
{
    return sp_ctl(env, SPGROW, new_size, resize);
}

/* create merger thread upon open() */
int sp_set_merge_enabled(void *env, int enabled)
{
    return sp_ctl(env, SPMERGE, enabled);
}

int sp_set_merge_watermark(void *env, uint32_t wm)
{
    return sp_ctl(env, SPMERGEWM, wm);
}

/* major/minor just a guess */
int sp_get_version(void *env, uint32_t *major, uint32_t *minor)
{
    return sp_ctl(env, SPVERSION, major, minor);
}
