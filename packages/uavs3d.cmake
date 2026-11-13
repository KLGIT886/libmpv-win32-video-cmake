ExternalProject_Add(uavs3d
    GIT_REPOSITORY https://github.com/uavs3/uavs3d.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    UPDATE_COMMAND ""
    # aarch64 目标为 COFF：clang 的 COFF 汇编器把 .type 解析成 .def 块内的
    # 数值类型（"expected absolute expression"），故给 def_arm64.S 打补丁在
    # _WIN32 下不生成 .type。git apply 不依赖历史，--filter=tree:0 可用。
    PATCH_COMMAND ${EXEC} git apply ${CMAKE_CURRENT_SOURCE_DIR}/uavs3d-*.patch
    CONFIGURE_COMMAND ${EXEC} CONF=1 cmake -H<SOURCE_DIR> -B<BINARY_DIR>
        -G Ninja
        -DCMAKE_BUILD_TYPE=Release
        -DCMAKE_TOOLCHAIN_FILE=${TOOLCHAIN_FILE}
        -DCMAKE_INSTALL_PREFIX=${MINGW_INSTALL_PREFIX}
        -DCMAKE_FIND_ROOT_PATH=${MINGW_INSTALL_PREFIX}
        -DBUILD_SHARED_LIBS=OFF
        -DCOMPILE_10BIT=ON
        -DCMAKE_POLICY_VERSION_MINIMUM=3.5
    BUILD_COMMAND ${EXEC} ninja -C <BINARY_DIR>
    INSTALL_COMMAND ${EXEC} ninja -C <BINARY_DIR> install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(uavs3d)
cleanup(uavs3d install)
