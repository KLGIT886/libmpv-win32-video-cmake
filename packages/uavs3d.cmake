if(${TARGET_CPU} MATCHES "x86_64|i686")
ExternalProject_Add(uavs3d
    GIT_REPOSITORY https://github.com/uavs3/uavs3d.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    UPDATE_COMMAND ""
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
else()
    # aarch64 下 uavs3d 的 decore/arm64/*.S 交给 clang 集成汇编器会报
    # "expected absolute expression"（宏内非绝对表达式），无法交叉编译。
    # 这里按 packages/vapoursynth.cmake 的写法建一个空 ExternalProject 占位，
    # 保证 uavs3d-download / uavs3d-fullclean 等聚合目标与 ffmpeg 的 DEPENDS 有效；
    # 对应地 packages_check.cmake 在 aarch64 下传 --disable-libuavs3d。
    ExternalProject_Add(uavs3d
        DOWNLOAD_COMMAND ""
        UPDATE_COMMAND ""
        PATCH_COMMAND ""
        CONFIGURE_COMMAND ""
        BUILD_COMMAND ""
        INSTALL_COMMAND ""
        LOG_DOWNLOAD 1 LOG_UPDATE 1
    )
    cleanup(uavs3d install)
endif()
