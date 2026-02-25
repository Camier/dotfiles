#!/bin/sh
# Shared Conda/Mamba shell policy for bash and zsh.

# Post-init hook for conda shell setup. Keep policy guidance centralized.
conda_policy_after_init() {
    # Keep PYTHONNOUSERSITE scoped per environment:
    #   conda env config vars set PYTHONNOUSERSITE=1 -n <env>
    # This avoids leaking into non-conda Python after `conda deactivate`.
    
    # Auto-export PYTHONNOUSERSITE for all conda environments
    # Prevents user site-packages from leaking into isolated envs
    export PYTHONNOUSERSITE=1
    
    return 0
}

# Return non-zero when pip install should be blocked in conda base.
conda_policy_pip_install_allowed() {
    _pip_cmd="$1"
    if [ "$_pip_cmd" = "install" ] && [ "${CONDA_DEFAULT_ENV-}" = "base" ] && [ "${PIP_ALLOW_BASE:-0}" != "1" ]; then
        echo "ERROR: pip install in base is blocked. Use 'mamba install' or a dedicated environment." >&2
        echo "Override with: PIP_ALLOW_BASE=1 pip install ..." >&2
        unset _pip_cmd
        return 1
    fi
    unset _pip_cmd
    return 0
}
